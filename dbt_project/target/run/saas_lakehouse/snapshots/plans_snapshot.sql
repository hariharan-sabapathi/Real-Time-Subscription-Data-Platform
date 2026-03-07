
      
  
    
        create or replace table snapshots.plans_snapshot
      
      
    using delta
      
      
      
      
      
      

      as
      
    

    select *,
        md5(coalesce(cast(plan_id as string ), '')
         || '|' || coalesce(cast(
    current_timestamp()
 as string ), '')
        ) as dbt_scd_id,
        
    current_timestamp()
 as dbt_updated_at,
        
    current_timestamp()
 as dbt_valid_from,
        
  
  coalesce(nullif(
    current_timestamp()
, 
    current_timestamp()
), null)
  as dbt_valid_to
from (
        



SELECT
    plan_id,
    plan_name,
    monthly_price
FROM default.table_plans

    ) sbq



  
  