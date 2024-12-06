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
st.header('Delete any Co-op Posting From Your Company')

# Fetch the list of job listings for the employer

options = requests.get(f'http://api:4000/e/coops').json()

ids = [int(review['coopId']) for review in options]


coop_Id = st.selectbox('Co-op ID To Delete', 
                       ids,                  
                    label_visibility="visible")

if st.button("Delete", 
            type='primary', 
            use_container_width=True):
    response = requests.delete(f'http://api:4000/e/deleteCoop/{coop_Id}')
    
    if response.status_code == 200 or response.status_code == 204:
        st.write('Co-op deleted successfully!')
    else:
        st.write(f'Delete failed :( {response.status_code}')

reviews = requests.get(f'http://api:4000/e/coops')
reviews = reviews.json()
st.table(reviews) 