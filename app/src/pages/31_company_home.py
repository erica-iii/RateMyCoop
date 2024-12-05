import logging
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks

st.set_page_config(layout='wide')

SideBarLinks()

st.title(f"Welcome Company Admin, {st.session_state['company_name']}.")

st.write('')
st.write('')
st.write('### What would you like to do today?')

if st.button('View My Reviews', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/31_Company_Review_Feed.py')

if st.button('Post Internship Opportunities', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/32_Post_Opportunities.py')

if st.button('View All Internship Listings', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/33_View_Internships.py')
