
  
    USE [ReadmitDB];
    USE [ReadmitDB];
    
    

    

    
    USE [ReadmitDB];
    EXEC('
        create view "dbo"."features_ml__dbt_tmp__dbt_tmp_vw" as 

select
  f.admission_id,
  f.patient_id,
  dp.age,
  dp.gender,
  dp.ethnicity,
  dp.bmi,
  dp.ses_group,
  dp.ever_diabetes,
  dp.ever_heart_failure,
  dp.ever_copd,
  dp.ever_ckd,
  f.length_of_stay,
  f.prior_admissions,
  f.department,
  f.sum_billed,
  f.sum_paid,
  f.avg_adherence,
  f.high_hba1c_flag,
  f.label_readmit_30 as readmit_label
from "ReadmitDB"."dbo"."fact_readmissions" f
left join "ReadmitDB"."dbo"."dim_patient" dp on f.patient_id = dp.patient_id
;;
    ')

EXEC('
            SELECT * INTO "ReadmitDB"."dbo"."features_ml__dbt_tmp" FROM "ReadmitDB"."dbo"."features_ml__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS dbo.features_ml__dbt_tmp__dbt_tmp_vw')



    
    use [ReadmitDB];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'dbo_features_ml__dbt_tmp_cci'
        AND object_id=object_id('dbo_features_ml__dbt_tmp')
    )
    DROP index "dbo"."features_ml__dbt_tmp".dbo_features_ml__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX dbo_features_ml__dbt_tmp_cci
    ON "dbo"."features_ml__dbt_tmp"

   


  