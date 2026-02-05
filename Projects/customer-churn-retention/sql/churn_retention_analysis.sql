-- Churn analysis
WITH last_transaction AS (
    SELECT
        customer_id,
        MAX(transaction_date) AS last_txn_date
    FROM transactions
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.signup_date,
    lt.last_txn_date,
    CASE
        WHEN lt.last_txn_date < CURRENT_DATE - INTERVAL '90 days'
             OR lt.last_txn_date IS NULL
        THEN 'Churned'
        ELSE 'Active'
    END AS customer_status
FROM customers c
LEFT JOIN last_transaction lt
ON c.customer_id = lt.customer_id;

-- Retention metrics
WITH monthly_activity AS (
    SELECT DISTINCT
        customer_id,
        DATE_TRUNC('month', transaction_date) AS month
    FROM transactions
),
retention AS (
    SELECT
        customer_id,
        month,
        LAG(month) OVER (PARTITION BY customer_id ORDER BY month) AS prev_month
    FROM monthly_activity
)
SELECT
    month,
    COUNT(DISTINCT customer_id) AS active_customers,
    COUNT(DISTINCT CASE
        WHEN prev_month = month - INTERVAL '1 month'
        THEN customer_id
    END) AS retained_customers,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN prev_month = month - INTERVAL '1 month'
            THEN customer_id
        END) * 100.0 / 
        NULLIF(LAG(COUNT(DISTINCT customer_id)) OVER (ORDER BY month), 0),
        2
    ) AS retention_rate
FROM retention
GROUP BY month
ORDER BY month;

-- Cohort analysis
WITH cohort_base AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', signup_date) AS cohort_month,
        DATE_TRUNC('month', transaction_date) AS transaction_month,
        EXTRACT(MONTH FROM AGE(transaction_date, signup_date)) AS months_since_signup
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    WHERE transaction_date IS NOT NULL
)
SELECT
    cohort_month,
    months_since_signup,
    COUNT(DISTINCT customer_id) AS customers,
    ROUND(
        COUNT(DISTINCT customer_id) * 100.0 /
        FIRST_VALUE(COUNT(DISTINCT customer_id)) OVER (
            PARTITION BY cohort_month 
            ORDER BY months_since_signup
        ),
        2
    ) AS retention_percentage
FROM cohort_base
GROUP BY cohort_month, months_since_signup
ORDER BY cohort_month, months_since_signup;
