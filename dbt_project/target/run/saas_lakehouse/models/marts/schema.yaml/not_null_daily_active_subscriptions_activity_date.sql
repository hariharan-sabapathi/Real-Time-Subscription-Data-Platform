
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_date
from default.daily_active_subscriptions
where activity_date is null



  
  
      
    ) dbt_internal_test