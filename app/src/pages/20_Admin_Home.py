import logging
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks
import requests

st.set_page_config(layout = 'wide')

SideBarLinks()

st.title('Welcome System Admin, Clark.')

st.write('### What would you like to do today?')


if st.button('Monitor Reviews', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/22_Monitor_Reviews.py')

if st.button('Review Student Information', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/25_Student_Information.py')

if st.button('App Requests', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/23_App_Requests.py')

if st.button('System Updates', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/24_System_Update.py')