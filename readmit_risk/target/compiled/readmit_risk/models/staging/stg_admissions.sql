

-- stg_admissions: normalize dates, compute length_of_stay if missing
with raw as (
  select
    try_cast(admission_id as int) as admission_id,
    try_cast(patient_id as int)   as patient_id,
    try_cast(admit_date as date)  as admit_date,
    try_cast(discharge_date as date) as discharge_date,
    try_cast(length_of_stay as int) as length_of_stay_raw,
    nullif(ltrim(rtrim(department)), '') as department,
    upper(nullif(ltrim(rtrim(primary_icd10)), '')) as primary_icd10,
    nullif(ltrim(rtrim(payer)), '') as payer,
    try_cast(age as int) as age,
    try_cast(prior_admissions as int) as prior_admissions,
    try_cast(telehealth_followup as int) as telehealth_followup,
    try_cast(nurse_call as int) as nurse_call,
    try_cast(home_monitor as int) as home_monitor,
    try_cast(readmitted_30d as int) as readmitted_30d,
    try_cast(readmit_date as date) as readmit_date
  from "ReadmitDB"."dbo"."admissions"
)

select
  admission_id,
  patient_id,
  admit_date,
  discharge_date,
  -- if length_of_stay exists use it, otherwise compute via dates
  coalesce(length_of_stay_raw,
           case 
             when admit_date is not null and discharge_date is not null
             then datediff(day, admit_date, discharge_date)
             else null
           end) as length_of_stay,
  department,
  primary_icd10,
  payer,
  age,
  prior_admissions,
  telehealth_followup,
  nurse_call,
  home_monitor,
  readmitted_30d,
  readmit_date,
  -- derived: days to readmit (null if none)
  case 
    when readmit_date is not null and discharge_date is not null 
    then datediff(day, discharge_date, readmit_date) 
    else null 
  end as days_to_readmit,
  -- derived flag: readmitted within 30 days (safe fallback to readmitted_30d if present)
  case
    when readmitted_30d is not null then readmitted_30d
    when datediff(day, discharge_date, readmit_date) <= 30 then 1
    else 0
  end as readmitted_within_30
from raw
;