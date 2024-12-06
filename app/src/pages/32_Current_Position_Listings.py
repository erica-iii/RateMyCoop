import logging
import requests
import streamlit as st

# Set up logging
logger = logging.getLogger(__name__)

# Import the SideBarLinks for the navigation sidebar
from modules.nav import SideBarLinks

# Call the SideBarLinks from the nav module to render the sidebar in the app
SideBarLinks()

# Header for the page
st.header('Manage Job Listings')

st.write(f"### Welcome, {st.session_state['first_name']}!")

# Fetch the list of job listings for the employer
response = requests.get(f'http://api:4000/e/companies/{st.session_state["company_id"]}/job_listings')
if response.status_code == 200:
    job_listings = response.json()

    if job_listings:
        job_titles = [job['title'] for job in job_listings]
        job_titles.insert(0, 'Select a job to manage')  # Insert default option for selection
        selected_job_title = st.selectbox("Select a job to manage", job_titles)

        if selected_job_title != 'Select a job to manage':
            # Fetch the job details to be updated or deleted
            selected_job = next(job for job in job_listings if job['title'] == selected_job_title)
            job_id = selected_job['jobId']
            job_title = selected_job['title']
            job_description = selected_job['description']
            job_salary = selected_job['salary']
            job_location = selected_job['location']
            job_requirements = selected_job.get('requirements', 'N/A')

            # Display current job details
            st.write(f"### Current details for {job_title}:")
            st.write(f"**Description:** {job_description}")
            st.write(f"**Salary:** {job_salary}")
            st.write(f"**Location:** {job_location}")
            st.write(f"**Requirements:** {job_requirements}")

            # Option to update the job listing
            if st.button("Update Job"):
                updated_job_title = st.text_input("Job Title", job_title)
                updated_job_description = st.text_area("Job Description", job_description)
                updated_job_salary = st.number_input("Salary (per year)", min_value=0, value=job_salary)
                updated_job_location = st.text_input("Location", job_location)
                updated_job_requirements = st.text_area("Job Requirements (optional)", value=job_requirements)

                if st.button("Submit Update"):
                    updated_job_data = {
                        "title": updated_job_title,
                        "description": updated_job_description,
                        "salary": updated_job_salary,
                        "location": updated_job_location,
                        "requirements": updated_job_requirements if updated_job_requirements else "N/A"
                    }

                    # Send PUT request to update the job listing
                    update_response = requests.put(f'http://api:4000/e/companies/{st.session_state["company_id"]}/job_listings/{job_id}', json=updated_job_data)

                    if update_response.status_code == 200:
                        st.success("Job listing updated successfully!")
                    else:
                        st.error(f"Failed to update the job. Error: {update_response.status_code}")

            # Option to delete the job listing
            if st.button("Delete Job"):
                confirm_delete = st.checkbox("Are you sure you want to delete this job listing?")
                if confirm_delete:
                    # Send DELETE request to remove the job listing
                    delete_response = requests.delete(f'http://api:4000/e/companies/{st.session_state["company_id"]}/job_listings/{job_id}')
                    if delete_response.status_code == 200:
                        st.success("Job listing deleted successfully!")
                    else:
                        st.error(f"Failed to delete the job. Error: {delete_response.status_code}")
    else:
        st.write("No job listings available.")
else:
    st.error(f"Failed to fetch job listings: {response.status_code}")

# Button to return to the company home page
if st.button('Return home'):
    st.switch_page('pages/31_Company_Home.py')
