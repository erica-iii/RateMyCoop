# blueprint for students

from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db
from backend.ml_models.model01 import predict

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

@students.route('/students/comp_reviews/<company_id>', methods=['GET'])
def get_company_reviews(company_id):
    query = f'''
        SELECT 
            r.reviewid,
            r.content AS review_content,
            r.stars AS rating,
            r.anonymous,
            r.likes,
            r.createdAt,
        FROM 
            reviews r
        JOIN
            companies c ON r.reviewOf = c.companyId
        WHERE 
            c.companyId = {str(company_id)}
    '''

    cursor = db.get_db().cursor()
    cursor.execute(query)

    theData = cursor.fetchall()
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    
    return the_response
