create or replace view default.staging_users
  
  
  as
    SELECT *
FROM parquet.`/delta/silver/users_current`
