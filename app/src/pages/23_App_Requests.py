import logging
logger = logging.getLogger(__name__)
import streamlit as st
from streamlit_extras.app_logo import add_logo
import pandas as pd
import pydeck as pdk
from urllib.error import URLError
from modules.nav import SideBarLinks
import requests

st.set_page_config(layout = 'wide')

SideBarLinks()

st.title('Update Requests Resolve Status Page')

st.write('\n\n')


options = requests.get('http://api:4000/sa/requests').json()

ids = [int(request['requestId']) for request in options]

request_id = st.selectbox('Select Request Id to Update', ids, label_visibility='visible')

selected_request = None
for request in options:
    if request['requestId'] == request_id:
        selected_request = request
        break

if selected_request:
    approved = st.checkbox('Resolved', value=selected_request.get('resolveStatus', False))

    if st.button('Update Request'):
        response = requests.put(f'http://api:4000/sa/updateRequests/{request_id}', json={'resolveStatus': approved})

        if response.status_code == 200:
            st.write('Resolve status updated successfully')
        else:
            st.write(f'Failed to update the request. Status code: {response.status_code}')

requests = requests.get('http://api:4000/sa/requests')
requests = requests.json()
st.table(requests)