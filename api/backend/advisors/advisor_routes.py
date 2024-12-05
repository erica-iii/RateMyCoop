# blueprint for advisors

from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

advisors = Blueprint('advisors', __name__)

@advisors.route('/advisors/industries')
def get_industries():
    # Non-accessible route to get all currently available industries
    cursor = db.get_db().cursor()
    cursor.execute('''SELECT DISTINCT industry FROM coops;''')

    theData = cursor.fetchall()
    theResponse = make_response(jsonify(theData))
    theResponse.status_code = 200
    return theResponse

@advisors.route('/advisors/companies', methods=['GET'])
def get_companies():
    # Non-accessible route to get all currently listed companies
    cursor = db.get_db().cursor()
    cursor.execute(''' SELECT DISTINCT companyName FROM companies;''')

    theData = cursor.fetchall()
    theResponse = make_response(jsonify(theData))
    theResponse.status_code = 200

    return theResponse

@advisors.route('/advisors/coop_search', methods=['GET'])
def search_coops():
    # Search co-ops
    industry = request.args.get('industry', default='', type=str)
    pay = request.args.get('hourlyRate', default=0, type=float)

    cursor = db.get_db().cursor()
    cursor.execute('''
                   SELECT companyName, hourlyRate, industry, jobTitle, location, summary 
                   FROM coops
                   JOIN companies
                   ON coops.company = companies.companyId 
                   WHERE industry = %s AND hourlyRate > %s ''', (industry, pay))
    
    theData = cursor.fetchall()
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200

    return the_response

@advisors.route('/advisors/companies/<company_name>/<coop_name>', methods=['GET'])
def get_company_info(company_name, coop_name):
    # Get all information about a company's co-op
    cursor = db.get_db().cursor()
    cursor.execute(''' 
            SELECT companyName, jobTitle, industry, location, content, stars, likes, createdAt,
           CASE
               WHEN anonymous = FALSE THEN username
            END AS username
            FROM reviews r
                JOIN coops c ON r.coopId = c.coopId
                JOIN companies co ON r.reviewOf = co.companyId
                JOIN students s ON r.poster = s.studentId
            WHERE companyName = %s AND jobTitle = %s; ''', (company_name, coop_name))
    
    theData = cursor.fetchall()
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    
    return the_response

@advisors.route('/advisors/<job_title>', methods=['GET'])
def get_job_demographics(job_title):
    # Get application statistics of job title
    cursor = db.get_db().cursor()
    cursor.execute(''' 
            SELECT ROUND(AVG(gpa), 2) AS avgGpa, ROUND(AVG(numCoop), 2) AS avgNumCoop,
            ROUND(AVG(numClubs), 2) AS avgNumClubs, ROUND(AVG(numLeadership), 2) AS avgLeadership, jobTitle, companyName
            FROM reviews r
                JOIN coops c ON r.coopId = c.coopId
                JOIN companies co ON r.reviewOf = co.companyId
                JOIN students s ON r.poster = s.studentId
                JOIN student_stats ss ON s.studentId = ss.studentId
            WHERE statSharing != 0 AND jobTitle = %s
            GROUP BY jobTitle, companyName; ''', (job_title))

    theData = cursor.fetchall()
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    
    return the_response

@advisors.route('/advisors/demographic_search', methods=['GET'])
def job_demographic_search():
    # Search jobs by application statistics
    avg_GPA = request.args.get('avg_GPA', default=0.0, type=float)
    avg_leadership = request.args.get('avg_leadership', default=0.0, type=float)

    cursor = db.get_db().cursor()
    cursor.execute(''' 
        SELECT * FROM (SELECT ROUND(AVG(gpa), 2) AS avgGpa, ROUND(AVG(numCoop), 2) AS avgNumCoop,
            ROUND(AVG(numClubs), 2) AS avgNumClubs, ROUND(AVG(numLeadership), 2) AS avgLeadership, jobTitle, companyName
        FROM reviews r
            JOIN coops c ON r.coopId = c.coopId
            JOIN companies co ON r.reviewOf = co.companyId
            JOIN students s ON r.poster = s.studentId
            JOIN student_stats ss ON s.studentId = ss.studentId
        WHERE statSharing != 0
        GROUP BY jobTitle, companyName) AS meta
        WHERE avgGpa > %s AND avgLeadership > %s; ''', (avg_GPA, avg_leadership))

    theData = cursor.fetchall()
    theResponse = make_response(jsonify(theData))
    theResponse.status_code = 200
    return theResponse

@advisors.route('/advisors/companies/<company_name>')
def get_company_statistics(company_name):
    # Gets relevant statistics for Company in question
    cursor = db.get_db().cursor()
    cursor.execute('''
                   SELECT companyName, ROUND(AVG(avgRating), 2) AS avgCoopRating, ROUND(AVG(avgHourlyRate), 2) AS avgCoopPay FROM
                        (SELECT companyName, ROUND(AVG(stars), 2) AS avgRating, ROUND(AVG(hourlyRate), 2) AS avgHourlyRate
                        FROM companies co
                            JOIN coops c on co.companyId = c.company
                            JOIN reviews r on c.coopId = r.coopId
                        WHERE companyName = %s
                        GROUP BY jobTitle) AS meta
                    GROUP BY companyName;''', (company_name))
    
    theData = cursor.fetchall()
    theResponse = make_response(jsonify(theData))
    theResponse.status_code = 200
    return theResponse

@advisors.route('/advisors/company_search', methods=['GET'])
def search_companies():
    # Search companies by rating and pay
    avgCoopRating = request.args.get('avgCoopRating', default=0.0, type=float)
    avgCoopPay = request.args.get('avgCoopPay', default=0.0, type=float)

    cursor = db.get_db().cursor()
    cursor.execute('''
                   SELECT *
                FROM (
                    SELECT
                        companyName,
                        ROUND(AVG(avgRating), 2) AS avgCoopRating,
                        ROUND(AVG(avgHourlyRate), 2) AS avgCoopPay
                    FROM (
                        SELECT
                            companyName,
                            ROUND(AVG(stars), 2) AS avgRating,
                            ROUND(AVG(hourlyRate), 2) AS avgHourlyRate
                        FROM companies co
                        JOIN coops c ON co.companyId = c.company
                        JOIN reviews r ON c.coopId = r.coopId
                        GROUP BY companyName, jobTitle
                    ) AS meta
                    GROUP BY companyName
                ) AS meta2
                WHERE avgCoopRating > %s AND avgCoopPay > %s;''', (avgCoopRating, avgCoopPay))

    theData = cursor.fetchall()
    theResponse = make_response(jsonify(theData))
    theResponse.status_code = 200
    return theResponse


