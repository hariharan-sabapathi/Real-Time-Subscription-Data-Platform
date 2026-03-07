create or replace view default.staging_subscription
  
  
  as
    SELECT *
FROM parquet.`/delta/silver/subscriptions_current`
