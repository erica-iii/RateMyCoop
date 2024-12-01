import logging
logger = logging.getLogger(__name__)
import streamlit as st
from modules.nav import SideBarLinks
import requests

st.set_page_config(layout = 'wide')

SideBarLinks()

st.title('App Administration Page')

st.write('\n\n')
st.write('## Model 1 Maintenance')

st.button("Reviews", 
            type = 'primary', 
            use_container_width=True)

st.button('Test Model 01', 
            type = 'primary', 
            use_container_width=True)

if st.button('Model 1 - get predicted value for 10, 25', 
             type = 'primary',
             use_container_width=True):
  results = requests.get('http://api:4000/c/prediction/10/25').json()
  st.dataframe(results)
