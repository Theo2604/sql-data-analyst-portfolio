-- =========================================
-- PROJECT 1: SALES & REVENUE ANALYSIS
-- Tools: PostgreSQL
-- Skills: JOINs, CTEs, Window Functions, Subqueries
-- =========================================

-- -----------------------------------------
-- 1. Monthly Revenue and Month-over-Month Growth
-- -----------------------------------------
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY 1
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) AS revenue_growth
FROM monthly_revenue
ORDER BY month;


-- -----------------------------------------
-- 2. Revenue by Dimension (Region / Product / Customer)
-- -----------------------------------------
SELECT
    'Region' AS dimension_type,
    c.region AS dimension_value,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.region

UNION ALL

SELECT
    'Product',
    p.product_name,
    SUM(oi.quantity * oi.unit_price)
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_name

UNION ALL

SELECT
    'Customer',
    c.customer_name,
    SUM(oi.quantity * oi.unit_price)
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_name

ORDER BY revenue DESC;


-- -----------------------------------------
-- 3. KPI: Average Order Value (AOV)
-- -----------------------------------------
SELECT
    ROUND(
        SUM(oi.quantity * oi.unit_price)
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;

