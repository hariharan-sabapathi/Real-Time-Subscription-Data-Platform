{{ config(materialized='view') }}

SELECT
    subscription_id,
    user_id,
    plan_id,
    last_updated AS churn_date

FROM {{ ref('table_subscription_snapshot') }}

WHERE status = 'cancelled'