USE [ReadmitDB];
    
    

    

    
    USE [ReadmitDB];
    EXEC('
        create view "dbo"."pharmacy_agg__dbt_tmp" as 

select
  admission_id,
  patient_id,
  count(*) as rx_count,
  sum(coalesce(days_supply,0)) as total_days_supply,
  avg(coalesce(adherence_rate,0)) as avg_adherence
from "ReadmitDB"."dbo"."stg_pharmacy"
group by admission_id, patient_id
;
-- This query aggregates pharmacy data by admission and patient, calculating the total number of prescriptions,
-- total days supply, and average adherence rate.
-- It uses the staging table ''stg_pharmacy'' to ensure that the data is normalized and cleaned before aggregation.
-- The materialization is set to ''view'' for efficient querying and updates.
-- The ''coalesce'' function is used to handle any null values in the ''days_supply'' and ''adherence_rate'' fields,
-- ensuring that the calculations are robust against missing data.
-- The ''group by'' clause ensures that the aggregation is done per admission and patient, allowing for detailed insights into pharmacy usage.
-- This query is suitable for staging in a data pipeline, providing a summarized view of pharmacy data  for further analysis.;
    ')

