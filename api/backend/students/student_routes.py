# blueprint for students

from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

students = Blueprint('students', __name__)

@students.route('/students/companies', methods=['GET'])
def get_companies():

    cursor = db.get_db().cursor()
    cursor.execute('''SELECT companyName FROM companies
    ''')
    
    theData = cursor.fetchall()
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

@students.route('/students/reviews', methods=['GET'])
def get_reviews():
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT * FROM reviews
    ''')
    
    theData = cursor.fetchall()
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response


@students.route('/students/comp_reviews/<company_name>', methods=['GET'])
def get_company_reviews(company_name):
    query = '''
        SELECT 
            r.reviewid,
            r.stars,
            r.poster,
            r.content,
            r.likes,
            r.createdAt
        FROM 
            reviews r
        JOIN 
            coops cp ON r.coopId = cp.coopId
        JOIN
            companies c ON cp.company = c.companyId
        WHERE 
            c.companyName = %s
    '''

    cursor = db.get_db().cursor()
    cursor.execute(query, (company_name,))

    theData = cursor.fetchall()
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200

    return the_response

@students.route('/students/post_review', methods=['POST'])
def post_review():
    # In a POST request, there is a 
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    poster = 1
    company = the_data['company']
    job_title = the_data['job_title']
    content = the_data['content']
    stars = the_data['stars']
    anonymous = the_data['anonymous']
    
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

    query = """
        INSERT INTO reviews (poster, reviewOf, anonymous, content, stars, coopId)
        VALUES (%s, %s, %s, %s, %s, %s)
    """
    cursor = db.get_db().cursor()

    cursor.execute(query, (poster, company_id, anonymous, content, stars, coop_id))
    db.get_db().commit()
    
    response = make_response("Successfully posted review!")
    response.status_code = 200
    return response


