
    -- Create target schema if it does not
  USE [ReadmitDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
  BEGIN
    EXEC('CREATE SCHEMA [dbo]')
  END

  

  
  EXEC('create view 
    [dbo].[testview_9c3e890caa51fce66e84ba6ba2d5f68e_8762]
   as 
    
    
    



select patient_id
from "ReadmitDB"."dbo"."stg_admissions"
where patient_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [dbo].[testview_9c3e890caa51fce66e84ba6ba2d5f68e_8762]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [dbo].[testview_9c3e890caa51fce66e84ba6ba2d5f68e_8762]
  ;')