{{ config(materialized='view') }}

select
  admission_id,
  patient_id,
  count(*) as claims_count,
  sum(coalesce(amount_billed,0)) as sum_billed,
  sum(coalesce(amount_paid,0)) as sum_paid,
  case when sum(coalesce(amount_billed,0)) = 0 then null
       else sum(coalesce(amount_paid,0))/nullif(sum(coalesce(amount_billed,0)),0) end as paid_ratio
from {{ ref('stg_claims') }}
group by admission_id, patient_id
;
-- This query aggregates claims data by admission and patient, calculating the total number of claims,
-- total billed amount, total paid amount, and the paid ratio.
-- It uses the staging table 'stg_claims' to ensure that the data is normalized and cleaned before aggregation.
-- The materialization is set to 'view' for efficient querying and updates.
-- The 'coalesce' function is used to handle any null values in the 'amount_billed' and 'amount_paid' fields,
-- ensuring that the calculations are robust against missing data.
-- The 'nullif' function is used to avoid division by zero when calculating the paid ratio.
-- The 'group by' clause ensures that the aggregation is done per admission and patient, allowing
-- for detailed insights into claims data.
-- This query is suitable for staging in a data pipeline, providing a summarized view of claims data
-- for further analysis.