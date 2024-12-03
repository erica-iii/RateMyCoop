import logging
logger = logging.getLogger(__name__)
import streamlit as st
from modules.nav import SideBarLinks
import requests

st.set_page_config(layout = 'wide')

SideBarLinks()

st.title('Update Analytics Page')

st.write('\n\n')

if st.button('Requests', 
             type = 'primary',
             use_container_width=True):
  results = requests.get('http://api:4000/sa/analytics').json()
  st.dataframe(results)