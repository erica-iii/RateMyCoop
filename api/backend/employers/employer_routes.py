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

@employers.route('/employers/job_listings', methods=['GET'])
def get_job_listings():
    cursor = db.get_db().cursor()
    cursor.execute("SELECT * FROM job_listings")
    
    theData = cursor.fetchall()
    
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

@employers.route('/employers/update_job/<int:job_id>', methods=['PUT'])
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

@employers.route('/employers/demographics/<int:company_id>', methods=['GET'])
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

@employers.route('/employers/post_job', methods=['POST'])
def post_job():
    job_data = request.json
    current_app.logger.info(job_data)

    title = job_data.get('title')
    description = job_data.get('description')
    salary = job_data.get('salary')
    company_id = job_data.get('company_id')

    query = """
        INSERT INTO job_listings (title, description, salary, companyId)
        VALUES (%s, %s, %s, %s)
    """
    cursor = db.get_db().cursor()
    cursor.execute(query, (title, description, salary, company_id))
    db.get_db().commit()
    
    return make_response("Job listing created!", 201)

@employers.route('/employers/delete_job/<int:job_id>', methods=['DELETE'])
def delete_job(job_id):
    cursor = db.get_db().cursor()
    
    cursor.execute("DELETE FROM job_listings WHERE jobId = %s", (job_id,))
    db.get_db().commit()
    
    return make_response("Job listing deleted!", 200)

@employers.route('/employers/company_reviews/<int:company_id>', methods=['GET'])
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
