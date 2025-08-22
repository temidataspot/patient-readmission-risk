SELECT * FROM readmission_predictions;

-- number of low-risk & high-risk patients based on  rf & lr
-- for rf
SELECT 
    rf_risk_flag,
    COUNT(*) AS patient_count
FROM readmission_predictions
GROUP BY rf_risk_flag;

-- for lr
SELECT 
    lr_risk_flag,
    COUNT(*) AS patient_count
FROM readmission_predictions
GROUP BY lr_risk_flag;

-- segregate both high/low into their tables based on rf
-- Create a new table with only high risk patients
SELECT 
    patient_id,
    rf_risk_flag
INTO high_risk_patients
FROM readmission_predictions
WHERE rf_risk_flag = 'High Risk';

-- low risk patients table
SELECT 
    patient_id,
    rf_risk_flag
INTO low_risk_patients
FROM readmission_predictions
WHERE rf_risk_flag = 'Low Risk';




