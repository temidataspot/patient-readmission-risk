
    -- Create target schema if it does not
  USE [ReadmitDB];
  IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
  BEGIN
    EXEC('CREATE SCHEMA [dbo]')
  END

  

  
  EXEC('create view 
    [dbo].[testview_7e5205100ca21ba063b1798634d334a6_6794]
   as 
    
    
    

with child as (
    select admission_id as from_field
    from "ReadmitDB"."dbo"."stg_claims"
    where admission_id is not null
),

parent as (
    select admission_id as to_field
    from "ReadmitDB"."dbo"."stg_admissions"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  ;')
  select
    
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select * from 
    [dbo].[testview_7e5205100ca21ba063b1798634d334a6_6794]
  
  ) dbt_internal_test;

  EXEC('drop view 
    [dbo].[testview_7e5205100ca21ba063b1798634d334a6_6794]
  ;')