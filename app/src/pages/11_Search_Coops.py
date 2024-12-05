import logging
logger = logging.getLogger(__name__)
import pandas as pd
import streamlit as st
from streamlit_extras.app_logo import add_logo
import matplotlib.pyplot as plt
import numpy as np
from modules.nav import SideBarLinks
import requests

# Call the SideBarLinks from the nav module in the modules directory
SideBarLinks()

# set the header of the page
st.header('Search Co-ops')

# You can access the session state to make a more customized/personalized app experience
st.write(f"### Hi, {st.session_state['first_name']}. Search Co-ops by Industry and Pay.")

response = requests.get('http://api:4000/a/advisors/industries')
industries = response.json()  
industries_meta = [industry['industry'] for industry in industries] 

pay = st.text_input("Hourly Pay:", value=15)
industry = st.selectbox("Industry:", industries_meta)

response = requests.get(f'http://api:4000/a/advisors/coop_search?industry={industry}&hourlyRate={pay}')

if response.status_code == 200:
    industry_results = response.json()
    results_df = pd.DataFrame(industry_results)
    st.write("#### Results:")
    st.table(results_df)
else:
    st.write("An error occurred when processing this search. Please try again after a few minutes.")

st.write('### Demographic Information about jobs with this title:')

job_title = st.text_input("Job Title:", value=results_df.loc[0, 'jobTitle'])

response = requests.get(f'http://api:4000/a/advisors/{job_title}')

if response.status_code == 200:
    job_info = response.json()
    job_info_df = pd.DataFrame(job_info)
    st.write("#### Job Information:")
    
     # If no publicly accessible demographics
    if len(job_info_df) == 0:
        st.write('Job Information Not Currently Available.')
    else:
        st.table(job_info_df)
else:
    st.write("An error occurred when processing this search. Please try again after a few minutes.") 