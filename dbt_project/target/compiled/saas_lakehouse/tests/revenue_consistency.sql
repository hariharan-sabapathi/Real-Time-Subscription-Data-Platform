WITH plan_revenue AS (
SELECT SUM(total_revenue) AS revenue_by_plan
FROM default.revenue_by_plan
),

mrr_revenue AS (
SELECT SUM(mrr) AS total_mrr
FROM default.monthly_recurring_revenue
)

SELECT *
FROM plan_revenue p
JOIN mrr_revenue m
ON p.revenue_by_plan != m.total_mrr