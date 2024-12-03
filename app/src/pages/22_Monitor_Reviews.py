import logging
logger = logging.getLogger(__name__)
import streamlit as st
from modules.nav import SideBarLinks
import requests


SideBarLinks()

st.title('Monitor Reviews Page')

st.write('\n\n')


# set up the page
st.markdown("## Monitor to see if there are any inappropriate reviews")   

options = requests.get(f'http://api:4000/sa/studentReviews').json()

ids = [int(review['reviewId']) for review in options]


review_id = st.selectbox('Review ID To Delete', 
                       ids,                  
                    label_visibility="visible")

if st.button("Delete", 
            type='primary', 
            use_container_width=True):
    response = requests.delete(f'http://api:4000/sa/delete_review/{review_id}')
    
    if response.status_code == 200 or response.status_code == 204:
        st.write('Review deleted successfully!')
    else:
        st.write(f'Delete failed :( {response.status_code}')

reviews = requests.get(f'http://api:4000/sa/studentReviews')
reviews = reviews.json()
st.table(reviews) 