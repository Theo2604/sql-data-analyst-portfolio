-- Monthly revenue metrics
WITH monthly_metrics AS (
    SELECT
        DATE_TRUNC('month', o.order_date)::DATE AS month,
        SUM(oi.quantity * oi.unit_price) AS revenue,
        COUNT(DISTINCT o.order_id) AS order_count,
        COUNT(DISTINCT c.customer_id) AS customer_count
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY DATE_TRUNC('month', o.order_date)::DATE
)
SELECT
    month,
    revenue,
    order_count,
    customer_count,
    ROUND(revenue / NULLIF(order_count, 0), 2) AS avg_order_value,
    ROUND(revenue / NULLIF(customer_count, 0), 2) AS revenue_per_customer,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) AS revenue_growth,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0 / 
        NULLIF(LAG(revenue) OVER (ORDER BY month), 0), 
        2
    ) AS growth_percentage
FROM monthly_metrics
ORDER BY month;

-- Revenue breakdown
SELECT
    'Region' AS dimension_type,
    c.region AS dimension_value,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.region

UNION ALL

SELECT
    'Product',
    p.product_name,
    SUM(oi.quantity * oi.unit_price)
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name

UNION ALL

SELECT
    'Customer',
    c.customer_name,
    SUM(oi.quantity * oi.unit_price)
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_name;

-- kpi summary
SELECT
    ROUND(
        SUM(oi.quantity * oi.unit_price) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id;
