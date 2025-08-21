

select
  a.admission_id,
  a.patient_id,
  a.admit_date,
  a.discharge_date,
  a.length_of_stay,
  a.prior_admissions,
  a.department,
  a.primary_icd10,
  coalesce(c.sum_billed,0) as sum_billed,
  coalesce(c.sum_paid,0) as sum_paid,
  coalesce(p.avg_adherence, 0) as avg_adherence,
  coalesce(l.high_hba1c_flag,0) as high_hba1c_flag,
  a.readmitted_within_30 as label_readmit_30
from "ReadmitDB"."dbo"."admissions_enriched" a
left join "ReadmitDB"."dbo"."claims_agg" c   on a.admission_id = c.admission_id
left join "ReadmitDB"."dbo"."pharmacy_agg" p  on a.admission_id = p.admission_id
left join "ReadmitDB"."dbo"."labs_latest" l   on a.admission_id = l.admission_id
;
-- This query aggregates data from admissions, claims, pharmacy, and labs to create a comprehensive view of each admission.
-- It selects key fields from the admissions table and joins with aggregated claims, pharmacy, and labs data.
-- The 'coalesce' function is used to handle any null values in the claims and pharmacy data, ensuring that the final dataset is complete.  
-- The 'left join' ensures that even if there are no claims, pharmacy, or labs data for an admission, the admission record will still be included.
-- The materialization is set to 'table' for efficient querying and storage.
-- This query is suitable for staging in a data pipeline, providing a rich dataset for further analysis or modeling.