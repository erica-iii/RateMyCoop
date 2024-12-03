import logging
logger = logging.getLogger(__name__)
import streamlit as st
from modules.nav import SideBarLinks
import requests

st.set_page_config(layout = 'wide')

SideBarLinks()

st.markdown("# Add a System Update")

# Creating the form for submitting a system update
with st.form("add_system_update_form"):
    # Input fields for system update details
    details = st.text_area("Update Details:")
    updated_by = st.number_input("Admin ID (Updated By):", min_value=1, step=1)

    # Adding the submit button
    submit_button = st.form_submit_button("Add System Update")

    # Validating form submission
    if submit_button:
        if not details:
            st.error("Please provide details for the system update.")
        elif not updated_by:
            st.error("Please provide the Admin ID.")
        else:
            # Packing up the data into a dictionary
            update_data = {
                "details": details,
                "updatedBy": int(updated_by)
            }

            logger.info(f"System update submitted with data: {update_data}")

            # Making the POST request to add the system update
            try:
                response = requests.post('http://api:4000/sa/systemUpdates', json=update_data)
                if response.status_code == 200:
                    st.success("System update added successfully!")
                else:
                    st.error(f"Error adding system update: {response.text}")
            except requests.exceptions.RequestException as e:
                st.error(f"Error connecting to server: {str(e)}")

        requests = requests.get('http://api:4000/sa/allUpdates')
        requests = requests.json()
        st.table(requests)
