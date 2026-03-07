

SELECT
    subscription_id,
    user_id,
    plan_id,
    last_updated AS churn_date

FROM default.table_subscription_snapshot

WHERE status = 'cancelled'