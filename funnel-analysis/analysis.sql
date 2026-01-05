-- Funnel Step Counts (CTE)
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
    COUNT(*) AS total_users,
    SUM(signup) AS signed_up,
    SUM(view_product) AS viewed_product,
    SUM(add_to_cart) AS added_to_cart,
    SUM(purchase) AS purchased
FROM funnel;

-- Conversion Rates Between Funnel Steps
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
    ROUND(SUM(view_product) * 100.0 / SUM(signup), 2) AS signup_to_view_pct,
    ROUND(SUM(add_to_cart) * 100.0 / SUM(view_product), 2) AS view_to_cart_pct,
    ROUND(SUM(purchase) * 100.0 / SUM(add_to_cart), 2) AS cart_to_purchase_pct
FROM funnel;

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
