{{ config(materialized='view') }}

SELECT
    user_id,
    email,
    event_time AS created_at

FROM {{ ref('staging_users') }}