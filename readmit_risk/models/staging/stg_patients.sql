{{ config(materialized='view') }}

-- stg_patients: clean basic types and normalize text
select
  try_cast(patient_id as int)                                as patient_id,
  nullif(ltrim(rtrim(gender)), '')                           as gender,
  nullif(ltrim(rtrim(ethnicity)), '')                        as ethnicity,
  try_cast(smoker as int)                                    as smoker,
  try_cast(alcohol_use as int)                               as alcohol_use,
  try_cast(bmi as float)                                     as bmi,
  try_cast(ses_index as int)                                 as ses_index,
  try_cast(birth_year as int)                                as birth_year,
  -- approximate current age (useful if no birthdate available)
  (datepart(year, getdate()) - try_cast(birth_year as int))  as age_estimate
from {{ ref('patients') }}
;
