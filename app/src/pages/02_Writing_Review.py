import logging
logger = logging.getLogger(__name__)
import streamlit as st
from streamlit_extras.app_logo import add_logo
import pandas as pd
import pydeck as pdk
from urllib.error import URLError
from modules.nav import SideBarLinks
import requests

SideBarLinks()

# add the logo
add_logo("assets/logo.png", height=400)

# set up the page
st.markdown("# Write a Review")

# fetching company and coop options
try:
    companies_response = requests.get('http://api:4000/s/students/companies')
    
    if companies_response.status_code == 200:
        company_data = companies_response.json()
        company_options = [""] + [company['companyName'] for company in company_data]
    else:
        st.error("Failed to fetch companies")
        company_options = []
except requests.exceptions.RequestException as e:
    st.error(f"Error connecting to companies API: {str(e)}")
    company_options = []

# creating review form widget
with st.form("add_review_form"):
    
    # creating the various input widgets needed for each piece of information from the user
    company = st.selectbox("Company", options=company_options, index=0)
    job_title = st.text_input("Job Title:")
    content = st.text_area("Write your review:")
    stars = st.slider("Rating (Stars):", min_value=1, max_value=5, step=1)
    anonymous = st.checkbox("Post anonymously?")
    
    # adding the submit button
    submit_button = st.form_submit_button("Post Review")
    
    # validating that all fields are filled when form is submitted
    if submit_button:
        if not company:
            st.error("Please select a company")
        elif not job_title:
            st.error("Please enter a job title")
        elif not content:
            st.error("Please enter review text")
        elif not stars:
            st.error("Please choose a star rating")
        else:
            # packing up all the data that the user entered into a dictionary
            review_data = {
                "company": company,
                "job_title": job_title,
                "content": content,
                "stars": stars,
                "anonymous": 1 if anonymous else 0
            }
             
            logger.info(f"Review posted with data: {review_data}")
            
            # trying post request
            try:
                response = requests.post('http://api:4000/s/students/post_review', json=review_data)
                if response.status_code == 200:
                    st.success("Review posted successfully!")
                else:
                    st.error(f"Error posting review: {response.text}")
            except requests.exceptions.RequestException as e:
                st.error(f"Error connecting to server: {str(e)}")

        # test to see if review is really there
        response = requests.get(f'http://api:4000/s/students/reviews')
        reviews = response.json()
        st.table(reviews)  
     