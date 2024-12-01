import logging
logger = logging.getLogger(__name__)
import streamlit as st
from streamlit_extras.app_logo import add_logo
import pandas as pd
import pydeck as pdk
from urllib.error import URLError
from modules.nav import SideBarLinks
import requests

SideBarLinks()

# add the logo
add_logo("assets/logo.png", height=400)

# set up the page
st.markdown("# Write a Review")

company = st.text_input("Company Name:")
job_title = st.text_input("Coop Job Title:")
content = st.text_area("Write your review:")
stars = st.slider("Rating (Stars):", min_value=1, max_value=5, step=1)
anonymous = st.checkbox("Post as anonymous?")

if st.button("Post Review"):
    review_data = {
        "poster": 1,
        "review_of": company,
        "content": content,
        "stars": stars,
        "coop": job_title,
        "anonymous": 1 if anonymous else 0
    }

#st.write("Review Data:", review_data) 

response = requests.post("http://api:4000/s/students/new_review", json=review_data)

if response.status_code == 201:
        st.success("Your review has been successfully submitted!")
else:
        st.write('Oops:', response.status_code, response.text)  