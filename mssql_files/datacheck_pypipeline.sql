```tsql
-- checking if the 5 csvs uploaded became tables
SELECT table_schema, table_name
FROM INFORMATION_SCHEMA.TABLES
WHERE table_name IN ('admissions','claims','labs','patients','pharmacy');

-- checking row counts to confirm my data is loaded
SELECT 'admissions' AS tbl, COUNT(*) AS rows FROM dbo.admissions
UNION ALL SELECT 'claims',    COUNT(*) FROM dbo.claims
UNION ALL SELECT 'labs',      COUNT(*) FROM dbo.labs
UNION ALL SELECT 'patients',  COUNT(*) FROM dbo.patients
UNION ALL SELECT 'pharmacy',  COUNT(*) FROM dbo.pharmacy;


SELECT * FROM dbo.features_ml;
SELECT readmit_label FROM dbo.features_ml;

SELECT * 
FROM readmission_predictions;


-- high-risk flag patients
-- using threshold of 0.5; if probability ≥ 0.5 → predict readmission.
-- Adding a risk flag based on random forest proba

```
