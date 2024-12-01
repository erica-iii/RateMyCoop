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
