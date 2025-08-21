
    -- Create target schema if it does not
  USE [ReadmitDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
  BEGIN
    EXEC('CREATE SCHEMA [dbo]')
  END

  

  
  EXEC('create view 
    [dbo].[testview_ca5f2c44061a50ea3f645d645250418e_4267]
   as 
    
    
    

select
    patient_id as unique_field,
    count(*) as n_records

from "ReadmitDB"."dbo"."stg_patients"
where patient_id is not null
group by patient_id
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
    [dbo].[testview_ca5f2c44061a50ea3f645d645250418e_4267]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [dbo].[testview_ca5f2c44061a50ea3f645d645250418e_4267]
  ;')