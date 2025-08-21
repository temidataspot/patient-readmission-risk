USE [ReadmitDB];
    
    

    

    
    USE [ReadmitDB];
    EXEC('
        create view "dbo"."labs_latest__dbt_tmp" as 

with ranked as (
  select
    lab_id,
    admission_id,
    patient_id,
    lab_date,
    glucose_mgdl,
    hba1c_pct,
    creatinine_mgdl,
    systolic_bp,
    row_number() over (partition by admission_id order by lab_date desc) as rn
  from "ReadmitDB"."dbo"."stg_labs"
)
select
  lab_id,
  admission_id,
  patient_id,
  lab_date,
  glucose_mgdl,
  hba1c_pct,
  creatinine_mgdl,
  systolic_bp,
  case when glucose_mgdl > 180 then 1 else 0 end as high_glucose_flag,
  case when hba1c_pct > 8.0 then 1 else 0 end as high_hba1c_flag,
  case when creatinine_mgdl > 1.5 then 1 else 0 end as high_creatinine_flag,
  case when systolic_bp > 160 then 1 else 0 end as high_sbp_flag
from ranked
where rn = 1
;
-- This query selects the latest lab results per admission, casting numeric values and flagging abnormal results.
-- It uses a common table expression (CTE) to rank labs by date and filters to keep only the most recent lab for each admission.
-- The flags indicate whether the lab results exceed predefined thresholds for glucose, HbA1c, creatinine, and systolic blood pressure.
-- Adjust the thresholds as needed based on clinical guidelines or requirements.
-- This query is suitable for staging in a data pipeline, ensuring that only the most relevant lab results are processed further.
-- The materialization is set to ''view'' for efficient querying and updates.;
    ')

