
  
    USE [ReadmitDB];
    USE [ReadmitDB];
    
    

    

    
    USE [ReadmitDB];
    EXEC('
        create view "dbo"."admissions_enriched__dbt_tmp__dbt_tmp_vw" as 

with a as (
  select * from "ReadmitDB"."dbo"."stg_admissions"
)

select
  admission_id,
  patient_id,
  admit_date,
  discharge_date,
  coalesce(length_of_stay, datediff(day, admit_date, discharge_date)) as length_of_stay,
  department,
  primary_icd10,
  payer,
  age,
  prior_admissions,
  telehealth_followup,
  nurse_call,
  home_monitor,
  readmitted_30d,
  readmit_date,
  case 
    when readmit_date is not null and discharge_date is not null
    then datediff(day, discharge_date, readmit_date) else null end as days_to_readmit,
  case
    when readmitted_30d is not null then readmitted_30d
    when readmit_date is not null and datediff(day, discharge_date, readmit_date) <= 30 then 1
    else 0
  end as readmitted_within_30
from a
;;
    ')

EXEC('
            SELECT * INTO "ReadmitDB"."dbo"."admissions_enriched__dbt_tmp" FROM "ReadmitDB"."dbo"."admissions_enriched__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS dbo.admissions_enriched__dbt_tmp__dbt_tmp_vw')



    
    use [ReadmitDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'dbo_admissions_enriched__dbt_tmp_cci'
        AND object_id=object_id('dbo_admissions_enriched__dbt_tmp')
    )
    DROP index "dbo"."admissions_enriched__dbt_tmp".dbo_admissions_enriched__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX dbo_admissions_enriched__dbt_tmp_cci
    ON "dbo"."admissions_enriched__dbt_tmp"

   


  