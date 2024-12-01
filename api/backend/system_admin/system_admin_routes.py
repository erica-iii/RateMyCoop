#################################################the top 5 most expensive products from the database#######
# Blueprint for System Admin Data
########################################################

from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

#------------------------------------------------------------
# Create a new Blueprint object, which is a collection of 
# routes.
systemadmin = Blueprint('systemadmin', __name__)

#------------------------------------------------------------
# Get all the reviews from the reviews table
@systemadmin.route('/monitorreviews', methods=['GET'])
def get_reviews():
    query = '''
        SELECT * FROM reviews
    '''
    
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products
    cursor.execute(query)

    # fetch all the data from the cursor
    # The cursor will return the data as a 
    # Python Dictionary
    theData = cursor.fetchall()

    # Create a HTTP Response object and add results of the query to it
    # after "jasonify"-ing it.
    response = make_response(jsonify(theData))
    # set the proper HTTP Status code of 200 (meaning all good)
    response.status_code = 200
    # send the response back to the client
    return response

# ------------------------------------------------------------
# Get the student information that is relevant to the admin
@systemadmin.route('/studentInformation')
def get_most_pop_products():

    query = '''
        SELECT studentId, activityStatus, statSharing
        FROM students
    '''
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
 
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response