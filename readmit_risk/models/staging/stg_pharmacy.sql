{{ config(materialized='view') }}

-- stg_pharmacy: normalize prescriptions + numeric fields
select
  nullif(ltrim(rtrim(rx_id)), '')                           as rx_id,
  try_cast(admission_id as int)                             as admission_id,
  try_cast(patient_id as int)                               as patient_id,
  nullif(ltrim(rtrim(drug_name)), '')                       as drug_name,
  nullif(ltrim(rtrim(dose)), '')                            as dose,
  try_cast(start_date as date)                              as start_date,
  try_cast(days_supply as int)                              as days_supply,
  try_cast(adherence_rate as float)                         as adherence_rate,
  -- derived: expected end date of supply
  case when try_cast(start_date as date) is not null and try_cast(days_supply as int) is not null
       then dateadd(day, try_cast(days_supply as int), try_cast(start_date as date))
       else null end as expected_supply_end_date
from {{ ref('pharmacy') }}
;
