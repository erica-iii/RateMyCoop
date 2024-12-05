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
st.header('Company Reviews and Demographics')


st.write(f"### Welcome, {st.session_state['company_name']}!")

# get reviews for own company
reviews_response = requests.get(f'http://api:4000/e/companies/{st.session_state["company_id"]}/reviews')
if reviews_response.status_code == 200:
    reviews = reviews_response.json()
    if reviews:
        st.write("### Reviews for your company:")
        for review in reviews:
            # Display each review
            st.write(f"#### Review by: {review['reviewerName']}")
            st.write(f"**Rating:** {review['rating']} stars")
            st.write(f"**Review Content:** {review['content']}")
            st.write(f"**Posted on:** {review['createdAt']}")
            st.write("---")
    else:
        st.write("No reviews available for your company.")
else:
    st.error(f"Failed to fetch reviews: {reviews_response.status_code}")

# Fetch demographic data for the company
demographics_response = requests.get(f'http://api:4000/e/companies/{st.session_state["company_id"]}/demographics')
if demographics_response.status_code == 200:
    demographics = demographics_response.json()
    st.write("### Demographics and Analytics:")

    # Display top majors
    top_majors = demographics.get('topMajors', [])
    if top_majors:
        st.write("#### Top Majors of Reviewers:")
        for major in top_majors:
            st.write(f"- {major}")
    else:
        st.write("No major data available.")

    # Display average rating
    avg_rating = demographics.get('averageRating', None)
    if avg_rating is not None:
        st.write(f"#### Average Rating: {avg_rating} stars")
    else:
        st.write("No average rating data available.")

    # Display total number of reviews
    total_reviews = demographics.get('totalReviews', 0)
    st.write(f"#### Total Number of Reviews: {total_reviews}")
else:
    st.error(f"Failed to fetch demographics: {demographics_response.status_code}")

# Button to return to the homepage or employer dashboard
if st.button('Return home'):
    st.switch_page('pages/34_Company_Home.py')
