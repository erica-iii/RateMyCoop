import logging
logger = logging.getLogger(__name__)
import streamlit as st
from modules.nav import SideBarLinks
import requests

st.set_page_config(layout = 'wide')

SideBarLinks()

st.title('Monitor Reviews Page')

st.write('\n\n')


# set up the page
st.markdown("# Manage My Reviews and Comments")   

options = requests.get(f'http://api:4000/s/sa/monitorReviews').json()

ids = []

for i in options:
    ids.append(int(i['reviewId'])) 


review_id = st.selectbox('Review To Delete', 
                       ids,                  
                    label_visibility="visible")

if st.button("Delete", 
            type='primary', 
            use_container_width=True):
    response = requests.delete(f'http://api:4000/sa/monitorReviews')
    
    if response.status_code == 200 or response.status_code == 204:
        st.write('Review deleted successfully!')
    else:
        st.write(f'Delete failed :( {response.status_code}')

ellies_reviews = requests.get(f'http://api:4000/sa/monitorReviews')
reviews = ellies_reviews.json()
st.table(reviews)
