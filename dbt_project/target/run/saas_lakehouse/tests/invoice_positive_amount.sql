
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  SELECT *
FROM default.staging_invoices
WHERE amount <= 0
  
  
      
    ) dbt_internal_test