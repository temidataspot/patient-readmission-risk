SELECT TOP 20 * FROM features_predictions;

SELECT *
FROM features_predictions
WHERE rf_risk_flag = 'High Risk';

SELECT *
FROM features_predictions
WHERE rf_risk_flag = 'Low Risk';
