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

with st.form("add_job"):
    
    # creating the various input widgets needed for each piece of information from the user
    company = st.session_state['company_name']
    job_title = st.text_input("Job Title:")
    content = st.text_area("Job Description:")
    job_salary = st.number_input("Salary:", step=1000)
    job_location = st.text_input("Location:")
    job_industry = st.text_input("Industry")
    
    # adding the submit button
    submit_button = st.form_submit_button("Post Review")
    
    # validating that all fields are filled when form is submitted
    if submit_button:
        if not company:
            st.error("Please select a company")
        elif not job_title:
            st.error("Please enter a job title")
        elif not content:
            st.error("Please enter job descriptions")
        elif not job_salary:
            st.error("Please enter a salary")
        elif not job_location:
            st.error("Please enter a location")
        elif not job_industry:
            st.error("Please enter an industry")
        else:
            # packing up all the data that the user entered into a dictionary
            review_data = {
                "company": company,
                "job_title": job_title,
                "content": content,
                "location": job_location,
                "industry": job_industry,
                "salary": job_salary
            }
             
            logger.info(f"Review posted with data: {review_data}")
            
            # trying post request
            try:
                response = requests.post('http://api:4000/e/e/post_job', json=review_data)
                if response.status_code == 200:
                    st.success("Review posted successfully!")
                else:
                    st.error(f"Error posting review: {response.text}")
            except requests.exceptions.RequestException as e:
                st.error(f"Error connecting to server: {str(e)}")

        # test to see if review is really there
        #response = requests.get(f'http://api:4000/s/students/reviews')
        #reviews = response.json()
        #st.table(reviews)  



# Button to return to the employer homepage
if st.button('Return home'):
    st.switch_page('pages/31_Company_Home.py')
