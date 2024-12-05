import logging
import requests
import streamlit as st

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
    companies_response = requests.get('http://api:4000/e/companies')
    if companies_response.status_code == 200:
        companies = companies_response.json()
        company_names = [company['companyName'] for company in companies]
        selected_company_name = st.selectbox("Select a company to view reviews", company_names)
        
        # Find the selected company's ID
        selected_company = next(company for company in companies if company['companyName'] == selected_company_name)
        selected_company_id = selected_company['companyId']
    else:
        st.error(f"Failed to fetch company list: {companies_response.status_code}")
        st.stop()
else:
    selected_company_id = st.session_state["company_id"]
    selected_company_name = st.session_state["company_name"]

# Fetch reviews for the selected company
reviews_response = requests.get(f'http://api:4000/e/companies/{selected_company_id}/reviews')
if reviews_response.status_code == 200:
    reviews = reviews_response.json()

    if reviews:
        st.write(f"### Reviews for {selected_company_name}:")
        for review in reviews:
            # Display each review
            st.write(f"#### Review by: {review['reviewerName']}")
            st.write(f"**Rating:** {review['rating']} stars")
            st.write(f"**Review Content:** {review['content']}")
            st.write(f"**Posted on:** {review['createdAt']}")
            st.write("---")
    else:
        st.write(f"No reviews available for {selected_company_name}.")
else:
    st.error(f"Failed to fetch reviews: {reviews_response.status_code}")

# Fetch demographic data for the selected company
demographics_response = requests.get(f'http://api:4000/e/companies/{selected_company_id}/demographics')
if demographics_response.status_code == 200:
    demographics = demographics_response.json()
    st.write(f"### Demographics and Analytics for {selected_company_name}:")

    # Display top majors
    top_majors = demographics.get('topMajors', [])
    if top_majors:
        st.write("#### Top Majors of Reviewers:")
        for major in top_majors:
            st.write(f"- {major}")
    else:
        st.write("No major data available.")

    # show average rating
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

# Button to return to the company home page
if st.button('Return home'):
    st.switch_page('pages/31_Company_Home.py')
