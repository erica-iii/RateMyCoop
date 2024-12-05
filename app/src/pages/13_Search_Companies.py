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
st.header('Search Companies')

# You can access the session state to make a more customized/personalized app experience
st.write(f"### Hi, {st.session_state['first_name']}. Search Companies by Industry and Pay.")

response = requests.get('http://api:4000/a/advisors/companies')
companies = response.json()  
companies_meta = [company['companyName'] for company in companies] 


avgCoopRating = st.text_input("Minimum Average Co-op Rating:", value=0)
avgCoopPay = st.text_input("Minimum Average Co-op Hourly Pay", value=15)

response = requests.get(f"http://api:4000/a/advisors/company_search?avgCoopRating={avgCoopRating}&avgCoopPay={avgCoopPay}")

if response.status_code == 200:
    results = response.json()
    st.write('### Company Search Results:')
    results_df = pd.DataFrame(results)
    st.table(results_df)

st.write("### Otherwise, discover Company statistics:")

company_name = st.selectbox("Select a Company:", companies_meta)

response = requests.get(f"http://api:4000/a/advisors/companies/{company_name}")

if response.status_code == 200:
    company_stats = response.json()
    st.write(f"{company_name}'s statistics:")
    company_stats_df = pd.DataFrame(company_stats)
    st.table(company_stats_df)

