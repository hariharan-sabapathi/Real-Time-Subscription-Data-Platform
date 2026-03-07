
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select subscription_id
from default.intermediate_subscription_improved
where subscription_id is null



  
  
      
    ) dbt_internal_test