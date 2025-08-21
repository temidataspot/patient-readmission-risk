
    -- Create target schema if it does not
  USE [ReadmitDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
  BEGIN
    EXEC('CREATE SCHEMA [dbo]')
  END

  

  
  EXEC('create view 
    [dbo].[testview_2bcb223dc5bca2da23afd36b351f4f8b_6671]
   as 
    
    
    

select
    admission_id as unique_field,
    count(*) as n_records

from "ReadmitDB"."dbo"."admissions_enriched"
where admission_id is not null
group by admission_id
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
    [dbo].[testview_2bcb223dc5bca2da23afd36b351f4f8b_6671]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [dbo].[testview_2bcb223dc5bca2da23afd36b351f4f8b_6671]
  ;')