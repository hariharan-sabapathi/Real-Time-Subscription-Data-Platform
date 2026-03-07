
      
  
    
        create or replace table snapshots.subscriptions_snapshot
      
      
    using delta
      
      
      
      
      
      

      as
      
    

    select *,
        md5(coalesce(cast(subscription_id as string ), '')
         || '|' || coalesce(cast(event_time as string ), '')
        ) as dbt_scd_id,
        event_time as dbt_updated_at,
        event_time as dbt_valid_from,
        
  
  coalesce(nullif(event_time, event_time), null)
  as dbt_valid_to
from (
        



SELECT
    subscription_id,
    user_id,
    plan_id,
    status,
    event_time
FROM default.staging_subscription

    ) sbq



  
  