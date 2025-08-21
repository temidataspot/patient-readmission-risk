{{ config(materialized='table') }}

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
    when ses_index is not null and ses_index < 35 then 'low'
    when ses_index is not null and ses_index >= 35 and ses_index < 65 then 'mid'
    when ses_index is not null and ses_index >= 65 then 'high'
    else null end as ses_group
from {{ ref('stg_patients') }}
;
