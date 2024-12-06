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

# get co-ops for the users company
@employers.route('/coops', methods=['GET'])
def get_job_listings():
    cursor = db.get_db().cursor()
    cursor.execute("SELECT * FROM coops WHERE company = 1")
    
    theData = cursor.fetchall()
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

@employers.route('/deleteCoop/<int:coop_d>', methods=['DELETE'])
def delete_reviews(coop_d):
    cursor = db.get_db().cursor()
    
    cursor.execute("DELETE FROM coops WHERE coopId = %s", (coop_d,)) 
    db.get_db().commit()
    
    return make_response("Co-op deleted", 200)

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
# posts a job to the database
def post_job():
    # Collecting the data
    the_data = request.json
    current_app.logger.info(f"Received data: {the_data}")

    company = the_data.get('company')
    job_title = the_data.get('job_title')
    content = the_data.get('content')
    location = the_data.get('location')
    industry = the_data.get('industry')
    salary = the_data.get('salary')

    # Validate the company ID
    cursor = db.get_db().cursor()
    cursor.execute("SELECT companyId FROM companies WHERE companyId = %s", (company,))
    company_data = cursor.fetchone()

    if not company_data:
        current_app.logger.error(f"Invalid company ID: {company}")
        return jsonify({'error': 'Company not found'}), 404

    # Insert the job into the coops table
    query = """
        INSERT INTO coops (jobTitle, hourlyRate, location, industry, summary, company)
        VALUES (%s, %s, %s, %s, %s, %s)
    """
    try:
        cursor.execute(query, (job_title, salary, location, industry, content, company))
        db.get_db().commit()
        response = make_response("Successfully posted job!")
        response.status_code = 200
        return response
    except Exception as e:
        current_app.logger.error(f"Error posting job: {e}")
        return jsonify({'error': 'Failed to post job'}), 500



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
