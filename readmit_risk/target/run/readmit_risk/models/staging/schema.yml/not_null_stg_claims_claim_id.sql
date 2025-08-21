
    -- Create target schema if it does not
  USE [ReadmitDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
  BEGIN
    EXEC('CREATE SCHEMA [dbo]')
  END

  

  
  EXEC('create view 
    [dbo].[testview_e922bd79c0894ceb6644cf5252899b27_9846]
   as 
    
    
    



select claim_id
from "ReadmitDB"."dbo"."stg_claims"
where claim_id is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [dbo].[testview_e922bd79c0894ceb6644cf5252899b27_9846]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [dbo].[testview_e922bd79c0894ceb6644cf5252899b27_9846]
  ;')