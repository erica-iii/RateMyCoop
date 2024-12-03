
-- setting up database
DROP DATABASE IF EXISTS `rmcdb`;
CREATE DATABASE IF NOT EXISTS `rmcdb`;
USE `rmcdb`;

-- creating advisors table
DROP TABLE IF EXISTS advisors;
CREATE TABLE advisors (
    advisorId int AUTO_INCREMENT NOT NULL,
    firstName varchar(50),
    lastName varchar(50),
    email varchar(100),
    phone varchar(50),
    passwordHash varchar(128) NOT NULL,
    registeredAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    lastLogin datetime,
    intro tinytext,
    profile text,
    username varchar(30) NOT NULL UNIQUE,
    activityStatus bool DEFAULT 1,
    PRIMARY KEY (advisorId)
);

CREATE INDEX id ON advisors (advisorId);
CREATE INDEX email ON advisors (email);
CREATE INDEX phone ON advisors (phone);
CREATE INDEX uname ON advisors (username);


-- creating students table
DROP TABLE IF EXISTS students;
CREATE TABLE students (
    studentId int AUTO_INCREMENT NOT NULL,
    firstName varchar(50),
    lastName varchar(50),
    email varchar(100),
    phone varchar(50),
    passwordHash varchar(128) NOT NULL,
    registeredAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    lastLogin datetime,
    intro tinytext,
    profile text,
    username varchar(30) NOT NULL UNIQUE,
    activityStatus bool DEFAULT 1,
    statSharing bool DEFAULT 1,
    advisor int,
    PRIMARY KEY (studentId),
    CONSTRAINT fk_s FOREIGN KEY (advisor) REFERENCES advisors (advisorId)
);

CREATE INDEX id ON students (studentId);
CREATE INDEX email ON students (email);
CREATE INDEX phone ON students (phone);
CREATE INDEX uname ON students (username);

-- creating student_stats table
DROP TABLE IF EXISTS student_stats;
CREATE TABLE student_stats (
    studentId int NOT NULL,
    resume text,
    gpa float,
    gender varchar(50),
    ethnicity varchar(50),
    major varchar(50),
    numCoop int,
    numClubs int,
    numLeadership int,
    PRIMARY KEY (studentId),
    CONSTRAINT fk_s_stat FOREIGN KEY (studentId) REFERENCES students (studentId) ON UPDATE cascade ON DELETE restrict
);

CREATE INDEX id ON student_stats (studentId);

-- creating companies table
DROP TABLE IF EXISTS companies;
CREATE TABLE companies (
    companyId int AUTO_INCREMENT NOT NULL,
    companyName varchar(100),
    repEmail varchar(100),
    repPhone varchar(50),
    website varchar(50),
    passwordHash varchar(128) NOT NULL DEFAULT 'temp_password',
    registeredAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    lastLogin datetime,
    intro tinytext,
    profile text,
    activityStatus bool DEFAULT 1,
    PRIMARY KEY (companyId)
);

CREATE INDEX id ON companies (companyId);
CREATE INDEX email ON companies (repEmail);
CREATE INDEX phone ON companies (repPhone);

-- creating worked_at table
DROP TABLE IF EXISTS worked_at;
CREATE TABLE worked_at (
    studentId int NOT NULL,
    companyId int NOT NULL,
    PRIMARY KEY (studentId, companyId),
    CONSTRAINT fk_worked1 FOREIGN KEY (studentId) REFERENCES students (studentId) ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_worked2 FOREIGN KEY (companyId) REFERENCES companies (companyId) ON UPDATE cascade ON DELETE restrict
);

CREATE INDEX cid ON worked_at (companyId);
CREATE INDEX sid ON worked_at (studentId);

-- creating coops table
DROP TABLE IF EXISTS coops;
CREATE TABLE coops (
    coopId     int AUTO_INCREMENT NOT NULL,
    jobTitle   varchar(100),
    hourlyRate decimal(4, 2),
    location   varchar(100),
    industry   varchar(100),
    summary    text,
    company    int,
    PRIMARY KEY (coopId),
    CONSTRAINT fk_coop FOREIGN KEY (company) REFERENCES companies (companyId) ON UPDATE cascade ON DELETE cascade
);

CREATE INDEX id ON coops (coopId);

-- creating reviews table
DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
    reviewId int AUTO_INCREMENT NOT NULL,
    poster int NOT NULL,
    reviewOf int NOT NULL,
    anonymous tinyint NOT NULL,
    content text NOT NULL,
    stars int NOT NULL,
    coopId int NOT NULL,
    likes int,
    createdAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedAt datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    publishedAt datetime,
    PRIMARY KEY (reviewId),
    CONSTRAINT fk_rd1 FOREIGN KEY (poster) REFERENCES students (studentId) ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT fk_rd2 FOREIGN KEY (reviewOf) REFERENCES companies (companyId) ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT fk_rd3 FOREIGN KEY (coopId) REFERENCES coops (coopId) ON UPDATE cascade ON DELETE cascade
);

CREATE INDEX id ON reviews (reviewId);

-- creating comments table
DROP TABLE IF EXISTS comments;
CREATE TABLE comments (
    commentID int AUTO_INCREMENT NOT NULL,
    reviewId int NOT NULL,
    content text NOT NULL,
    poster int NOT NULL,
    PRIMARY KEY (commentID),
    CONSTRAINT fk_com FOREIGN KEY (poster) REFERENCES students (studentId) ON UPDATE cascade ON DELETE cascade
);

CREATE INDEX id ON comments (commentId);


-- creating advisors table
DROP TABLE IF EXISTS system_admins;
CREATE TABLE system_admins(
    adminId int AUTO_INCREMENT NOT NULL,
    firstName varchar(50),
    lastName varchar(50),
    email varchar(100),
    phone varchar(50),
    passwordHash varchar(128) NOT NULL,
    registeredAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedAt datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    lastLogin datetime,
    username varchar(30) NOT NULL UNIQUE,
    PRIMARY KEY (adminId)
);

CREATE INDEX id ON system_admins (adminId);

-- creating requests table
DROP TABLE IF EXISTS requests;
CREATE TABLE requests (
    requestId int AUTO_INCREMENT NOT NULL,
    details text NOT NULL,
    resolveStatus bool DEFAULT 0,
    companyId int,
    studentId int,
    PRIMARY KEY (requestId),
    CONSTRAINT fk_1 FOREIGN KEY (companyId) REFERENCES companies (companyId) ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT fk_2 FOREIGN KEY (studentId) REFERENCES students (studentId) ON UPDATE cascade ON DELETE cascade
);

CREATE INDEX id ON requests (requestId);

--creating a system updates table
DROP TABLE IF EXISTS system_updates;
CREATE TABLE system_updates (
    updateId int AUTO_INCREMENT NOT NULL,
    details text NOT NULL,
    postDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedBy int,
    PRIMARY KEY (updateId),
    CONSTRAINT fk_su1 FOREIGN KEY (updatedBy) REFERENCES system_admins (adminId) ON UPDATE cascase ON DELETE cascade
);

CREATE INDEX id on system_updates (updateId);

-- Sample data for each table
INSERT INTO advisors (firstName, lastName, email, phone, passwordHash, username, activityStatus)
VALUES
('John', 'Doe', 'john.doe@email.com', '555-0101', 'hashed_password_1', 'johndoe', 1),
('Jane', 'Smith', 'jane.smith@email.com', '555-0102', 'hashed_password_2', 'janesmith', 1),
('Bill', 'Turner', 'bill.turner@email.com', '555-0103', 'hashed_password_3', 'billturner', 1);

-- Inserting sample data for students
INSERT INTO students (firstName, lastName, email, phone, passwordHash, username, advisor)
VALUES
('Alice', 'Johnson', 'alice.johnson@email.com', '555-0201', 'hashed_password_4', 'alicejohnson', 1),
('Bob', 'Williams', 'bob.williams@email.com', '555-0202', 'hashed_password_5', 'bobwilliams', 2),
('Charlie', 'Davis', 'charlie.davis@email.com', '555-0203', 'hashed_password_6', 'charliedavis', 3);

-- Inserting sample data for student_stats
INSERT INTO student_stats (studentId, resume, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership)
VALUES
(1, 'Resume for Alice', 3.8, 'Female', 'Caucasian', 'Computer Science', 2, 3, 1),
(2, 'Resume for Bob', 3.5, 'Male', 'Hispanic', 'Mechanical Engineering', 1, 4, 0),
(3, 'Resume for Charlie', 3.9, 'Male', 'African American', 'Electrical Engineering', 3, 2, 2);

-- Inserting sample data for companies
INSERT INTO companies (companyName, repEmail, repPhone, website, passwordHash, activityStatus)
VALUES
('TechCorp', 'contact@techcorp.com', '555-0301', 'www.techcorp.com', 'hashed_password_7', 1),
('MediPlus', 'contact@mediplus.com', '555-0302', 'www.mediplus.com', 'hashed_password_8', 1),
('Innovate Ltd', 'contact@innovateltd.com', '555-0303', 'www.innovateltd.com', 'hashed_password_9', 1);

-- Inserting sample data for worked_at
INSERT INTO worked_at (studentId, companyId)
VALUES
(1, 1),
(2, 2),
(3, 3);

-- Inserting sample data for coops
INSERT INTO coops (jobTitle, hourlyRate, location, industry, summary, company)
VALUES
('Software Developer', 25.00, 'San Francisco', 'Tech', 'Developed applications for clients', 1),
('Intern', 18.50, 'Los Angeles', 'Healthcare', 'Assisted with patient data management', 2),
('Electrical Engineer Intern', 22.00, 'Chicago', 'Engineering', 'Worked on product development', 3);

-- Inserting sample data for reviews
INSERT INTO reviews (poster, reviewOf,anonymous, content, stars, coopId, likes)
VALUES
(1, 1, 0, 'Great work environment and team', 5, 1, 10),
(2, 2, 0, 'Good experience but could improve communication', 3, 2, 5),
(3, 3, 0, 'Excellent mentoring and project opportunities', 5, 3, 12);

-- Inserting sample data for comments
INSERT INTO comments (reviewId, content, poster)
VALUES
(1, 'I agree, the team was fantastic!', 2),
(2, 'Communication was a bit slow, but still learned a lot', 1),
(3, 'The mentorship was amazing, learned so much', 2);

-- Inserting sample data for system_admins
INSERT INTO system_admins (firstName, lastName, email, phone, passwordHash, username)
VALUES
('Admin', 'User', 'admin@company.com', '555-0401', 'hashed_admin_password', 'adminuser');

-- Inserting sample data for requests
INSERT INTO requests (details, resolveStatus)
VALUES
('Request to update student GPA system', 0),
('Issue with company login process', 1),
('Request for new coop job posting template', 0);

-- Inserting sample data for system_updates
INSERT INTO system_updates (details, updatedBy)
VALUES
('System update to improve performance', 1),
('Security patch applied to fix vulnerabilities', 2),
('New feature added to the user interface', 1),
('Database migration to support new version', 2),
('Bug fix in payment gateway integration', 1);

# CRUD Statements for Persona 1
    # user story 1.1
    SELECT stars, content, likes, createdAt,
        CASE
            WHEN anonymous = FALSE THEN username
        END AS username
        FROM reviews r
            JOIN students s on r.poster = s.studentId
        ORDER BY r.createdAt;
    # user story 1.2
    SELECT ROUND(AVG(gpa), 2) AS avgGpa, ROUND(AVG(numCoop), 2) AS avgNumCoop,
           ROUND(AVG(numClubs), 2) AS avgNumClubs, ROUND(AVG(numLeadership), 2) AS avgLeadership, jobTitle, companyName
    FROM reviews r
        JOIN coops c ON r.coopId = c.coopId
        JOIN companies co ON r.reviewOf = co.companyId
        JOIN students s ON r.poster = s.studentId
        JOIN student_stats ss ON s.studentId = ss.studentId
    WHERE statSharing != 0 AND jobTitle = 'Software Developer' AND anonymous = FALSE
    GROUP BY jobTitle, companyName;
    # user story 1.3
    INSERT INTO reviews (poster, reviewOf,anonymous, content, stars, coopId, likes)
        VALUES (1, 1, 0,
                'Second Co-Op with them was even better!', 5, 1, 10);
    # user story 1.4
    UPDATE reviews
    SET content = 'Second Co-op with them was even better, shout out to TechCorp!'
    WHERE reviewId = 4;
    # user story 1.5
    DELETE FROM reviews WHERE reviewId = 4;
    # user story 1.6
    UPDATE students
    SET statSharing = 0
    WHERE studentId = 1;

# CRUD Statements for Persona 2
    # user story 2.1
    SELECT 
    s.studentId, 
    s.firstName, 
    s.lastName, 
    st.resume AS resume_link, 
    st.numLeadership AS leadership_roles, 
    st.numClubs AS club_memberships 
FROM 
    students s
JOIN student_stats st 
    ON s.studentId = st.studentId
JOIN worked_at w
    ON s.studentId = w.studentId
JOIN coops c 
    ON w.companyId = c.company
WHERE 
    c.jobTitle = 'Software Developer'
    AND st.gpa > 3.5
ORDER BY 
    st.gpa DESC;

    # user story 2.2
SELECT 
    r.content AS review_content,
    r.stars,
    r.createdAt AS review_date, 
    CASE 
        WHEN r.anonymous = TRUE THEN 'Anonymous'
        ELSE s.firstName || ' ' || s.lastName 
    END AS reviewer_name
FROM 
    reviews AS r
JOIN students AS s 
    ON r.poster = s.studentId
WHERE 
    r.reviewOf = 1
ORDER BY 
    r.createdAt DESC;

    # user story 2.3
SELECT 
    c.jobTitle, 
    COUNT(DISTINCT r.reviewId) AS total_reviews, 
    AVG(r.stars) AS avg_rating,
    AVG(st.numLeadership) AS avg_leadership_roles, 
    AVG(st.numClubs) AS avg_club_memberships
FROM 
    coops AS c
LEFT JOIN reviews AS r 
    ON c.coopId = r.coopId
LEFT JOIN students AS s
    ON r.poster = s.studentId
LEFT JOIN student_stats AS st 
    ON s.studentId = st.studentId
WHERE 
    c.company = 1
GROUP BY 
    c.jobTitle
ORDER BY 
    avg_rating DESC;

    # user story 2.4

UPDATE 
    coops
SET 
    jobTitle = 'Patient Care Technician', 
    hourlyRate = 22.50, 
    industry = 'Healthcare', 
    summary = 'Provide patient care by monitoring vital signs, assisting with daily activities, and supporting the healthcare team.'
WHERE 
    coopId = 123;
    # user story 2.5
SELECT 
    st.gender, 
    st.ethnicity
FROM 
    students AS s
JOIN student_stats AS st 
    ON s.studentId = st.studentId
JOIN worked_at w
    ON s.studentId = w.studentId
WHERE 
    w.companyId = 1
GROUP BY 
    st.gender, 
    st.ethnicity;
        
    # user story 2.6
SELECT 
    c.companyName, 
    r.stars,
    r.content,
    r.createdAt AS review_date
FROM 
    reviews AS r
JOIN companies AS c 
    ON r.reviewOf = c.companyId
WHERE 
    r.reviewOf IN (1, 2, 3)
ORDER BY 
    r.createdAt DESC;

        
# CRUD Statements for Persona 3
    # user story 3.1
SELECT 
    r.reviewId, 
    r.content AS feedback_content,
    r.createdAt AS submitted_date, 
    s.firstName || ' ' || s.lastName AS student_name, 
    c.jobTitle AS job_title, 
    cmp.companyName AS company_name
FROM 
    reviews AS r
JOIN students AS s 
    ON r.poster = s.studentId
JOIN coops AS c 
    ON r.coopId = c.coopId
JOIN companies AS cmp 
    ON c.company = cmp.companyId
WHERE 
    r.content LIKE 'Great'
    OR r.content LIKE 'ugly';
    
    # user story 3.2

    SELECT 
    req.requestId, 
    req.details AS request_details, 
    req.resolveStatus,
    cmp.companyName,
    cmp.repEmail AS contact_email
FROM 
    requests AS req
JOIN companies AS cmp
    ON req.companyId = cmp.companyId
WHERE 
    req.resolveStatus = 'Pending'
ORDER BY
    req.requestId;

    # user story 3.3

SELECT 
    req.requestId, 
    req.details AS request_details, 
    req.resolveStatus, 
    s.firstName || ' ' || s.lastName AS student_name, 
    s.email AS contact_email
FROM 
    requests AS req
JOIN students AS s 
    ON req.studentId = s.studentId
WHERE 
    req.resolveStatus = 'Pending' 
ORDER BY 
    req.requestId;
    # user story 3.4
UPDATE students
SET 
    statSharing = 0
WHERE 
    studentId = 1;
        
    # user story 3.5
UPDATE student_stats
SET
    gpa = 4.0
WHERE studentId = 5;
    # user story 3.6
SELECT 
    'Student' AS user_type, 
    s.firstName || ' ' || s.lastName AS user_name, 
    s.lastLogin AS last_login 
FROM 
    students AS s
WHERE 
    s.activityStatus = 1 
UNION ALL
SELECT 
    'Employer' AS user_type, 
    cmp.repEmail AS user_name,
    cmp.lastLogin AS last_login
FROM 
    companies AS cmp
WHERE 
    cmp.activityStatus = 1
ORDER BY 
    last_login DESC;

# CRUD Statements for Persona 4
    # user story 4.1
    SELECT * FROM coops
        WHERE hourlyRate > 21 AND industry = 'Tech';
    # user story 4.2
    SELECT companyName, jobTitle, industry, location, content, stars, likes,publishedAt,
           CASE
               WHEN anonymous = FALSE THEN username
            END AS username
    FROM reviews r
        JOIN coops c ON r.coopId = c.coopId
        JOIN companies co ON r.reviewOf = co.companyId
        JOIN students s ON r.poster = s.studentId
    WHERE jobTitle = 'Software Developer' AND companyName = 'TechCorp';
    # user story 4.3
    SELECT ROUND(AVG(gpa), 2) AS avgGpa, ROUND(AVG(numCoop), 2) AS avgNumCoop,
           ROUND(AVG(numClubs), 2) AS avgNumClubs, ROUND(AVG(numLeadership), 2) AS avgLeadership, jobTitle, companyName
    FROM reviews r
        JOIN coops c ON r.coopId = c.coopId
        JOIN companies co ON r.reviewOf = co.companyId
        JOIN students s ON r.poster = s.studentId
        JOIN student_stats ss ON s.studentId = ss.studentId
    WHERE statSharing != 0 AND jobTitle = 'Software Developer'
    GROUP BY jobTitle, companyName;
    # user story 4.4
    SELECT * FROM (SELECT ROUND(AVG(gpa), 2) AS avgGpa, ROUND(AVG(numCoop), 2) AS avgNumCoop,
           ROUND(AVG(numClubs), 2) AS avgNumClubs, ROUND(AVG(numLeadership), 2) AS avgLeadership, jobTitle, companyName
    FROM reviews r
        JOIN coops c ON r.coopId = c.coopId
        JOIN companies co ON r.reviewOf = co.companyId
        JOIN students s ON r.poster = s.studentId
        JOIN student_stats ss ON s.studentId = ss.studentId
    WHERE statSharing != 0
    GROUP BY jobTitle, companyName) AS meta
    WHERE avgGpa > 3.8 AND avgLeadership > 1;
    # user story 4.5
    SELECT companyName, ROUND(AVG(avgRating), 2) AS avgCoopRating, ROUND(AVG(avgHourlyRate), 2) AS avgCoopPay FROM
        (SELECT companyName, ROUND(AVG(stars), 2) AS avgRating, ROUND(AVG(hourlyRate), 2) AS avgHourlyRate
           FROM companies co
               JOIN coops c on co.companyId = c.company
               JOIN reviews r on c.coopId = r.coopId
           WHERE companyName = 'TechCorp'
           GROUP BY jobTitle) AS meta
    GROUP BY companyName;
    # user story 4.6
    SELECT * FROM (SELECT companyName, ROUND(AVG(avgRating), 2) AS avgCoopRating, ROUND(AVG(avgHourlyRate), 2) AS avgCoopPay FROM
        (SELECT companyName, ROUND(AVG(stars), 2) AS avgRating, ROUND(AVG(hourlyRate), 2) AS avgHourlyRate
           FROM companies co
               JOIN coops c on co.companyId = c.company
               JOIN reviews r on c.coopId = r.coopId
           WHERE companyName = 'TechCorp'
           GROUP BY jobTitle) AS meta
    GROUP BY companyName) AS meta2
    WHERE avgCoopRating > 3 AND avgCoopPay > 23;









