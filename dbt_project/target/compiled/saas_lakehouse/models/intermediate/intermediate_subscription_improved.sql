

WITH ranked_subscriptions AS (

    SELECT
        subscription_id,
        user_id,
        plan_id,
        status,
        operation,
        event_ts,
        event_time,

        ROW_NUMBER() OVER (
            PARTITION BY subscription_id
            ORDER BY event_ts DESC
        ) AS subscription_rank

    FROM default.staging_subscription

),

latest_subscription_events AS (

    SELECT *
    FROM ranked_subscriptions
    WHERE subscription_rank = 1

),

deduplicated_active_users AS (

    SELECT
        subscription_id,
        user_id,
        plan_id,
        status,
        event_time,

        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY event_time DESC
        ) AS user_rank

    FROM latest_subscription_events
    WHERE status = 'active'

),

final_subscriptions AS (

    SELECT
        subscription_id,
        user_id,
        plan_id,
        status,
        event_time
    FROM deduplicated_active_users
    WHERE user_rank = 1

)

SELECT * FROM final_subscriptions