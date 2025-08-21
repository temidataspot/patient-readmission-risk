
    -- Create target schema if it does not
  USE [ReadmitDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
  BEGIN
    EXEC('CREATE SCHEMA [dbo]')
  END

  

  
  EXEC('create view 
    [dbo].[testview_c03fc203d4c060e84c3dc7fa32d2295a_16578]
   as 
    
    
    



select admission_id
from "ReadmitDB"."dbo"."stg_claims"
where admission_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [dbo].[testview_c03fc203d4c060e84c3dc7fa32d2295a_16578]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [dbo].[testview_c03fc203d4c060e84c3dc7fa32d2295a_16578]
  ;')