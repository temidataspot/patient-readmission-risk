# Patient Readmission Risk — End-to-End ML, SQL, and Streamlit Project 

[Streamlit](https://patient-readmission-risks.streamlit.app/)

This project builds a full pipeline to predict 30-day hospital readmission risk and visualise those predictions for clinicians and analysts. Machine-learning models are trained on features stored in SQL Server, write predictions back to SQL, generate risk flags (High vs Low), join predictions back to the original features, and publish an interactive Streamlit dashboard that allows filtering by department, gender, adherence, and risk group.

**Where the core logic lives**

* Data prep and modeling: `modelling2.py` (final) and earlier experiments in `mlmodel.py`, `model.py`, `featuremodel.py`, `updatedmlmodel.py`.
* SQL post-processing (risk flagging, counts, and joins): the `mssql_files/` folder.
* Deployed dashboard: `apps.py`.
* Dataset for Streamlit deployment (no DB required): `features_predictions.csv`.
* Python packages: `requirements.txt`.
* Repo/config helpers: `.gitignore`, `.gitattributes`

## What this achieved

1. Predict readmission risk with interpretable metrics and features.
2. Produce patient-centric outputs (probabilities and risk flags) linked to patient IDs.
3. Persist predictions inside SQL for downstream analytics.
4. Provide a self-serve dashboard to filter and explore risk cohorts any time.
5. Make deployment simple enough that anyone with the link can access the dashboard without local setup.

---

## From zero to running: the complete process

### A. Starting clean: tools and workspace

* **Operating environment**: Windows.
* **Editor**: Visual Studio Code (VS Code).
* **Python environment**: a dedicated virtual environment in the project folder. All Python dependencies are listed in `requirements.txt`.
* **Version control**: Git (local) and GitHub (remote).
* **Database**: SQL Server (local instance named `ReadmitDB`) managed via SQL Server Management Studio (SSMS).
* **ODBC**: ODBC Driver 17 for SQL Server (for local Python ↔ SQL connections).
* **Cloud hosting for the app**: Streamlit Community Cloud.

**Repository structure**
* Root includes: `apps.py` (final app), `modelling2.py` (final model script), earlier ML attempts, SQL scripts folder `mssql_files/`, `features_predictions.csv`, `requirements.txt`, `.gitattributes`, `.gitignore`, images of feature importance for documentation, and this `README.md`.

### Getting the data into place

* Source table: `features_ml` in SQL Server database `ReadmitDB`.
* Key fields: `patient_id` retained as the permanent join key; `admission_id` considered a transient encounter ID (dropped from model features).
* Target label: `readmit_label`.

Verified the table exists and is queryable in SSMS before touching Python. This avoided chasing downstream errors caused by missing or renamed columns.

### Local modelling workflow

All final steps are implemented in `modelling2.py`
Process followed:

1. **Load data from SQL**
   Connected to `ReadmitDB` and read from `features_ml`. Saved `patient_id` separately so it wouldn’t be lost during preprocessing.

2. **Column hygiene**
   Dropped `admission_id` and `patient_id` from the modelling features so the model wouldn’t “cheat” with identifiers. `patient_id` is kept separately to reattach to predictions.

3. **Feature types**
   Explicitly identified categorical columns and numeric columns. Categorical columns are one-hot encoded; numeric columns are standardised (scaler).

4. **Dealing with class imbalance**
   Initially considered applying SMOTE to the full dataset and then splitting. That led to indexing and alignment problems when trying to map back to `patient_id`. Evaluated two alternatives and settled on the **correct approach**: split first into train and test, then apply SMOTE **only** on the training set. This preserved test-set integrity and eliminated `KeyError` alignment issues.

5. **Model training**
   Trained two models: Logistic Regression and Random Forest, then evaluated them. Extracted top features (coefficients/importances) and saved those visualizations (PNG files in the repo) for documentation.

6. **Predictions and persistence**
   Generated predictions and probabilities on the test set and wrote the results back to SQL in a new table named `readmission_predictions`. This table includes patient IDs, true labels, and both models’ predictions and probabilities.

### SQL post-processing

All final SQL lives in the `mssql_files/` folder:

* **Risk flag (High vs Low)**
  `highrisk_lowrisk.sql` updates the `readmission_predictions` table with a risk flag based on the Random Forest probability threshold of 0.5.

* **Counts and cohorts**
  Created summary counts by risk flag and also materialised separate tables of high-risk and low-risk patients when needed.

* **Join predictions back to features**
  `join_features_preds.sql` creates `features_predictions` by joining `readmission_predictions` to `features_ml` on `patient_id`. This produces a single, analyst-friendly table with both features and model outputs.

### Preparing for the cloud (CSV extract)

Since Streamlit Cloud does not ship with SQL Server drivers by default, and didn’t want to embed DB credentials in a public repo, exported `features_predictions` to a CSV file and committed it as `features_predictions.csv`.
This file is what the deployed app reads so it can run anywhere with no database connection.

### Streamlit application

* The **final** app is `apps.py`.
* The app:

  * Loads `features_predictions.csv`.
  * Normalises all column names to lowercase to avoid case-sensitive KeyErrors (for example, “Department” vs “department”).
  * Provides sidebar filters for department, gender, average adherence (slider), and risk flag.
  * Displays an overall risk distribution and other summaries as Altair charts.
  * Shows a filterable patient table with counts.

Centred the title using Streamlit’s Markdown with safe HTML, kept the layout wide, and verified the filtering logic with the real CSV.

### Deployment to Streamlit Community Cloud

* Repository: GitHub repo named `patient-readmission-risk`.
* App entry point: `apps.py`.
* Packages: `requirements.txt` lists everything the app needs (including Streamlit and Altair).
* After pushing to GitHub, created the app in Streamlit Cloud and pointed it at the repo and the correct file. Cloud then installs dependencies and launches the app. Any future push to `main` triggers a rebuild.

---

## Errors hit and how they're resolved

This section documents every notable issue encountered, why it happened, and the fixes applied.

### A. Python / Modelling

1. **Patient ID misalignment after SMOTE (KeyError on indices)**

   * **Symptom**: KeyErrors when trying to align `patient_id` with resampled targets.
   * **Cause**: Applying SMOTE over the full dataset and only then splitting mixed-up indices because synthetic rows do not have patient IDs.
   * **Fix**: Split the data first. Apply SMOTE only to the training set. Keep the test set untouched. 

2. **Confusion about “keeping only original samples”**

   * **Context**: Briefly considered avoiding SMOTE altogether to keep alignment trivial.
   * **Outcome**: Ultimately used the best-practice approach above (train-only SMOTE) to increase minority recall while preserving test integrity.

### B. SQL

1. **`rf_risk_flag` suddenly showing as NULL**

   * **Symptom**: After re-writing `readmission_predictions` from Python, the `rf_risk_flag` column showed nulls.
   * **Cause**: The table was replaced without recomputing the flag.
   * **Fix**: Re-run the risk-flag update logic (in `mssql_files/highrisk_lowrisk.sql`). That repopulates the flag based on `rf_proba ≥ 0.5`.

2. **“Department is not in readmission\_predictions”**

   * **Symptom**: Trying to query department against `readmission_predictions` failed.
   * **Cause**: Department exists in the original features table, not the predictions table.
   * **Fix**: Use `features_predictions` (created by `mssql_files/join_features_preds.sql`) for any reporting that mixes features with model outputs.

3. **“rf\_risk\_flag is highlighted so not running” in SSMS**

   * **Symptom**: Risk-flagging update seemed to error in the editor.
   * **Cause**: T-SQL syntax details (aliasing, update-from pattern, running in the wrong DB context) can cause highlighting or execution issues.
   * **Fix**: Ensure I'm in the `ReadmitDB` context and run the final update script in `mssql_files/highrisk_lowrisk.sql`.

### C. Streamlit

1. **KeyError for “Department” or “Gender” in the app**

   * **Symptom**: Filters threw KeyError.
   * **Cause**: CSV column names were lowercase, but the code referenced capitalised names.
   * **Fix**: Normalise all columns to lowercase at load in `apps.py`, and reference lowercase consistently.

2. **Charts not rendering in Cloud**

   * **Symptom**: App launched, table showed up, but charts were missing.
   * **Cause**: `altair` wasn’t included in `requirements.txt` in the first deployment.
   * **Fix**: Add Altair to `requirements.txt`, commit, push, and redeploy.

3. **Database connection error on Streamlit Cloud (pyodbc redacted)**

   * **Symptom**: On Cloud, connecting to SQL via ODBC failed with a redacted error.
   * **Cause**: Cloud container doesn’t ship with SQL Server drivers or credentials by default.
   * **Fix**: Deliberately avoided DB connections in Cloud and used `features_predictions.csv` instead. (If live DB is required, you’d install drivers in a custom image and set credentials via Streamlit secrets.)

### D. Git & GitHub

1. **“Non-fast-forward” push rejection**

   * **Symptom**: `git push` was rejected because remote had updates absent locally.
   * **Fix**: Commit local changes first, then integrate the remote history (used a rebase), resolve any conflicts, and push again. The repo history now includes both sides.

---

## Data columns and interpretation (what stakeholders see)

* **true\_label** — Ground truth (1 = readmitted, 0 = not readmitted).
* **logistic\_pred / logistic\_proba** — Output from Logistic Regression (hard class vs probability).
* **rf\_pred / rf\_proba** — Output from Random Forest (hard class vs probability).
* **rf\_risk\_flag** — label derived from `rf_proba` (≥ 0.5 is High risk; otherwise Low risk).
* **All original features** — Kept when using `features_predictions`, which enables slicing by clinical attributes like department, gender, adherence, etc.

---

## Maintenance and future improvements

* **Model calibration and thresholds**: Calibrate probabilities and adjust the 0.5 threshold globally or per department to match clinical priorities.
* **Monitoring**: Log model inputs and outputs over time to detect drift.
* **Automation**: Wrap the training and SQL post-processing into a scheduled pipeline.
* **Auth**: If stricter access is needed, deploy on infrastructure that supports authentication or keep the repo/app private.
* **Feature governance**: Maintain a data dictionary for `features_ml` so downstream consumers understand each field.

