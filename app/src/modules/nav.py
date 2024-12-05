# Idea borrowed from https://github.com/fsmosca/sample-streamlit-authenticator

# This file has function to add certain functionality to the left side bar of the app

import streamlit as st


#### ------------------------ General ------------------------
def HomeNav():
    st.sidebar.page_link("Home.py", label="Home", icon="🏠")


def AboutPageNav():
    st.sidebar.page_link("pages/30_About.py", label="About", icon="🧠")


#### ------------------------ navigation fro student role ------------------------
def StudentHomeNav():
    st.sidebar.page_link(
        "pages/00_Student_Home.py", label="Student Home", icon="👤"
    )


def ReviewFeedNav():
    st.sidebar.page_link(
        "pages/01_Review_Feed.py", label="View Reviews", icon="👁️"
    )


def PostNav():
    st.sidebar.page_link("pages/02_Writing_Review.py", label="Post a Review", icon="📝")

def ManageNav():
    st.sidebar.page_link("pages/03_Manage_My.py", label="Manage Posts", icon="⚙️")

## ------------------------ Examples for Role of usaid_worker ------------------------
def ApiTestNav():
    st.sidebar.page_link("pages/12_API_Test.py", label="Test the API", icon="🛜")


def PredictionNav():
    st.sidebar.page_link(
        "pages/11_Prediction.py", label="Regression Prediction", icon="📈"
    )


def ClassificationNav():
    st.sidebar.page_link(
        "pages/13_Classification.py", label="Classification Demo", icon="🌺"
    )


#### ------------------------ System Admin Role ------------------------
def AdminPageNav():
    st.sidebar.page_link("pages/20_Admin_Home.py", label="System Admin", icon="🖥️")
    st.sidebar.page_link('pages/25_Student_Information.py', label='Student Information', icon = '📊')
    st.sidebar.page_link('pages/22_Monitor_Reviews.py', label='Monitor Reviews', icon = '📝')
    st.sidebar.page_link('pages/23_App_Requests.py', label='App Request', icon = '❓')
    st.sidebar.page_link('pages/24_System_Update.py', label='System Updates', icon = '⚙️')

#### --------------------------- Co-op Advisor Role -----------------------------------------
def AdvisorPageNav():
    st.sidebar.page_link("pages/11_Search_Coops.py", label="Co-op Search", icon='🔎')
    st.sidebar.page_link("pages/12_Search_Demographics.py", label="Demographic Search", icon='📈')
    st.sidebar.page_link("pages/13_Search_Companies.py", label='Company Search', icon='🏢')
    


# --------------------------------Links Function -----------------------------------------------
def SideBarLinks(show_home=False):
    """
    This function handles adding links to the sidebar of the app based upon the logged-in user's role, which was put in the streamlit session_state object when logging in.
    """

    # add a logo to the sidebar always
    st.sidebar.image("assets/logo.png", width=150)

    # If there is no logged in user, redirect to the Home (Landing) page
    if "authenticated" not in st.session_state:
        st.session_state.authenticated = False
        st.switch_page("Home.py")

    if show_home:
        # Show the Home page link (the landing page)
        HomeNav()

    # Show the other page navigators depending on the users' role.
    if st.session_state["authenticated"]:

        # Show options for students.
        if st.session_state["role"] == "student":
            StudentHomeNav()
            ReviewFeedNav()
            PostNav()
            ManageNav()

        # If the user role is usaid worker, show the Api Testing page
        if st.session_state["role"] == "usaid_worker":
            PredictionNav()
            ApiTestNav()
            ClassificationNav()

        if st.session_state['role'] == 'coop_advisor':
            AdvisorPageNav()

        # If the user is an administrator, give them access to the administrator pages
        if st.session_state["role"] == "administrator":
            AdminPageNav()

    # Always show the About page at the bottom of the list of links
    AboutPageNav()

    if st.session_state["authenticated"]:
        # Always show a logout button if there is a logged in user
        if st.sidebar.button("Logout"):
            del st.session_state["role"]
            del st.session_state["authenticated"]
            st.switch_page("Home.py")
