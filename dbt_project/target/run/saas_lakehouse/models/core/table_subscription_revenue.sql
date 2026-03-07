create or replace view default.table_subscription_revenue
  
  
  as
    

SELECT
    s.subscription_id,
    s.user_id,
    s.plan_id,
    p.plan_name,
    p.monthly_price,
    s.status,
    s.last_updated

FROM default.table_subscription_snapshot s

LEFT JOIN default.table_plans p
ON s.plan_id = p.plan_id
