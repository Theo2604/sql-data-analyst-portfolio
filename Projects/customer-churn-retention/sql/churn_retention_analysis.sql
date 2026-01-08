-- Last Transaction per Customer (CTE)
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
    lt.last_txn_date
FROM customers c
LEFT JOIN last_transaction lt
ON c.customer_id = lt.customer_id;

-- Identify Churned Customers
-- Definition: No transaction in the last 90 days
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

-- Customer Lifetime (in Days)
WITH customer_lifetime AS (
    SELECT
        customer_id,
        MIN(transaction_date) AS first_txn,
        MAX(transaction_date) AS last_txn
    FROM transactions
    GROUP BY customer_id
)
SELECT
    customer_id,
    last_txn - first_txn AS lifetime_days
FROM customer_lifetime;

-- Monthly Retention Table (CTE + Window Function)
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
    END) AS retained_customers
FROM retention
GROUP BY month
ORDER BY month;

-- Churn Rate
WITH churn_status AS (
    SELECT
        c.customer_id,
        CASE
            WHEN MAX(t.transaction_date) < CURRENT_DATE - INTERVAL '90 days'
            OR MAX(t.transaction_date) IS NULL
            THEN 1 ELSE 0
        END AS is_churned
    FROM customers c
    LEFT JOIN transactions t
    ON c.customer_id = t.customer_id
    GROUP BY c.customer_id
)
SELECT
    ROUND(SUM(is_churned) * 100.0 / COUNT(*), 2) AS churn_rate_percentage
FROM churn_status;
