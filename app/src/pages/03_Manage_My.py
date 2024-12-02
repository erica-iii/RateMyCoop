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
st.markdown("# Manage My Reviews and Comments")     

options = requests.get(f'http://api:4000/s/students/student_reviews/{1}').json()

ids = []

for i in options:
    ids.append(int(i['reviewId'])) 


review_id = st.selectbox('reviewId', 
                       ids,                  
                    label_visibility="visible")

if st.button("Delete", 
            type='primary', 
            use_container_width=True):
    response = requests.delete(f'http://api:4000/s/students/delete_review/{review_id}')
    
    if response.status_code == 200 or response.status_code == 204:
        st.write('Review deleted successfully!')
    else:
        st.write(f'Delete failed :( {response.status_code}')