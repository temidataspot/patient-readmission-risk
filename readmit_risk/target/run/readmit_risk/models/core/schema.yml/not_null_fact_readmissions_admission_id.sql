
    -- Create target schema if it does not
  USE [ReadmitDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
  BEGIN
    EXEC('CREATE SCHEMA [dbo]')
  END

  

  
  EXEC('create view 
    [dbo].[testview_8518c4118139c09c218337bd47c210bd_10869]
   as 
    
    
    



select admission_id
from "ReadmitDB"."dbo"."fact_readmissions"
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
    [dbo].[testview_8518c4118139c09c218337bd47c210bd_10869]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [dbo].[testview_8518c4118139c09c218337bd47c210bd_10869]
  ;')