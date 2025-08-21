import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, roc_auc_score
from imblearn.over_sampling import SMOTE
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.compose import ColumnTransformer
from sqlalchemy import create_engine

# ---------------- 1. Load data from SQL ----------------
engine = create_engine(
    "mssql+pyodbc://dbt_users:para3saca1@localhost/ReadmitDB?driver=ODBC+Driver+17+for+SQL+Server"
)

query = "SELECT * FROM features_ml"
df = pd.read_sql(query, engine)
print("Data loaded:", df.shape)

# ---------------- 2. Save patient_id and drop unnecessary columns ----------------
patient_ids = df["patient_id"]  # Save for later
df = df.drop(columns=["admission_id", "patient_id"])

# Separate features and target
X = df.drop("readmit_label", axis=1)
y = df["readmit_label"]

# ---------------- 3. Identify categorical and numeric columns ----------------
categorical = X.select_dtypes(include=["object"]).columns.tolist()
numeric = X.select_dtypes(exclude=["object"]).columns.tolist()

# ---------------- 4. Preprocessing ----------------
preprocessor = ColumnTransformer(
    transformers=[
        ("num", StandardScaler(), numeric),
        ("cat", OneHotEncoder(drop="first"), categorical),
    ]
)

X_processed = preprocessor.fit_transform(X)

# ---------------- 5. Handle class imbalance (keep only original samples) ----------------
smote = SMOTE(random_state=42)
X_resampled, y_resampled = smote.fit_resample(X_processed, y)

# Keep only original samples to match patient_ids
X_original = X_resampled[:len(patient_ids)]
y_original = y_resampled[:len(patient_ids)]
patient_ids_reset = patient_ids.reset_index(drop=True)
patient_ids_original = patient_ids_reset  # Already matches length

print("\nClass balance of original samples:")
print(y_original.value_counts())

# ---------------- 6. Train/test split ----------------
X_train, X_test, y_train, y_test, pid_train, pid_test = train_test_split(
    X_original, y_original, patient_ids_original, test_size=0.3, random_state=42
)

# ---------------- 7. Logistic Regression ----------------
log_model = LogisticRegression(max_iter=5000)
log_model.fit(X_train, y_train)

y_pred_log = log_model.predict(X_test)
y_proba_log = log_model.predict_proba(X_test)[:, 1]

print("\nLogistic Regression Report:")
print(classification_report(y_test, y_pred_log))
print("ROC AUC:", roc_auc_score(y_test, y_proba_log))

# Feature names after preprocessing
feature_names = numeric + list(preprocessor.named_transformers_["cat"].get_feature_names_out(categorical))

log_coefs = pd.Series(log_model.coef_[0], index=feature_names).sort_values(key=abs, ascending=False)
top_log = log_coefs.head(10)

print("\nTop 10 Logistic Regression Features:")
print(top_log)

# Plot Logistic Regression coefficients
plt.figure(figsize=(8, 5))
top_log.plot(kind="barh")
plt.title("Top Logistic Regression Features")
plt.xlabel("Coefficient Value")
plt.gca().invert_yaxis()
plt.tight_layout()
plt.show()

# ---------------- 8. Random Forest ----------------
rf_model = RandomForestClassifier(n_estimators=200, random_state=42)
rf_model.fit(X_train, y_train)

y_pred_rf = rf_model.predict(X_test)
y_proba_rf = rf_model.predict_proba(X_test)[:, 1]

print("\nRandom Forest Report:")
print(classification_report(y_test, y_pred_rf))
print("ROC AUC:", roc_auc_score(y_test, y_proba_rf))

rf_importances = pd.Series(rf_model.feature_importances_, index=feature_names).sort_values(ascending=False)
top_rf = rf_importances.head(10)

print("\nTop 10 Random Forest Features:")
print(top_rf)

# Plot Random Forest feature importances
plt.figure(figsize=(8, 5))
top_rf.plot(kind="barh")
plt.title("Top Random Forest Features")
plt.xlabel("Importance Score")
plt.gca().invert_yaxis()
plt.tight_layout()
plt.show()

# ---------------- 9. Save predictions with patient_id ----------------
results_df = pd.DataFrame({
    "patient_id": pid_test,
    "true_label": y_test.values,
    "logistic_pred": y_pred_log,
    "logistic_proba": y_proba_log,
    "rf_pred": y_pred_rf,
    "rf_proba": y_proba_rf
})

print("Sample of predictions:\n", results_df.head())

# Write results back to SQL Server
results_df.to_sql("readmission_predictions", con=engine, if_exists="replace", index=False)
print("✅ Predictions successfully written to SQL Server (table: readmission_predictions)")
