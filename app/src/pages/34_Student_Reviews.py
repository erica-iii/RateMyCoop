import logging
logger = logging.getLogger(__name__)
import pandas as pd
import streamlit as st
from streamlit_extras.app_logo import add_logo
#import world_bank_data as wb
import matplotlib.pyplot as plt
import numpy as np
#import plotly.express as px
from modules.nav import SideBarLinks
import requests

# Set up logging
logger = logging.getLogger(__name__)

# Import the SideBarLinks for the navigation sidebar
from modules.nav import SideBarLinks


SideBarLinks()

# Header for the page
st.header('Company Reviews and Demographics')


# Option to view own company reviews or another company's reviews
view_option = st.radio(
    "Select the company whose reviews you want to view:",
    ("Your Company", "Another Company")
)

# If the company chooses "Another Company", allow them to select another company
if view_option == "Another Company":
    # Fetch all companies for the employer to choose from
    companies_response = requests.get('http://api:4000/s/students/companies')
    if companies_response.status_code == 200:
        companies = companies_response.json()
        company_names = [company['companyName'] for company in companies]
        selected_company_name = st.selectbox("Select a company to view reviews", company_names)
        
        # Find the selected company's ID
        #selected_company = next(company for company in companies if company['companyName'] == selected_company_name)
        #selected_company_name = selected_company['companyName']
    else:
        st.error(f"Failed to fetch company list: {companies_response.status_code}")
        st.stop()
else:
    selected_company_id = st.session_state["company_id"]
    selected_company_name = st.session_state["company_name"]

# analytics 
response_a = requests.get(f'http://api:4000/s/students/company_analytics/{selected_company_name}') 

if response_a.status_code == 200:
    analytics = response_a.json()  
    #st.json(analytics)  
    
    averages = analytics.get('averages', {})
    top_majors = analytics.get('topMajors', [])

    st.write("##### Averages")
    averages_df = pd.DataFrame([averages])
    st.table(averages_df)

    st.write("##### Top Majors")
    majors_df = pd.DataFrame(top_majors)
    st.table(majors_df)

else:
    st.error(f"Failed to fetch analytics: {response_a.status_code}")

# reviews
response = requests.get(f'http://api:4000/s/students/comp_reviews/{selected_company_name}')
reviews = response.json()

if reviews:
    for review in reviews:
        # fetch poster's name
        poster_response = requests.get(f'http://api:4000/s/students/poster_name/{review["reviewId"]}')

        if poster_response.status_code == 200:
            poster_data = poster_response.json()
            name = poster_data.get('posterName', 'Unknown')
        else:
            name = 'Unknown'

        # display review details
        st.write(f"##### Review by: {name}")
        st.write(f"Stars: {review['stars']}")
        st.write(f"Content: {review['content']}")
        st.write(f"Likes: {review['likes']}")
        st.write(f"Posted on: {review['createdAt']}")

        if st.button(f"Like this review ({review['reviewId']})", key=f"like-{review['reviewId']}"):
            like_response = requests.put(f'http://api:4000/s/students/like_review/{review["reviewId"]}')
            if like_response.status_code == 200:
                st.success("You liked this review!")
            else:
                st.error("Failed to like the review.")

         # fetch comments for the review
        comments_response = requests.get(f'http://api:4000/s/students/comments/{review["reviewId"]}')
        if comments_response.status_code == 200:
            comments = comments_response.json()
            st.write("##### Comments:")
            for comment in comments:
                st.write(f"**{comment['commenterName']}**: {comment['content']}")
                st.write("---")
        else:
            st.write("No comments yet.")

        st.write("---")  
else:
    st.write("No reviews available for this company.")

# Button to return to the company home page
if st.button('Return home'):
    st.switch_page('pages/31_Company_Home.py')
