-- confirm high risk table
SELECT * FROM high_risk_patients;

-- confirm high risk table
SELECT TOP 10 *
FROM low_risk_patients;

-- join features & readmission_predictions
-- Create a new table combining predictions with features
SELECT 
    r.patient_id,
    r.true_label,
    r.logistic_pred,
    r.logistic_proba,
    r.rf_pred,
    r.rf_proba,
    f.age,
    f.gender,
    f.department,
    f.length_of_stay,
    f.bmi,
    f.ethnicity,
    f.ses_group,
    f.sum_billed,
    f.sum_paid,
    f.avg_adherence,
    CASE 
        WHEN r.rf_proba >= 0.5 THEN 'High Risk'
        ELSE 'Low Risk'
    END AS rf_risk_flag
INTO features_predictions
FROM readmission_predictions r
JOIN features_ml f
    ON r.patient_id = f.patient_id;



