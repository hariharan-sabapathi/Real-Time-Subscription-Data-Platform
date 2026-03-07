
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select plan_name
from default.revenue_by_plan
where plan_name is null



  
  
      
    ) dbt_internal_test