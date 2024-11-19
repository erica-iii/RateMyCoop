
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
    passwordHash varchar(128) NOT NULL,
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
    details text,
    resolveStatus bool DEFAULT 0,
    PRIMARY KEY (requestId)
);

CREATE INDEX id ON requests (requestId);

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
INSERT INTO reviews (poster, reviewOf, content, stars, coopId, likes)
VALUES
(1, 1, 'Great work environment and team', 5, 1, 10),
(2, 2, 'Good experience but could improve communication', 3, 2, 5),
(3, 3, 'Excellent mentoring and project opportunities', 5, 3, 12);

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

# CRUD Statements for Persona 1
    # user story 1
    # user story 2
    # user story 3
    # user story 4
    # user story 5
    # user story 6

# CRUD Statements for Persona 2
    # user story 1
    # user story 2
    # user story 3
    # user story 4
    # user story 5
    # user story 6

# CRUD Statements for Persona 3
    # user story 1
    # user story 2
    # user story 3
    # user story 4
    # user story 5
    # user story 6

# CRUD Statements for Persona 4
    # user story 1
    # user story 2
    # user story 3
    # user story 4
    # user story 5
    # user story 6