import streamlit as st
import pandas as pd
import pyodbc
import altair as alt

# ----------------- Connect to SQL -----------------
def load_data():
    conn = pyodbc.connect(
        "DRIVER={ODBC Driver 17 for SQL Server};"
        "SERVER=localhost;"
        "DATABASE=ReadmitDB;"
        "UID=dbt_users;"
        "PWD=para3saca1;"
    )
    query = "SELECT * FROM features_predictions"
    df = pd.read_sql(query, conn)
    conn.close()
    return df

st.title("🏥 Patient Readmission Risk Dashboard")

# Load data
df = load_data()

# ----------------- Sidebar Filters -----------------
st.sidebar.header("Filter Patients")

# Department filter
department = st.sidebar.selectbox("Select Department", ["All"] + df["department"].dropna().unique().tolist())
if department != "All":
    df = df[df["department"] == department]

# Gender filter
if "gender" in df.columns:
    gender = st.sidebar.selectbox("Select Gender", ["All"] + df["gender"].dropna().unique().tolist())
    if gender != "All":
        df = df[df["gender"] == gender]

# Avg Adherence filter (numeric)
if "avg_adherence" in df.columns:
    min_val, max_val = float(df["avg_adherence"].min()), float(df["avg_adherence"].max())
    adherence_range = st.sidebar.slider("Select Avg Adherence Range", min_val, max_val, (min_val, max_val))
    df = df[(df["avg_adherence"] >= adherence_range[0]) & (df["avg_adherence"] <= adherence_range[1])]

# ----------------- Overview Metrics -----------------
high_risk_count = (df["rf_risk_flag"] == "High Risk").sum()
low_risk_count = (df["rf_risk_flag"] == "Low Risk").sum()

st.metric("High Risk Patients", high_risk_count)
st.metric("Low Risk Patients", low_risk_count)

# ----------------- Risk Distribution Chart -----------------
risk_chart = alt.Chart(df).mark_bar().encode(
    x="rf_risk_flag",
    y="count()",
    color="rf_risk_flag"
).properties(title="Risk Distribution")
st.altair_chart(risk_chart, use_container_width=True)

# ----------------- Patient-Level Table -----------------
st.subheader("Patient-Level Data (Filtered)")
st.dataframe(df.head(50))

# Download option
csv = df.to_csv(index=False).encode("utf-8")
st.download_button("Download Data", csv, "patients.csv", "text/csv")
