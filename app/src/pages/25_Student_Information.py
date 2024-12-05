import logging
logger = logging.getLogger(__name__)
import streamlit as st
from modules.nav import SideBarLinks
import requests

st.set_page_config(layout = 'wide')

SideBarLinks()

st.title('Student Information Page')

st.write('### This is all the available student data, choose a student Id to filter')

st.write('\n\n')
  
data = {} 
options = requests.get(f'http://api:4000/sa/allStudentInformation').json()
st.dataframe(options)

ids = [int(info['studentId']) for info in options]


student_id = st.selectbox('Student Id to view', 
                       ids,                  
                    label_visibility="visible")

if st.button("View", 
            type='primary', 
            use_container_width=True):
    try:
      data = requests.get(f'http://api:4000/sa/studentInformation/{student_id}').json() 
    except:
      st.write("**Important**: Could not connect to sample api, so using dummy data.")
      data = {"a":{"b": "123", "c": "hello"}, "z": {"b": "456", "c": "goodbye"}}

st.dataframe(data)
