

with a as (
  select * from "ReadmitDB"."dbo"."stg_admissions"
)

select
  admission_id,
  patient_id,
  admit_date,
  discharge_date,
  coalesce(length_of_stay, datediff(day, admit_date, discharge_date)) as length_of_stay,
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
  case 
    when readmit_date is not null and discharge_date is not null
    then datediff(day, discharge_date, readmit_date) else null end as days_to_readmit,
  case
    when readmitted_30d is not null then readmitted_30d
    when readmit_date is not null and datediff(day, discharge_date, readmit_date) <= 30 then 1
    else 0
  end as readmitted_within_30
from a
;