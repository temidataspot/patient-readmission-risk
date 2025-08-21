
    -- Create target schema if it does not
  USE [ReadmitDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
  BEGIN
    EXEC('CREATE SCHEMA [dbo]')
  END

  

  
  EXEC('create view 
    [dbo].[testview_01d2387f9cbc9946d6a351a30426951d_4233]
   as 
    
    
    



select lab_id
from "ReadmitDB"."dbo"."stg_labs"
where lab_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [dbo].[testview_01d2387f9cbc9946d6a351a30426951d_4233]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [dbo].[testview_01d2387f9cbc9946d6a351a30426951d_4233]
  ;')