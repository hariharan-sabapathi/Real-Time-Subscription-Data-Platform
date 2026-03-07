
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  SELECT
user_id,
COUNT(*) AS active_subscription_count
FROM default.intermediate_subscription_improved
WHERE status = 'active'
GROUP BY user_id
HAVING COUNT(*) > 1
  
  
      
    ) dbt_internal_test