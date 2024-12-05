import logging
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')

# Show appropriate sidebar links for the role of the currently logged in user
SideBarLinks()

st.title(f"Welcome Advisor, {st.session_state['first_name']}.")
st.write('')
st.write('')
st.write('### What would you like to do today?')

if st.button('Search Co-ops', 
             type='primary', 
             use_container_width=True):
    st.switch_page('pages/11_Search_Coops.py')

if st.button('Search by Demographics', 
             type='primary', 
             use_container_width=True):
    st.switch_page('pages/12_Search_Demographics.py')

if st.button('Search Companies',
             type='primary',
             use_container_width=True):
    st.switch_page('pages/13_Search_Companies.py')