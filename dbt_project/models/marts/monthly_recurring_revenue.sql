{{ config(materialized='view') }}

SELECT
    DATE_TRUNC('month', last_updated) AS revenue_month,
    SUM(monthly_price) AS mrr

FROM {{ ref('table_subscription_revenue') }}

WHERE status = 'active'

GROUP BY revenue_month
ORDER BY revenue_month