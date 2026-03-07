SELECT
user_id,
COUNT(*) AS active_subscription_count
FROM {{ ref('intermediate_subscription_improved') }}
WHERE status = 'active'
GROUP BY user_id
HAVING COUNT(*) > 1