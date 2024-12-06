from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

employers = Blueprint('employers', __name__)

from flask import Blueprint, request, jsonify, make_response, current_app
from backend.db_connection import db

employers = Blueprint('employers', __name__)

@employers.route('/e/job_listings', methods=['GET'])
def get_job_listings():
    cursor = db.get_db().cursor()
    cursor.execute("SELECT * FROM job_listings")
    
    theData = cursor.fetchall()
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

@employers.route('/e/update_job/<int:job_id>', methods=['PUT'])
def update_job(job_id):
    job_data = request.json
    current_app.logger.info(job_data)

    title = job_data.get('title')
    description = job_data.get('description')
    salary = job_data.get('salary')
    
    query = """
        UPDATE job_listings 
        SET title = %s, description = %s, salary = %s 
        WHERE jobId = %s
    """
    cursor = db.get_db().cursor()
    cursor.execute(query, (title, description, salary, job_id))
    db.get_db().commit()
    
    return make_response("Job listing updated!", 200)

@employers.route('/e/demographics/<int:company_id>', methods=['GET'])
def get_demographics(company_id):
    query = """
        SELECT 
            gender, COUNT(*) as count 
        FROM 
            applications
        WHERE 
            companyId = %s
        GROUP BY 
            gender
    """
    cursor = db.get_db().cursor()
    cursor.execute(query, (company_id,))
    
    theData = cursor.fetchall()
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

@employers.route('/e/post_job', methods=['POST'])
# posts a review to database
def post_job():

    # collecting the data
    the_data = request.json
    current_app.logger.info(the_data)

    company = the_data['company']
    job_title = the_data['job_title']
    content = the_data['content']
    location = the_data['location']
    industry = the_data['industry']
    salary = the_data['salary']
    
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
    response.status_code = 200
    return response

@employers.route('/e/delete_job/<int:job_id>', methods=['DELETE'])
def delete_job(job_id):
    cursor = db.get_db().cursor()
    
    cursor.execute("DELETE FROM job_listings WHERE jobId = %s", (job_id,))
    db.get_db().commit()
    
    return make_response("Job listing deleted!", 200)

@employers.route('/e/company_reviews/<int:company_id>', methods=['GET'])
def get_reviews(company_id):
    query = """
        SELECT reviewerName, rating, content, createdAt
        FROM reviews
        WHERE companyId = %s
    """
    cursor = db.get_db().cursor()
    cursor.execute(query, (company_id,))
    reviews = cursor.fetchall()
    
    # If no reviews are found, return a message
    if not reviews:
        return make_response(jsonify({"message": "No reviews found for this company."}), 404)
    
    # If reviews are found, return them in the response
    response = make_response(jsonify(reviews))
    response.status_code = 200
    return response

@employers.route('/e/company_name/<int:company_id>', methods=['GET'])
def get_company_name(company_id):
    query = "SELECT companyName FROM employers WHERE companyId = %s"
    cursor = db.get_db().cursor()
    cursor.execute(query, (company_id,))
    company_name = cursor.fetchone()
    
    if not company_name:
        return make_response(jsonify({"message": "Company not found"}), 404)
    
    response = make_response(jsonify({"company_name": company_name[0]}))
    response.status_code = 200
    return response
