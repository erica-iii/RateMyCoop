import logging
logger = logging.getLogger(__name__)
import pandas as pd
import streamlit as st
from streamlit_extras.app_logo import add_logo
import world_bank_data as wb
import matplotlib.pyplot as plt
import numpy as np
import plotly.express as px
from modules.nav import SideBarLinks

# Plans: make a drop down show first, whatever company from fakes put in is the one who's data gets called

# Call the SideBarLinks from the nav module in the modules directory
SideBarLinks()

# set the header of the page
st.header('Reviews')

# You can access the session state to make a more customized/personalized app experience
st.write(f"### Hi, {st.session_state['first_name']}. Please choose a company to view reviews for.")

# get the countries from the world bank data
with st.echo(code_location='above'):
    countries:pd.DataFrame = wb.get_countries()
   
    st.dataframe(countries)

# the with statment shows the code for this block above it 
with st.echo(code_location='above'):
    arr = np.random.normal(1, 1, size=100)
    test_plot, ax = plt.subplots()
    ax.hist(arr, bins=20)

    st.pyplot(test_plot)


with st.echo(code_location='above'):
    slim_countries = countries[countries['incomeLevel'] != 'Aggregates']
    data_crosstab = pd.crosstab(slim_countries['region'], 
                                slim_countries['incomeLevel'],  
                                margins = False) 
    st.table(data_crosstab)
