
    -- Create target schema if it does not
  USE [ReadmitDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
  BEGIN
    EXEC('CREATE SCHEMA [dbo]')
  END

  

  
  EXEC('create view 
    [dbo].[testview_94d3438421080892e10d8a24b6a606e2_6701]
   as 
    
    
    



select patient_id
from "ReadmitDB"."dbo"."patients_enriched"
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
    [dbo].[testview_94d3438421080892e10d8a24b6a606e2_6701]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [dbo].[testview_94d3438421080892e10d8a24b6a606e2_6701]
  ;')