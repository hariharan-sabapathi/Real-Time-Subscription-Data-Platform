
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select revenue_month
from default.monthly_recurring_revenue
where revenue_month is null



  
  
      
    ) dbt_internal_test