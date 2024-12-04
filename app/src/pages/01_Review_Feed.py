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

# Call the SideBarLinks from the nav module in the modules directory
SideBarLinks()

# set the header of the page
st.header('Reviews')

# You can access the session state to make a more customized/personalized app experience
st.write(f"### Hi, {st.session_state['first_name']}. View Reviews and Analytics.")

response = requests.get('http://api:4000/s/students/companies')
companies = response.json()  
company_names = [company['companyName'] for company in companies] 

company = st.selectbox(
    "Please choose a company to view reviews and analytics for",
    company_names
)
st.write("Results for:", company)
# analytics section

st.write("### Company Analytics")
st.write("(Statistics of previous hires in our database)")

response_a = requests.get(f'http://api:4000/s/students/company_analytics/{company}') 

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

st.write("### Company Reviews")

# reviews section
response = requests.get(f'http://api:4000/s/students/comp_reviews/{company}')
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

        # add Comment Section
        with st.expander("Add a Comment"):
            comment_text = st.text_area(f"Write your comment for review {review['reviewId']}")
            if st.button(f"Submit Comment for Review {review['reviewId']}", key=f"submit-{review['reviewId']}"):
                comment_payload = {
                    "reviewId": review["reviewId"],
                    "poster": 1, 
                    "content": comment_text
                }
                #st.write("Payload:", comment_payload)
                
                comment_response = requests.post('http://api:4000/s/students/add_comment', json=comment_payload)
                if comment_response.status_code == 200:
                    st.success("Comment added successfully!")
                else:
                    st.error(f"Failed to add comment: {comment_response.json().get('error', 'Unknown error')}")

        st.write("---")  
else:
    st.write("No reviews available for this company.")

if st.button('Return home'):
    st.switch_page('pages/00_Student_Home.py')
