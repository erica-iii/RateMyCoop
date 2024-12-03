import streamlit as st
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# About this App")

st.markdown (
    """
    Rate My Co-op is an app designed to help Northeastern students with their co-op search!

    By creating a hub for previous co-op students to share their experiences and contribute their statistics to company analytics, 
    students can make the process easier and more fullfilling for their peers.
    """
        )
