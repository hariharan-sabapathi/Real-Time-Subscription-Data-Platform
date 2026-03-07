
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select active_subscriptions
from default.daily_active_subscriptions
where active_subscriptions is null



  
  
      
    ) dbt_internal_test