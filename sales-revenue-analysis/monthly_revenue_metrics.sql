-- monthly_revenue_metrics.sql
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        SUM(oi.quantity * oi.unit_price) AS revenue,
        COUNT(DISTINCT o.order_id) AS order_count,
        COUNT(DISTINCT c.customer_id) AS customer_count
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY 1
)
SELECT
    month,
    revenue,
    order_count,
    customer_count,
    revenue / order_count AS avg_order_value,
    revenue / customer_count AS revenue_per_customer,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) AS revenue_growth
FROM monthly_revenue
ORDER BY month;
