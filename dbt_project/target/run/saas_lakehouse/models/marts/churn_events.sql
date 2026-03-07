create or replace view default.churn_events
  
  
  as
    

SELECT
    subscription_id,
    user_id,
    plan_id,
    last_updated AS churn_date

FROM default.table_subscription_snapshot

WHERE status = 'cancelled'
