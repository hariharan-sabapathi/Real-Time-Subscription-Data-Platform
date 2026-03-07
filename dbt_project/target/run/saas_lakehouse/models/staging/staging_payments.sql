create or replace view default.staging_payments
  
  
  as
    SELECT *
FROM parquet.`/delta/silver/payments_current`
