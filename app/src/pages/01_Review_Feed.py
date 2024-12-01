import logging
logger = logging.getLogger(__name__)
import pandas as pd
import streamlit as st
from streamlit_extras.app_logo import add_logo
#import world_bank_data as wb
import matplotlib.pyplot as plt
import numpy as np
#import plotly.express as px
from modules.nav import SideBarLinks
import requests

# Plans: make a drop down show first, whatever company from fakes put in is the one who's data gets called

# Call the SideBarLinks from the nav module in the modules directory
SideBarLinks()

# set the header of the page
st.header('Reviews')

# You can access the session state to make a more customized/personalized app experience
st.write(f"### Hi, {st.session_state['first_name']}. View Reviews.")

response1 = requests.get('http://api:4000/s/students/companies')
companies = response1.json()  
company_names = [company['companyName'] for company in companies] 

company = st.selectbox(
    "Please choose a company to view reviews for",
    company_names
)
st.write("Reviews for:", company)

response2 = requests.get('http://api:4000/s/students/comp_reviews/{company}')
reviews = response2.json()
st.dataframe(reviews)