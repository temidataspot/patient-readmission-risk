
    -- Create target schema if it does not
  USE [ReadmitDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
  BEGIN
    EXEC('CREATE SCHEMA [dbo]')
  END

  

  
  EXEC('create view 
    [dbo].[testview_bed95e4e62bef66f3bfc252fbfff5807_5161]
   as 
    
    
    



select label_readmit_30
from "ReadmitDB"."dbo"."fact_readmissions"
where label_readmit_30 is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [dbo].[testview_bed95e4e62bef66f3bfc252fbfff5807_5161]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [dbo].[testview_bed95e4e62bef66f3bfc252fbfff5807_5161]
  ;')