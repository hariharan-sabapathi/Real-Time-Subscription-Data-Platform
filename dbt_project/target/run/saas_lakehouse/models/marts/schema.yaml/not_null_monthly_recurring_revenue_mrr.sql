
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select mrr
from default.monthly_recurring_revenue
where mrr is null



  
  
      
    ) dbt_internal_test