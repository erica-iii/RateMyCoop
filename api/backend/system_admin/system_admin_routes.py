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
@systemadmin.route('/studentReviews', methods=['GET'])
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

    approved = data.get('resolveStatus')

    query = """
        UPDATE requests SET resolveStatus = %s WHERE requestId = %s'
    """
    cursor = db.get_db().cursor()
    cursor.exdcute(query, (approved, request_id))
    db.get_db().commit()
    
    return make_response("Request Updated", 200)

'''
@systemadmin.route('/updateAnalytics', methods=['POST'])
def update_analytics():

    # collecting the data
    the_data = request.json
    current_app.logger.info(the_data)

    poster = 1
    company = the_data['company']
    job_title = the_data['job_title']
    content = the_data['content']
    stars = the_data['stars']
    anonymous = the_data['anonymous']
    
    # inserting data
    cursor = db.get_db().cursor()

    cursor.execute("SELECT companyId FROM companies WHERE companyName = %s", (company,))
    company = cursor.fetchone()

    if not company:
        cursor.execute("INSERT INTO companies (companyName, activityStatus) VALUES (%s, %s)", (company, 1))
        db.get_db().commit()
        cursor.execute("SELECT companyId FROM companies WHERE companyName = %s", (company,))
        company = cursor.fetchone()

    company_id = company['companyId']

    cursor.execute("SELECT coopId FROM coops WHERE jobTitle = %s AND company = %s", (job_title, company_id))
    coop = cursor.fetchone()

    if not coop:
        cursor.execute("INSERT INTO coops (jobTitle, company) VALUES (%s, %s)", (job_title, company_id))
        db.get_db().commit()
        cursor.execute("SELECT coopId FROM coops WHERE jobTitle = %s AND company = %s", (job_title, company_id))
        coop = cursor.fetchone()

    coop_id = coop['coopId']

    # running query to insert review 
    query = """
        INSERT INTO reviews (poster, reviewOf, anonymous, content, stars, coopId)
        VALUES (%s, %s, %s, %s, %s, %s)
    """
    cursor = db.get_db().cursor()

    cursor.execute(query, (poster, company_id, anonymous, content, stars, coop_id))
    db.get_db().commit()
    
    response = make_response("Successfully posted review!")
    response.status
'''