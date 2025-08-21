
    -- Create target schema if it does not
  USE [ReadmitDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
  BEGIN
    EXEC('CREATE SCHEMA [dbo]')
  END

  

  
  EXEC('create view 
    [dbo].[testview_48a11f64092638cf50edc41f3f0fd15c_7584]
   as 
    
    
    

select
    patient_id as unique_field,
    count(*) as n_records

from "ReadmitDB"."dbo"."patients_enriched"
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
    [dbo].[testview_48a11f64092638cf50edc41f3f0fd15c_7584]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [dbo].[testview_48a11f64092638cf50edc41f3f0fd15c_7584]
  ;')