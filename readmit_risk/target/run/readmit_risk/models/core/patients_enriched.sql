
  
    USE [ReadmitDB];
    USE [ReadmitDB];
    
    

    

    
    USE [ReadmitDB];
    EXEC('
        create view "dbo"."patients_enriched__dbt_tmp__dbt_tmp_vw" as 

select
  patient_id,
  gender,
  ethnicity,
  smoker,
  alcohol_use,
  bmi,
  ses_index,
  birth_year,
  -- approximate age now
  (year(getdate()) - try_cast(birth_year as int)) as age,
  case
    when ses_index is not null and ses_index < 35 then ''low''
    when ses_index is not null and ses_index >= 35 and ses_index < 65 then ''mid''
    when ses_index is not null and ses_index >= 65 then ''high''
    else null end as ses_group
from "ReadmitDB"."dbo"."stg_patients"
;;
    ')

EXEC('
            SELECT * INTO "ReadmitDB"."dbo"."patients_enriched__dbt_tmp" FROM "ReadmitDB"."dbo"."patients_enriched__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS dbo.patients_enriched__dbt_tmp__dbt_tmp_vw')



    
    use [ReadmitDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'dbo_patients_enriched__dbt_tmp_cci'
        AND object_id=object_id('dbo_patients_enriched__dbt_tmp')
    )
    DROP index "dbo"."patients_enriched__dbt_tmp".dbo_patients_enriched__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX dbo_patients_enriched__dbt_tmp_cci
    ON "dbo"."patients_enriched__dbt_tmp"

   


  