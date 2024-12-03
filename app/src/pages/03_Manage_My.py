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
st.markdown("# Manage My Posts")   


# delete review functionality

user_id = 1  
response = requests.get(f'http://api:4000/s/students/student_reviews/{user_id}')

if response.status_code == 200:
    reviews = response.json()
    if reviews:
        # select a review to delete
        review_options = {f"Review ID {review['reviewId']} - {review['content']}": review['reviewId'] for review in reviews}
        selected_review = st.selectbox("Select a Review to Delete", list(review_options.keys()))

        if selected_review:
            review_id = review_options[selected_review]
            selected_review_data = next((r for r in reviews if r['reviewId'] == review_id), None)
            
            # show current review details
            st.write("### Review to Delete")
            st.write(f"**Content:** {selected_review_data['content']}")
            st.write(f"**Stars:** {selected_review_data['stars']}")

            # confirmation Button
            if st.button("Delete Review", type='primary', use_container_width=True):
                delete_response = requests.delete(f'http://api:4000/s/students/delete_review/{review_id}')
                
                if delete_response.status_code == 200 or delete_response.status_code == 204:
                    st.success("Review deleted successfully!")
                else:
                    st.error(f"Failed to delete review: {delete_response.status_code}")
    else:
        st.write("No reviews found.")
else:
    st.error("Failed to fetch reviews.")

st.divider()

# edit review functionality
user_id = 1  
response = requests.get(f'http://api:4000/s/students/student_reviews/{user_id}')

if response.status_code == 200:
    reviews = response.json()
    if reviews:
        # select a review to edit
        review_options = {f"Review ID {review['reviewId']} - {review['content']}": review['reviewId'] for review in reviews}
        selected_review = st.selectbox("Select a Review to Edit", list(review_options.keys()))

        if selected_review:
            review_id = review_options[selected_review]
            selected_review_data = next((r for r in reviews if r['reviewId'] == review_id), None)
            
            # show current review details
            st.write("### Current Review")
            st.write(f"**Content:** {selected_review_data['content']}")
            st.write(f"**Stars:** {selected_review_data['stars']}")

            # edit form
            st.write("### Edit Review")
            with st.form("edit_review_form"):
                new_content = st.text_area("Edit Content", value=selected_review_data['content'])
                new_stars = st.slider("Edit Stars", min_value=1, max_value=5, value=selected_review_data['stars'])

                submitted = st.form_submit_button("Update Review")
                if submitted:

                    update_response = requests.put(
                        f'http://api:4000/s/students/edit_review/{review_id}',
                        json={"content": new_content, "stars": new_stars}
                    )
                    
                    if update_response.status_code == 200:
                        st.success("Review updated successfully!")
                    else:
                        st.error(f"Failed to update review: {update_response.json().get('error', 'Unknown error')}")
    else:
        st.write("No reviews found.")
else:
    st.error("Failed to fetch reviews.")

st.divider()

if st.button('Return home'):
    st.switch_page('pages/00_Student_Home.py')
