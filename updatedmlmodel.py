import pandas as pd
from sqlalchemy import create_engine
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, roc_auc_score
from imblearn.over_sampling import SMOTE

# -------------------------
# 1. Database connection
# -------------------------
engine = create_engine(
    "mssql+pyodbc://dbt_users:para3saca1@localhost/ReadmitDB?driver=ODBC+Driver+17+for+SQL+Server"
)

query = "SELECT * FROM dbo.features_ml;"
df = pd.read_sql(query, engine)
print("Data loaded:", df.shape)

# -------------------------
# 2. Encode categorical features
# -------------------------
categorical_cols = ["gender", "ethnicity", "ses_group", "department"]

df_encoded = pd.get_dummies(df, columns=categorical_cols, drop_first=True)

# Show what dummies were created
print("\nEncoded columns:")
for col in df_encoded.columns:
    if any(c in col for c in categorical_cols):
        print("  ", col)

# -------------------------
# 3. Features & Target
# -------------------------
X = df_encoded.drop(columns=["readmit_label", "admission_id", "patient_id"])
y = df_encoded["readmit_label"]

# -------------------------
# 4. Balance classes with SMOTE
# -------------------------
smote = SMOTE(random_state=42)
X_resampled, y_resampled = smote.fit_resample(X, y)
print("\nClass balance after SMOTE:")
print(y_resampled.value_counts())

# -------------------------
# 5. Train/Test split
# -------------------------
X_train, X_test, y_train, y_test = train_test_split(
    X_resampled, y_resampled, test_size=0.3, random_state=42
)

# -------------------------
# 6. Logistic Regression Model
# -------------------------
model = LogisticRegression(max_iter=5000)
model.fit(X_train, y_train)

y_pred = model.predict(X_test)
y_proba = model.predict_proba(X_test)[:, 1]

# -------------------------
# 7. Evaluation
# -------------------------
print("\nClassification Report:")
print(classification_report(y_test, y_pred))

print("ROC AUC:", roc_auc_score(y_test, y_proba))
