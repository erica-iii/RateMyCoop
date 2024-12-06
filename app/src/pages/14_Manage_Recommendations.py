import logging
logger = logging.getLogger(__name__)
import pandas as pd
import streamlit as st
from streamlit_extras.app_logo import add_logo
import matplotlib.pyplot as plt
import numpy as np
from modules.nav import SideBarLinks
import requests

SideBarLinks()

# Set up the options
response = requests.get('http://api:4000/a/advisors/students')
students = response.json()
students_options = [student['studentId'] for student in students]

response = requests.get('http://api:4000/a/advisors/advisor_ids')
advisors = response.json()
advisors_options = [advisor['advisorId'] for advisor in advisors]

response = requests.get('http://api:4000/a/advisors/coops')
coops = response.json()
coops_options = [coop['coopId'] for coop in coops]


st.markdown("# Write a Recommendation")

with st.form("add_recommendation_form"):
    studentId = st.selectbox("Please select a student ID:", options = students_options)
    advisorId = st.selectbox("Please select an advisor ID:", options = advisors_options)
    coopId = st.selectbox("Please select a Co-op ID:", options = coops_options)
    feedback = st.text_input("Please provide feedback:", value='N/A')

    # adding the submit button
    submit_button = st.form_submit_button("Post Review")
    
    # validating that all fields are filled when form is submitted
    if submit_button:
        if not studentId:
            st.error("Please select a student ID")
        elif not advisorId:
            st.error("Please enter an advisor ID")
        elif not coopId:
            st.error("Please enter a Co-op ID")
        elif not feedback:
            st.error("Please write feedback:")
        else:
            # packing up all the data that the user entered into a dictionary
            rec_data = {
                "studentId": studentId,
                "advisorId": advisorId,
                "coopId": coopId,
                "feedback": feedback
            }
             
            logger.info(f"Recommendation posted with data: {rec_data}")
            
            # trying post request
            try:
                response = requests.post('http://api:4000/a/advisors/recommend_coops', json=rec_data)
                if response.status_code == 200:
                    st.success("Recommendation posted successfully!")
                else:
                    st.error(f"Error posting recommendation: {response.text}")
            except requests.exceptions.RequestException as e:
                st.error(f"Error connecting to server: {str(e)}")

