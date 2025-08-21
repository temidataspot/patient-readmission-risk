

-- stg_labs: latest lab per admission is suitable for staging; cast numeric values
select
  nullif(ltrim(rtrim(lab_id)), '')                        as lab_id,
  try_cast(admission_id as int)                           as admission_id,
  try_cast(patient_id as int)                             as patient_id,
  try_cast(lab_date as date)                              as lab_date,
  try_cast(glucose_mgdl as float)                         as glucose_mgdl,
  try_cast(hba1c_pct as float)                            as hba1c_pct,
  try_cast(creatinine_mgdl as float)                      as creatinine_mgdl,
  try_cast(systolic_bp as int)                            as systolic_bp,
  -- simple abnormal flags (adjust thresholds as you prefer)
  case when try_cast(glucose_mgdl as float) > 180 then 1 else 0 end as high_glucose_flag,
  case when try_cast(hba1c_pct as float) > 8.0 then 1 else 0 end as high_hba1c_flag,
  case when try_cast(creatinine_mgdl as float) > 1.5 then 1 else 0 end as high_creatinine_flag,
  case when try_cast(systolic_bp as int) > 160 then 1 else 0 end as high_sbp_flag
from "ReadmitDB"."dbo"."labs"
;