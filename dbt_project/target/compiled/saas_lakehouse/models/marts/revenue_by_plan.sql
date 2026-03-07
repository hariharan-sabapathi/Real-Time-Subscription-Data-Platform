

SELECT
    plan_name,
    COUNT(subscription_id) AS active_subscriptions,
    SUM(monthly_price) AS total_revenue

FROM default.table_subscription_revenue

WHERE status = 'active'

GROUP BY plan_name