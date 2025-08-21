
  
    USE [ReadmitDB];
    USE [ReadmitDB];
    
    

    

    
    USE [ReadmitDB];
    EXEC('
        create view "dbo"."dim_patient__dbt_tmp__dbt_tmp_vw" as 

with adm_dx as (
  select patient_id,
    max(case when primary_icd10 = ''E11'' then 1 else 0 end) as ever_diabetes,
    max(case when primary_icd10 = ''I50'' then 1 else 0 end) as ever_heart_failure,
    max(case when primary_icd10 = ''J44'' then 1 else 0 end) as ever_copd,
    max(case when primary_icd10 = ''N18'' then 1 else 0 end) as ever_ckd
  from "ReadmitDB"."dbo"."stg_admissions"
  group by patient_id
)

select
  p.*,
  coalesce(ad.ever_diabetes,0) as ever_diabetes,
  coalesce(ad.ever_heart_failure,0) as ever_heart_failure,
  coalesce(ad.ever_copd,0) as ever_copd,
  coalesce(ad.ever_ckd,0) as ever_ckd
from "ReadmitDB"."dbo"."patients_enriched" p
left join adm_dx ad on p.patient_id = ad.patient_id
;
-- This query enriches patient data with chronic condition flags based on admissions.
-- It uses a common table expression (CTE) to determine if a patient has ever been  admitted with specific conditions (diabetes, heart failure, COPD, CKD).     
-- The main query selects all patient fields and joins the CTE to add the chronic condition flags.
-- The ''coalesce'' function is used to ensure that if a patient has never been admitted with a condition, the flag will default to 0.    
-- This query is suitable for staging in a data pipeline, providing a comprehensive view of patient data with chronic condition indicators.
-- The materialization is set to ''table'' for efficient querying and storage.
-- Adjust the conditions and flags as needed based on clinical guidelines or requirements.;
    ')

EXEC('
            SELECT * INTO "ReadmitDB"."dbo"."dim_patient__dbt_tmp" FROM "ReadmitDB"."dbo"."dim_patient__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS dbo.dim_patient__dbt_tmp__dbt_tmp_vw')



    
    use [ReadmitDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'dbo_dim_patient__dbt_tmp_cci'
        AND object_id=object_id('dbo_dim_patient__dbt_tmp')
    )
    DROP index "dbo"."dim_patient__dbt_tmp".dbo_dim_patient__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX dbo_dim_patient__dbt_tmp_cci
    ON "dbo"."dim_patient__dbt_tmp"

   


  