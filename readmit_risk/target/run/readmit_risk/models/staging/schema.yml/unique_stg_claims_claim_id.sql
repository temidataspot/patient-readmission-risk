
    -- Create target schema if it does not
  USE [ReadmitDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
  BEGIN
    EXEC('CREATE SCHEMA [dbo]')
  END

  

  
  EXEC('create view 
    [dbo].[testview_aff8bf6a2bd3d2a90b18a5ca79ffc0c3_16780]
   as 
    
    
    

select
    claim_id as unique_field,
    count(*) as n_records

from "ReadmitDB"."dbo"."stg_claims"
where claim_id is not null
group by claim_id
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
    [dbo].[testview_aff8bf6a2bd3d2a90b18a5ca79ffc0c3_16780]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [dbo].[testview_aff8bf6a2bd3d2a90b18a5ca79ffc0c3_16780]
  ;')