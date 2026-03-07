create or replace view default.table_plans
  
  
  as
    

SELECT 1 AS plan_id, 'Basic' AS plan_name, 10 AS monthly_price
UNION ALL
SELECT 2, 'Pro', 25
UNION ALL
SELECT 3, 'Enterprise', 50
