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
st.header('Search Job Demographics')
avg_GPA = st.text_input('Minimum Average GPA on a 4.0 scale:', value=2.0)
avg_Leadership = st.text_input('Minimum Average No. of Leadership Experiences:', value=0)


response = requests.get(f'http://api:4000/a/advisors/demographic_search?avg_GPA={avg_GPA}&avg_Leadership={avg_Leadership}')

if response.status_code == 200:
    job_demo = response.json()
    job_demo_df = pd.DataFrame(job_demo)
    st.write("#### Jobs fitting this demographic search:")
    st.write("##### Note: Only jobs with non-anonymized statistics can be accessed.")
    st.table(job_demo_df)
else:
    st.write("An error occurred when processing this search. Please try again after a few minutes.")

st.write("### Further Company Co-op Information:")

company_name = st.selectbox('Company:', job_demo_df['companyName'])
coop_name = st.selectbox('Co-op Name:', job_demo_df['jobTitle'])

response = requests.get(f'http://api:4000/a/advisors/companies/{company_name}/{coop_name}')

if response.status_code == 200:
    company_coop = response.json()
    st.write(f"### {company_name}'s {coop_name} position information:")
    st.write('#### Reviews:')
    for review in company_coop:
        st.write(f"##### Review by: {review['username']}")
        st.write(f"Stars: {review['stars']}")
        st.write(f"Content: {review['content']}")
        st.write(f"Likes: {review['likes']}")
        st.write(f"Posted on: {review['createdAt']}")



else:
    st.write("An error occurred when processing this search. Please try again after a few minutes.")
