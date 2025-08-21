USE [ReadmitDB];
    
    

    

    
    USE [ReadmitDB];
    EXEC('
        create view "dbo"."stg_claims__dbt_tmp" as 

-- stg_claims: amounts to numeric, standardize codes
select
  nullif(ltrim(rtrim(claim_id)), '''')                       as claim_id,
  try_cast(admission_id as int)                            as admission_id,
  try_cast(patient_id as int)                              as patient_id,
  nullif(ltrim(rtrim(procedure_code)), '''')                 as procedure_code,
  try_cast(amount_billed  as decimal(12,2))                as amount_billed,
  try_cast(amount_paid    as decimal(12,2))                as amount_paid,
  try_cast(approved as int)                                as approved,
  -- derived: claim coverage ratio (avoid divide by zero)
  case when try_cast(amount_billed as decimal(12,2)) is not null and try_cast(amount_billed as decimal(12,2)) <> 0
       then try_cast(amount_paid as decimal(12,2)) / try_cast(amount_billed as decimal(12,2))
       else null end as paid_ratio
from "ReadmitDB"."dbo"."claims"
;;
    ')

