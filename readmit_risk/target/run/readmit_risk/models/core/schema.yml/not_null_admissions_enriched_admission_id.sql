
    -- Create target schema if it does not
  USE [ReadmitDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
  BEGIN
    EXEC('CREATE SCHEMA [dbo]')
  END

  

  
  EXEC('create view 
    [dbo].[testview_5c453eac14f4b87883608ab90631f899_2108]
   as 
    
    
    



select admission_id
from "ReadmitDB"."dbo"."admissions_enriched"
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
    [dbo].[testview_5c453eac14f4b87883608ab90631f899_2108]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [dbo].[testview_5c453eac14f4b87883608ab90631f899_2108]
  ;')