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

# ------------------------------------------------------------
# Get the student information that is relevant to the admin
@systemadmin.route('/studentInformation')
def get_student_information():

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

# get all the reviews
@systemadmin.route('/reviews', methods=['GET'])
def get_reviews():
    query = '''
        SELECT 
            reviewId,
            stars,
            poster,
            content,
            likes,
            createdAt
        FROM 
            reviews 
    '''

    cursor = db.get_db().cursor()
    cursor.execute(query)

    theData = cursor.fetchall()
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200

    return the_response

# Delete any innapropriate reviews
@systemadmin.route('/delete_review/<int:review_id>', methods=['DELETE'])
def delete_reviews(review_id):
    cursor = db.get_db().cursor()
    
    cursor.execute("DELETE FROM reviews WHERE reviewId = %s", (review_id,)) 
    db.get_db().commit()
    
    return make_response("Review deleted", 200)

# get all the reviews
@systemadmin.route('/requests', methods=['GET'])
def get_reviews():
    query = '''
        SELECT * FROM requests
    '''

    cursor = db.get_db().cursor()
    cursor.execute(query)

    theData = cursor.fetchall()
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200

    return the_response

# Update the analytics
@systemadmin.route('/updateRequests/<int:request_id>', methods = ['PUT'])
def update_requests(request_id):
    cursor = db.get_db().cursor()

    updated_data = request.json
    approved = updated_data.get('requestStatus')

    cursor.execute('UPDATE requests SET requestStatus = %s WHERE requestId = %s', (request_id))
    db.get_db().commit()
    
    return make_response("Request Updated", 200)