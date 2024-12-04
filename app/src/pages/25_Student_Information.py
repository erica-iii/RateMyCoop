import logging
logger = logging.getLogger(__name__)
import streamlit as st
from modules.nav import SideBarLinks
import requests

st.set_page_config(layout = 'wide')

SideBarLinks()

st.title('Student Information Page')

st.write('### This is the student data that is relevant to the system admin')

st.write('\n\n')


data = {} 
try:
  data = requests.get('http://api:4000/sa/studentInformation').json() 
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data = {"a":{"b": "123", "c": "hello"}, "z": {"b": "456", "c": "goodbye"}}

st.dataframe(data)
