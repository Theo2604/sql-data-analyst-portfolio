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

