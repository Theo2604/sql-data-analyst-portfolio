-- Churn analysis
WITH last_transaction AS (
    SELECT
        customer_id,
        MAX(transaction_date) AS last_txn_date,
        COUNT(*) AS total_transactions,
        SUM(amount) AS total_spent
    FROM transactions
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.signup_date,
    lt.last_txn_date,
    COALESCE(lt.total_transactions, 0) AS total_transactions,
    COALESCE(lt.total_spent, 0) AS total_spent,
    CASE
        WHEN lt.last_txn_date IS NULL THEN 'Never Active'
        WHEN lt.last_txn_date < CURRENT_DATE - INTERVAL '90 days' THEN 'Churned'
        ELSE 'Active'
    END AS customer_status,
    (CURRENT_DATE - COALESCE(lt.last_txn_date, c.signup_date))::integer AS days_inactive
FROM customers c
LEFT JOIN last_transaction lt
ON c.customer_id = lt.customer_id;

-- Retention metrics
WITH monthly_stats AS (
    SELECT
        DATE_TRUNC('month', t.transaction_date)::DATE AS month,
        COUNT(DISTINCT t.customer_id) AS active_customers,
        COUNT(DISTINCT CASE 
            WHEN EXISTS (
                SELECT 1
                FROM transactions t2
                WHERE t2.customer_id = t.customer_id
                  AND DATE_TRUNC('month', t2.transaction_date)::DATE = 
                      DATE_TRUNC('month', t.transaction_date)::DATE - INTERVAL '1 month'
            ) THEN t.customer_id 
        END) AS retained_customers
    FROM transactions t
    GROUP BY DATE_TRUNC('month', t.transaction_date)::DATE
)
SELECT
    month,
    active_customers,
    retained_customers,
    CASE
        WHEN LAG(active_customers) OVER (ORDER BY month) > 0
        THEN ROUND(
            (retained_customers::DECIMAL / 
             LAG(active_customers) OVER (ORDER BY month)::DECIMAL) * 100,
            2
        )
        ELSE NULL
    END AS retention_rate,
    active_customers - retained_customers AS new_actives
FROM monthly_stats
ORDER BY month;

-- Cohort analysis
WITH customer_cohorts AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', signup_date)::DATE AS cohort_month
    FROM customers
),
monthly_activity AS (
    SELECT DISTINCT
        c.customer_id,
        c.cohort_month,
        DATE_TRUNC('month', t.transaction_date)::DATE AS activity_month,
        (EXTRACT(YEAR FROM t.transaction_date) * 12 + EXTRACT(MONTH FROM t.transaction_date)) -
        (EXTRACT(YEAR FROM c.cohort_month) * 12 + EXTRACT(MONTH FROM c.cohort_month)) 
        AS months_since_signup
    FROM customer_cohorts c
    JOIN transactions t ON c.customer_id = t.customer_id
)
SELECT
    c.cohort_month,
    a.months_since_signup,
    COUNT(DISTINCT a.customer_id) AS customers,
    COUNT(DISTINCT c.customer_id) AS cohort_customers,
    ROUND(
        (COUNT(DISTINCT a.customer_id)::DECIMAL / 
         COUNT(DISTINCT c.customer_id)::DECIMAL) * 100,
        2
    ) AS retention_percentage
FROM customer_cohorts c
LEFT JOIN monthly_activity a 
    ON c.customer_id = a.customer_id 
    AND c.cohort_month = a.cohort_month
    AND a.months_since_signup >= 0
GROUP BY c.cohort_month, a.months_since_signup
ORDER BY c.cohort_month, a.months_since_signup;
