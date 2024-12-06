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

@employers.route('/companies', methods=['GET'])
# gets all company names
def get_companies():

    cursor = db.get_db().cursor()
    cursor.execute('''SELECT companyName FROM companies
    ''')
    
    theData = cursor.fetchall()
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response


@employers.route('/company_analytics/<company_name>', methods=['GET'])
# gets analytics for a company
def get_company_analytics(company_name):
    cursor = db.get_db().cursor()

    # query to calculate averages for student stats
    stats_query = """
        SELECT 
            ROUND(AVG(ss.gpa), 2) AS avgGPA,
            ROUND(AVG(ss.numCoop), 0) AS avgNumCoop,
            ROUND(AVG(ss.numLeadership), 0) AS avgNumLeadership,
            ROUND(AVG(ss.numClubs), 0) AS avgNumClubs
        FROM 
            student_stats ss
        JOIN 
            worked_at wa ON ss.studentId = wa.studentId
        JOIN 
            companies c ON wa.companyId = c.companyId
        WHERE 
            c.companyName = %s
    """

    # query to get the top 3 most common majors
    majors_query = """
        SELECT 
            ss.major, COUNT(*) AS count
        FROM 
            student_stats ss
        JOIN 
            worked_at wa ON ss.studentId = wa.studentId
        JOIN 
            companies c ON wa.companyId = c.companyId
        WHERE 
            c.companyName = %s
        GROUP BY 
            ss.major
        ORDER BY 
            count DESC
        LIMIT 3
    """

    # execute the queries
    cursor.execute(stats_query, (company_name,))
    stats_result = cursor.fetchone()

    cursor.execute(majors_query, (company_name,))
    majors_result = cursor.fetchall()

    if not stats_result or all(value is None for value in stats_result.values()):
        return jsonify({'error': 'No data found for the specified company'}), 404

    # construct the response
    response_data = {
        'averages': {
            'average GPA': stats_result['avgGPA'],
            'average number of co-ops done': stats_result['avgNumCoop'],
            'average number of leadership roles': stats_result['avgNumLeadership'],
            'average number of clubs': stats_result['avgNumClubs']
        },
        'topMajors': [
            {'major': major['major'], 'count': major['count']} for major in majors_result
        ]
    }

    return jsonify(response_data), 200



@employers.route('/comp_reviews/<company_name>', methods=['GET'])
# gets all reviews for a specific company by name
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



@employers.route('/poster_name/<int:review_id>', methods=['GET'])
# gets the name of a review poster based on review id
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
    
   
@employers.route('/like_review/<int:review_id>', methods=['PUT'])
# updates like count on a review
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


@employers.route('/comments/<int:review_id>', methods=['GET'])
# gets all comments assosiated with a review
def get_comments_for_review(review_id):
    cursor = db.get_db().cursor()

    # SQL query to fetch all comments for the given reviewId
    query = """
        SELECT 
            c.commentID,
            c.content,
            c.poster,
            CONCAT(s.firstName, ' ', s.lastName) AS commenterName
        FROM 
            comments c
        LEFT JOIN 
            students s ON c.poster = s.studentId
        WHERE 
            c.reviewId = %s
        ORDER BY 
            c.commentID ASC
    """

    cursor.execute(query, (review_id,))
    comments = cursor.fetchall()

    if comments:
        return jsonify(comments), 200
    else:
        return jsonify({'message': 'No comments found for this review'}), 404