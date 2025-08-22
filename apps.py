import streamlit as st
import pandas as pd

@st.cache_data
def load_data():
    # Load the CSV instead of connecting to SQL Server
    return pd.read_csv("features_predictions.csv")

df = load_data()

st.title("Patient Readmission Risk Dashboard")

# Sidebar filters
department = st.sidebar.selectbox("Filter by Department", ["All"] + df["department"].dropna().unique().tolist())
gender = st.sidebar.selectbox("Filter by Gender", ["All"] + df["gender"].dropna().unique().tolist())

# Apply filters
filtered_df = df.copy()
if department != "All":
    filtered_df = filtered_df[filtered_df["department"] == department]
if gender != "All":
    filtered_df = filtered_df[filtered_df["gender"] == gender]

# Show filtered data
st.write("### Filtered Patients", filtered_df.head())

# Risk counts
st.write("### Risk Breakdown")
st.write(filtered_df["rf_risk_flag"].value_counts())
