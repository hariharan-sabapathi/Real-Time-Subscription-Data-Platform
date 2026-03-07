create or replace view default.table_users
  
  
  as
    

SELECT
    user_id,
    email,
    event_time AS created_at

FROM default.staging_users
