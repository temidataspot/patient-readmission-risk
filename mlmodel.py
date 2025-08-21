import pyodbc
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, roc_auc_score

# ------------------------
# 1. Connect to SQL Server
# ------------------------
conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=localhost,1433;"  # or your server name
    "DATABASE=ReadmitDB;"  # your dbt target database
    "UID=dbt_users;"  # your SQL Server username
    "PWD=para3saca1;"  # replace with actual password
)

# ------------------------
# 2. Load data
# ------------------------
query = "SELECT * FROM dbo.features_ml;"
df = pd.read_sql(query, conn)
print("Data loaded:", df.shape)

# ------------------------
# 3. Define features & target
# ------------------------
X = df.drop(columns=["readmit_label", "admission_id", "patient_id"])
y = df["readmit_label"]

# ------------------------
# 4. Preprocessing pipeline
# ------------------------
categorical_cols = ["gender", "ethnicity", "ses_group", "department"]
numeric_cols = [col for col in X.columns if col not in categorical_cols]

preprocessor = ColumnTransformer(
    transformers=[
        ("cat", OneHotEncoder(handle_unknown="ignore"), categorical_cols),
        ("num", "passthrough", numeric_cols)
    ]
)

# ------------------------
# 5. Train-test split
# ------------------------
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.3, random_state=42, stratify=y
)

# ------------------------
# 6. Model pipeline
# ------------------------
model = Pipeline(steps=[
    ("preprocessor", preprocessor),
    ("classifier", LogisticRegression(max_iter=1000))
])

# Train
model.fit(X_train, y_train)

# ------------------------
# 7. Evaluation
# ------------------------
y_pred = model.predict(X_test)
y_prob = model.predict_proba(X_test)[:, 1]

print("\nClassification Report:\n", classification_report(y_test, y_pred))
print("ROC AUC:", roc_auc_score(y_test, y_prob))
