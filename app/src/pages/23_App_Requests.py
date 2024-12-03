import logging
logger = logging.getLogger(__name__)
import streamlit as st
from modules.nav import SideBarLinks
import requests

st.set_page_config(layout = 'wide')

SideBarLinks()

st.title('Update Requests Page')

st.write('\n\n')


options = requests.get('http://api:4000/sa/requests').json()

ids = [int(request['requestId']) for request in options]

request_id = st.selectbox('Select Request to Update', ids, label_visibility='visible')

selected_request = None
for request in options:
    if request['requestId'] == request_id:
        selected_request = request
        break

if selected_request:
    approved = st.checkbox('Approved', value=selected_request.get('resolveStatus', False))

    if st.button('Update Request'):
        updated_data = {
        'resolveStatus': approved
        }

        response = requests.put(f'http://api:4000/sa/updateRequests/{request_id}', json=updated_data)

        if response.status_code == 200:
            st.write('Request updated successfully')
        else:
            st.write(f'Failed to update the request. Status code: {response.status_code}')

requests = requests.get('http://api:4000/sa/requests')
requests = requests.json()
st.table(requests)