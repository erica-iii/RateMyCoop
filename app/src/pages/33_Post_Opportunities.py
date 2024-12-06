import logging
import requests
import streamlit as st

# Set up logging
logger = logging.getLogger(__name__)

# Call the SideBarLinks
from modules.nav import SideBarLinks
SideBarLinks()

# Header for the page
st.header('Post a New Internship Position')

# ensures that user is logged in as an employer
if 'company_name' not in st.session_state or 'company_id' not in st.session_state:
    st.error("You are not logged in as an employer.")
    st.stop()

st.write(f"### Welcome, {st.session_state['company_name']}!")

# Form for posting a new job
st.write("### Enter the job details:")

# Job details input fields
job_title = st.text_input("Job Title")
job_description = st.text_area("Job Description")
job_salary = st.number_input("Salary (per year)", min_value=0)
job_location = st.text_input("Location")
job_industry = st.text_area("Industry")

# submit button -- as long as all fields are filled out
if st.button("Post Job"):
    if not job_title or not job_description or not job_salary or not job_location:
        st.error("Please fill in all required fields.")
    else:
        job_data = {
            "title": job_title,
            "description": job_description,
            "salary": job_salary,
            "location": job_location,
            "companyId": st.session_state["company_id"],
            "industry": job_industry
        }

        # posting job listing
        post_response = requests.post(f'http://api:4000/e/companies/{st.session_state["company_id"]}/post_job', json=job_data)

        if post_response.status_code == 201:
            st.success("Job posted successfully!")
        else:
            st.error(f"Failed to post the job. Error: {post_response.status_code}")

# Button to return to the employer homepage
if st.button('Return home'):
    st.switch_page('pages/31_Company_Home.py')
