create or replace view default.staging_invoices
  
  
  as
    SELECT *
FROM parquet.`/delta/silver/invoices_current`
