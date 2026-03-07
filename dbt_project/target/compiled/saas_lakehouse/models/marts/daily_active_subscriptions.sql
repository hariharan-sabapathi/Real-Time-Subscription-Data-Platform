

SELECT
    DATE(last_updated) AS activity_date,
    COUNT(subscription_id) AS active_subscriptions

FROM default.table_subscription_snapshot

WHERE status = 'active'

GROUP BY activity_date
ORDER BY activity_date