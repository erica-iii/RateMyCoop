# blueprint for students

from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db
from backend.ml_models.model01 import predict

students = Blueprint('students', __name__)

@students.route('/companies', methods=['GET'])
def get_companies():

    cursor = db.get_db().cursor()
    cursor.execute('''SELECT companyName FROM companies
    ''')
    
    theData = cursor.fetchall()
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response