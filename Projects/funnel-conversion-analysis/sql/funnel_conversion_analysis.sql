-- Funnel Metrics
WITH funnel_steps AS (
    SELECT
        user_id,
        MAX(CASE WHEN event_type = 'signup' THEN 1 ELSE 0 END) AS signed_up,
        MAX(CASE WHEN event_type = 'view_product' THEN 1 ELSE 0 END) AS viewed_product,
        MAX(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM events
    GROUP BY user_id
)
SELECT
    'Signup' AS funnel_step,
    SUM(signed_up) AS users,
    100.0 AS conversion_rate
FROM funnel_steps

UNION ALL

SELECT
    'View Product',
    SUM(viewed_product),
    ROUND(SUM(viewed_product) * 100.0 / NULLIF(SUM(signed_up), 0), 2)
FROM funnel_steps

UNION ALL

SELECT
    'Add to Cart',
    SUM(added_to_cart),
    ROUND(SUM(added_to_cart) * 100.0 / NULLIF(SUM(viewed_product), 0), 2)
FROM funnel_steps

UNION ALL

SELECT
    'Purchase',
    SUM(purchased),
    ROUND(SUM(purchased) * 100.0 / NULLIF(SUM(added_to_cart), 0), 2)
FROM funnel_steps

ORDER BY 
    CASE funnel_step
        WHEN 'Signup' THEN 1
        WHEN 'View Product' THEN 2
        WHEN 'Add to Cart' THEN 3
        WHEN 'Purchase' THEN 4
    END;

-- Drop-Off Analysis
WITH funnel AS (
    SELECT
        user_id,
        MAX(CASE WHEN event_type = 'signup' THEN 1 ELSE 0 END) AS signup,
        MAX(CASE WHEN event_type = 'view_product' THEN 1 ELSE 0 END) AS view_product,
        MAX(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchase
    FROM events
    GROUP BY user_id
)
SELECT
    COUNT(*) FILTER (WHERE signup = 1 AND view_product = 0) AS drop_after_signup,
    COUNT(*) FILTER (WHERE view_product = 1 AND add_to_cart = 0) AS drop_after_view,
    COUNT(*) FILTER (WHERE add_to_cart = 1 AND purchase = 0) AS drop_after_cart
FROM funnel;

-- Time to Purchase (Days)
WITH purchase_times AS (
    SELECT
        user_id,
        MIN(event_date) FILTER (WHERE event_type = 'signup') AS signup_date,
        MIN(event_date) FILTER (WHERE event_type = 'purchase') AS purchase_date
    FROM events
    GROUP BY user_id
)
SELECT
    user_id,
    purchase_date - signup_date AS days_to_purchase
FROM purchase_times
WHERE purchase_date IS NOT NULL;
