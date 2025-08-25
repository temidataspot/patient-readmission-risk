```python
import streamlit as st
import pandas as pd
import altair as alt

# Load data
@st.cache_data
def load_data():
    df = pd.read_csv("features_predictions.csv")
    return df

df = load_data()

st.markdown(
    "<h1 style='text-align: center;'>🏥 Patient Readmission Risk Dashboard</h1>",
    unsafe_allow_html=True
)

# Sidebar Filters 
st. sidebar.header("Filters")

# Department filter
departments = ["All"] + df["department"].dropna().unique().tolist()
selected_department = st.sidebar.selectbox("Filter by Department", departments)

# Gender filter
genders = ["All"] + df["gender"].dropna().unique().tolist()
selected_gender = st.sidebar.selectbox("Filter by Gender", genders)

# Avg Adherence filter (slider)
min_val, max_val = float(df["avg_adherence"].min()), float(df["avg_adherence"].max())
adherence_range = st.sidebar.slider("Filter by Avg Adherence", min_val, max_val, (min_val, max_val))

# Apply Filters
filtered_df = df.copy()

if selected_department != "All":
    filtered_df = filtered_df[filtered_df["department"] == selected_department]

if selected_gender != "All":
    filtered_df = filtered_df[filtered_df["gender"] == selected_gender]

filtered_df = filtered_df[
    (filtered_df["avg_adherence"] >= adherence_range[0]) &
    (filtered_df["avg_adherence"] <= adherence_range[1])
]

# Charts 
st.subheader("Risk Distribution")

# Risk counts
risk_counts = filtered_df["rf_risk_flag"].value_counts().reset_index()
risk_counts.columns = ["Risk", "Count"]

chart1 = alt.Chart(risk_counts).mark_bar().encode(
    x="Risk",
    y="Count",
    color="Risk"
).properties(title="High Risk vs Low Risk Patients")

st.altair_chart(chart1, use_container_width=True)

# Average Adherence by Risk Level
st.subheader("Average Adherence by Risk Level")

chart2 = alt.Chart(filtered_df).mark_boxplot().encode(
    x="rf_risk_flag",
    y="avg_adherence",
    color="rf_risk_flag"
).properties(title="Adherence Levels per Risk Group")

st.altair_chart(chart2, use_container_width=True)

# Show Data 
st.subheader("Filtered Data")
st.dataframe(filtered_df)
```
