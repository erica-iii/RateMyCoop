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

@students.route('/students/new_review', methods=['POST'])
def add_review():
    data = request.json

    poster = data.get('poster')
    company_name = data.get('review_of')
    content = data.get('content')
    stars = data.get('stars')
    job_title = data.get('coop')
    anonymous = data.get('anonymous')

    cursor = db.get_db().cursor()

    cursor.execute("SELECT companyId FROM companies WHERE companyName = %s", (company_name,))
    company = cursor.fetchone()

    if not company:
        cursor.execute("INSERT INTO companies (companyName, activityStatus) VALUES (%s, %s)", (company_name, 1))
        db.get_db().commit()
        cursor.execute("SELECT companyId FROM companies WHERE companyName = %s", (company_name,))
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
    
    return jsonify({"message": "Review successfully submitted"}), 201


