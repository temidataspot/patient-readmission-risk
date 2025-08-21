

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
;