
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select churn_date
from default.churn_events
where churn_date is null



  
  
      
    ) dbt_internal_test