
    -- Create target schema if it does not
  USE [ReadmitDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
  BEGIN
    EXEC('CREATE SCHEMA [dbo]')
  END

  

  
  EXEC('create view 
    [dbo].[testview_6a74a5763996ca376649e01ff4c8b1f6_13053]
   as 
    
    
    

select
    rx_id as unique_field,
    count(*) as n_records

from "ReadmitDB"."dbo"."stg_pharmacy"
where rx_id is not null
group by rx_id
having count(*) > 1



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [dbo].[testview_6a74a5763996ca376649e01ff4c8b1f6_13053]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [dbo].[testview_6a74a5763996ca376649e01ff4c8b1f6_13053]
  ;')