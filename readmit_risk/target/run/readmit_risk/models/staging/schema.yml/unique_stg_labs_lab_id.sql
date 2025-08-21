
    -- Create target schema if it does not
  USE [ReadmitDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
  BEGIN
    EXEC('CREATE SCHEMA [dbo]')
  END

  

  
  EXEC('create view 
    [dbo].[testview_c6fa431daf884a6538e019e6f88b0e1b_13269]
   as 
    
    
    

select
    lab_id as unique_field,
    count(*) as n_records

from "ReadmitDB"."dbo"."stg_labs"
where lab_id is not null
group by lab_id
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
    [dbo].[testview_c6fa431daf884a6538e019e6f88b0e1b_13269]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [dbo].[testview_c6fa431daf884a6538e019e6f88b0e1b_13269]
  ;')