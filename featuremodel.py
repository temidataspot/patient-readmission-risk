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
from sklearn.pipeline import Pipeline
from sqlalchemy import create_engine

# Connect with SQLAlchemy
engine = create_engine(
    "mssql+pyodbc://dbt_users:para3saca1@localhost/ReadmitDB?driver=ODBC+Driver+17+for+SQL+Server"
)

query = "SELECT * FROM features_ml"
df = pd.read_sql(query, engine)
print("Data loaded:", df.shape)

# Drop ID columns
df = df.drop(columns=["admission_id", "patient_id"])

# Separate features and target
X = df.drop("readmit_label", axis=1)
y = df["readmit_label"]

# Identify categorical and numeric columns
categorical = X.select_dtypes(include=["object"]).columns.tolist()
numeric = X.select_dtypes(exclude=["object"]).columns.tolist()

# Preprocessing
preprocessor = ColumnTransformer(
    transformers=[
        ("num", StandardScaler(), numeric),
        ("cat", OneHotEncoder(drop="first"), categorical),
    ]
)

# Apply preprocessing
X_processed = preprocessor.fit_transform(X)

# Handle imbalance with SMOTE
smote = SMOTE(random_state=42)
X_resampled, y_resampled = smote.fit_resample(X_processed, y)
print("\nClass balance after SMOTE:")
print(y_resampled.value_counts())

# Train/test split
X_train, X_test, y_train, y_test = train_test_split(
    X_resampled, y_resampled, test_size=0.3, random_state=42
)

# ---------------- Logistic Regression ----------------
log_model = LogisticRegression(max_iter=5000)
log_model.fit(X_train, y_train)
y_pred_log = log_model.predict(X_test)
print("\nLogistic Regression Report:")
print(classification_report(y_test, y_pred_log))
print("ROC AUC:", roc_auc_score(y_test, log_model.predict_proba(X_test)[:, 1]))

# Get feature names after preprocessing
feature_names = (
    numeric
    + list(preprocessor.named_transformers_["cat"].get_feature_names_out(categorical))
)

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

# ---------------- Random Forest ----------------
rf_model = RandomForestClassifier(n_estimators=200, random_state=42)
rf_model.fit(X_train, y_train)
y_pred_rf = rf_model.predict(X_test)
print("\nRandom Forest Report:")
print(classification_report(y_test, y_pred_rf))
print("ROC AUC:", roc_auc_score(y_test, rf_model.predict_proba(X_test)[:, 1]))

rf_importances = pd.Series(rf_model.feature_importances_, index=feature_names).sort_values(ascending=False)
top_rf = rf_importances.head(10)
print("\nTop 10 Random Forest Features:")
print(top_rf)

# Plot Random Forest importances
plt.figure(figsize=(8, 5))
top_rf.plot(kind="barh")
plt.title("Top Random Forest Features")
plt.xlabel("Importance Score")
plt.gca().invert_yaxis()
plt.tight_layout()
plt.show()

