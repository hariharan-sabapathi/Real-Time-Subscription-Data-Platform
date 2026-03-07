

SELECT
    subscription_id,
    user_id,
    plan_id,
    status,
    event_time AS last_updated

FROM default.intermediate_subscription_improved