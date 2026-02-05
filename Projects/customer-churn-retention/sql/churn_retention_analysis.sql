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
WITH events AS (
  SELECT
    c.customer_id,
    DATE_TRUNC('month', c.signup_date) AS cohort_month,
    EXTRACT(MONTH FROM AGE(t.transaction_date, c.signup_date))::int AS months_since_signup
  FROM customers c
  JOIN transactions t USING (customer_id)
  WHERE t.transaction_date IS NOT NULL
)
SELECT
  cohort_month,
  months_since_signup,
  COUNT(DISTINCT customer_id) AS customers,
  ROUND(
    COUNT(DISTINCT customer_id)::numeric * 100.0 /
    MAX(COUNT(DISTINCT customer_id)) OVER (PARTITION BY cohort_month),
    2
  ) AS retention_percentage
FROM events
GROUP BY cohort_month, months_since_signup
ORDER BY cohort_month, months_since_signup;
