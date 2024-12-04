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
@systemadmin.route('/deleteReview/<int:review_id>', methods=['DELETE'])
def delete_reviews(review_id):
    cursor = db.get_db().cursor()
    
    cursor.execute("DELETE FROM reviews WHERE reviewId = %s", (review_id,)) 
    db.get_db().commit()
    
    return make_response("Review deleted", 200)


# get all the reviews
@systemadmin.route('/requests', methods=['GET'])
def get_requests():
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
    data = request.json
    current_app.logger.info(data)

    if 'resolveStatus' not in data:
        return make_response("Missing 'resolveStatus' field", 400)

    approved = data.get('resolveStatus')

    query = """
        UPDATE requests SET resolveStatus = %s WHERE requestId = %s
    """
    cursor = db.get_db().cursor()
    cursor.execute(query, (approved, request_id))
    db.get_db().commit()
    return make_response("Request Updated", 200)

@systemadmin.route('/allUpdates', methods=["GET"])
def get_updates():
    query = '''
        SELECT * FROM system_updates
    '''

    cursor = db.get_db().cursor()
    cursor.execute(query)

    theData = cursor.fetchall()
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200

    return the_response

@systemadmin.route('/systemUpdates', methods=['POST'])
def add_system_update():
     
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variables
    details = the_data['details']
    updatedBy = the_data['updatedBy']
    
    query = f'''
        INSERT INTO system_updates (details, updatedBy)
        VALUES (%s, %s)
    '''
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query, (details, updatedBy))
    db.get_db().commit()
    
    response = make_response("Successfully added system updated")
    response.status_code = 200
    return response