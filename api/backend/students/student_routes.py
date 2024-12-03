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
            r.reviewId,
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

@students.route('/students/poster_name/<int:review_id>', methods=['GET'])
def get_poster(review_id):
    query = """
        SELECT 
            CASE 
                WHEN r.anonymous = 0 THEN s.firstName
                ELSE 'Anonymous' 
            END AS posterName
        FROM 
            reviews r
        LEFT JOIN 
            students s ON r.poster = s.studentId
        WHERE 
            r.reviewId = %s
    """

    cursor = db.get_db().cursor()
    cursor.execute(query, (review_id,))
    theData = cursor.fetchone()

    if theData:
        return jsonify({'posterName': theData['posterName']}), 200
    else:
        return jsonify({'error': 'Review not found'}), 404


@students.route('/students/student_reviews/<student_id>', methods=['GET'])
def get_student_reviews(student_id):
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
        WHERE
            poster = %s
    '''

    cursor = db.get_db().cursor()
    cursor.execute(query, (student_id,))

    theData = cursor.fetchall()
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200

    return the_response

@students.route('/students/post_review', methods=['POST'])
def post_review():

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
    response.status_code = 200
    return response

@students.route('/students/delete_review/<int:review_id>', methods=['DELETE'])
def delete_review(review_id):
    cursor = db.get_db().cursor()
    
    cursor.execute("DELETE FROM reviews WHERE reviewId = %s", (review_id,)) 
    db.get_db().commit()
    
    return "Review deleted"
    
@students.route('/students/like_review/<int:review_id>', methods=['PUT'])
def like_review(review_id):
    cursor = db.get_db().cursor()
    
    # update the like count
    query = """
        UPDATE reviews
        SET likes = likes + 1
        WHERE reviewId = %s
    """
    cursor.execute(query, (review_id,))
    
    # check if row was updated
    if cursor.rowcount == 0:
        return make_response(jsonify({'error': 'Review not found'}), 404)
    
    db.get_db().commit()
    
    response = make_response(jsonify({'message': 'Like count updated successfully'}), 200)
    return response





