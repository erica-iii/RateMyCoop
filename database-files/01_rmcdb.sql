
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

-- creating a system updates table
DROP TABLE IF EXISTS system_updates;
CREATE TABLE system_updates (
    updateId int AUTO_INCREMENT NOT NULL,
    details text NOT NULL,
    postDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedBy int,
    PRIMARY KEY (updateId)
);

CREATE INDEX id on system_updates (updateId);


insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (1, 'Zechariah', 'Penchen', 'zpenchen0@over-blog.com', '793-544-2484', '$2a$04$72Zp1zlaeKU5NsvqTvDiyOm2WZgJJJD3f6WY.bm/RwiA4Zljn1uf6', 'lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis', 'zpenchen0', false);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (2, 'Ilysa', 'Graysmark', 'igraysmark1@icq.com', '934-202-8943', '$2a$04$uZR6D0aUYHRh8KxfcZ.qYu7txQU1J6rMf.9dJscabKNTHCXZ7VAaO', 'nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel', 'igraysmark1', true);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (3, 'Trev', 'Evett', 'tevett2@shop-pro.jp', '348-507-6701', '$2a$04$MvntNWlbuiMfVEmb/nGr1OLfB.KVjDqdJ2MUtzf0IOhwJy7d68262', 'posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend', 'tevett2', false);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (4, 'Jessica', 'Iredell', 'jiredell3@mac.com', '761-185-0875', '$2a$04$2ABhbivRv0yAw4CyVZt/M.kV2OCcb.L8WQnZOWZhBN7Lj6sMkzSsa', 'nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in', 'jiredell3', false);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (5, 'Madeline', 'Bethell', 'mbethell4@squidoo.com', '572-871-5381', '$2a$04$hEpK5SSS2EniBevtEJTQMO//sU..AfI7IBGmnkCjL0aA40U79k.Wy', 'et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut', 'mbethell4', true);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (6, 'Jaymee', 'Bonnick', 'jbonnick5@lycos.com', '227-593-6890', '$2a$04$747/GC.jPz0XmhQUe/hGFOYqjv53eOY6eVIP6jaQp2zTOcAeFb6Pm', 'potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas', 'jbonnick5', true);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (7, 'Gordon', 'Kupec', 'gkupec6@skype.com', '134-256-3685', '$2a$04$.M12bIYfzCaJSLMJTrItae1cFUFsvXjY/moux.HCauWa9udCprDMe', 'diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam', 'gkupec6', false);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (8, 'Georgette', 'Yonge', 'gyonge7@slideshare.net', '155-708-1496', '$2a$04$PctvlAd60yWiLKV1qGon/uIUlR.QHS88XWGqCl1TOzKP0YMOrzV36', 'montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa', 'gyonge7', true);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (9, 'Symon', 'Blaszczak', 'sblaszczak8@si.edu', '308-262-9464', '$2a$04$LixR9UULImwAU/FIwp2DBu0o5dcTxNZVWSl2Xd20LCXZIjymPf8b6', 'primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor', 'sblaszczak8', true);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (10, 'Innis', 'Stratten', 'istratten9@aol.com', '975-282-3329', '$2a$04$6uAcr5uxDc1kgt/RXj7BS.86CmMnQXcpzJqrJdJ6ja/LVx2hIFLUG', 'sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in', 'istratten9', false);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (11, 'Ernest', 'Forker', 'eforkera@seesaa.net', '799-962-5488', '$2a$04$O.mPViEGvCJ9Z8NctIdI7utkitrzxRXKu0hFNQiquVaHfl0SmybfS', 'pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu', 'eforkera', false);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (12, 'Rhody', 'Thireau', 'rthireaub@ebay.com', '770-361-2764', '$2a$04$UZT7A0QotsKHE/jnWeDC5OpGnOP1qrTV6RGP2ZgIpzlwcvzuu7r5e', 'ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices', 'rthireaub', false);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (13, 'Sven', 'McElhinney', 'smcelhinneyc@bbb.org', '788-973-3305', '$2a$04$rkOg.xKTMTIMjZeCXdEH3ec/rgyR6LbQMGakck5B3qPnVaEC6mkt6', 'vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in', 'smcelhinneyc', true);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (14, 'Ursuline', 'Strike', 'ustriked@ed.gov', '948-612-9452', '$2a$04$79M9xDJRi8X7B/eROn0vleGjnK8ZCLBqksPoz8ed3Cxmugna2KHH2', 'consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla', 'ustriked', true);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (15, 'Pace', 'Abramchik', 'pabramchike@virginia.edu', '721-543-7872', '$2a$04$GnK57iaGO511VxdPu/uZGeqUx5VJiZhsq3ST/weqRNLxzYCA0s01e', 'purus phasellus in felis donec semper sapien a libero nam dui', 'pabramchike', false);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (16, 'Mira', 'Gartsyde', 'mgartsydef@php.net', '369-807-1752', '$2a$04$L9riz5PmXGSJP8i4i6./5u7zE89rNvw.gAjbd/ep1wNn4h8K.W13e', 'dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi', 'mgartsydef', false);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (17, 'Ram', 'Levesque', 'rlevesqueg@scribd.com', '247-264-9671', '$2a$04$xaTER90/UVHvEE0KhqNYL.ZqVtp4OMJRmELQ7sgxr/zFCdKsilZCO', 'justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra', 'rlevesqueg', true);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (18, 'Liv', 'de Guerre', 'ldeguerreh@technorati.com', '321-423-1144', '$2a$04$6YiV9KEZTUEB2TII4FrFw.8Jeh.hNVsHuarZqLXep09f/t08dZL9C', 'mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac', 'ldeguerreh', true);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (19, 'Orv', 'Geldart', 'ogeldarti@about.com', '187-778-9261', '$2a$04$ya6pEfbkRDfjQGDc3vp7..C2YqyN1saRdVKUq.26I3sThChWbllUu', 'ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque', 'ogeldarti', true);
insert into advisors (advisorId, firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values (20, 'Nessy', 'Sebyer', 'nsebyerj@abc.net.au', '496-101-3429', '$2a$04$R9Up28pTvkWZDFsHBcg0D.QwRd6xYqVZR3xFEHxVZWtxpBDrx6koW', 'libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet', 'nsebyerj', true);


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
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Sheelah', 'Engall', 'sengall0@chron.com', '470-342-5853', '$2a$04$l.aXXk3NP0V.aRzFvYDEaOYEF6X3ldoB28SLA05qO7mHVNZYbRGpK', '#2d4', 'at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel', 'sengall0', true, true, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Eleanore', 'Canizares', 'ecanizares1@mail.ru', '407-450-9091', '$2a$04$cxze2CSknCkH/KLpf6f6KeE3MJMFGZ/srUOdR98VsmRznAvxmPufO', '#b50', 'at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi', 'ecanizares1', true, true, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Clerc', 'Minchell', 'cminchell2@cocolog-nifty.com', '537-838-9541', '$2a$04$CVdVpwONP.eG8/pi8YhUre0gItJJ8hJF/mR6OQ0qJmwGezByMJgWa', '#ba2', 'lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer', 'cminchell2', false, false, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Panchito', 'Hundal', 'phundal3@ted.com', '150-943-6076', '$2a$04$aVSNxcc6PhrXv0vcb.auju7IQNMAmp/zSw18Zllk.CRQsj/x8Gbd2', '#a4e', 'pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst', 'phundal3', true, true, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Dare', 'Proby', 'dproby4@dyndns.org', '800-194-5895', '$2a$04$B07lGPnZ1DAxWSuI8JedVu22G7zsZBNw0SdG5XTgCsFvgDmoutNYu', '#9d3', 'ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at', 'dproby4', false, true, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Molli', 'Dyett', 'mdyett5@1688.com', '199-675-2792', '$2a$04$Z90lhbgYZeTtz/ots0ughex9Q88qAK6oTv0LCxg2.pXVfFyQkzbKi', '#f66', 'praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat', 'mdyett5', true, false, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Bobette', 'Binstead', 'bbinstead6@army.mil', '347-697-9323', '$2a$04$SXcohYCAvH0MCTSGcwxq4ui4nz/aEGI5rR78rsImn6N7r0Jngir.K', '#ad2', 'enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id', 'bbinstead6', false, true, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Grissel', 'Tillerton', 'gtillerton7@ucoz.ru', '655-694-6198', '$2a$04$FMvT.nMkUp4Nu1D9hgy8L.HuhC.F5gq7XZYQmXz98S9HkYgrx.Gnq', '#dfa', 'donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio', 'gtillerton7', true, true, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Gerda', 'McVitty', 'gmcvitty8@hibu.com', '566-562-6920', '$2a$04$OWhHv8G7KvA/lz8LYKNsxOY20TrAs43/LVFcmy.ZKGeZcSvm5Fk4a', '#870', 'interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis', 'gmcvitty8', true, true, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Jessica', 'Mullaly', 'jmullaly9@quantcast.com', '418-261-7264', '$2a$04$teDjpWciBCZJ4FaKlUN1n.ab/3AnM4Eyg0ov3M5z34sehGopKtD5q', '#a71', 'cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec', 'jmullaly9', false, true, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Carolus', 'Pionter', 'cpiontera@ask.com', '602-792-2144', '$2a$04$t2LuhWwsRZClriYvmZFVM.9kb/35Avf0N1OA20bFgFory84XfJJbu', '#a3e', 'donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum', 'cpiontera', false, true, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Costanza', 'Fleis', 'cfleisb@scribd.com', '346-429-1204', '$2a$04$nqWTIHunBw5TJDafIjdIzOlY4CTh8PlgwjYQ5aU/N0pD05YDRHTxS', '#520', 'aliquam sit amet diam in magna bibendum imperdiet nullam orci pede', 'cfleisb', true, false, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Anette', 'Donnell', 'adonnellc@forbes.com', '625-769-4669', '$2a$04$nP56EE42WVuTtdmh44vwrujlYojFCpy5MIDCH55Cd0fAzjBrH4FBO', '#3b6', 'nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse', 'adonnellc', false, true, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Maggee', 'Scritch', 'mscritchd@rediff.com', '942-259-8979', '$2a$04$uLM5szwl11jsN2HZQXsIpe8uo1qSm1YpPcbIXfBfevBahL9buXNpy', '#c44', 'congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget', 'mscritchd', true, true, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Cyrill', 'Casol', 'ccasole@nhs.uk', '786-984-7830', '$2a$04$e2peA/IssqQIFeg.CoSdm.G/bPxf6qYuL9l9LCl0ye047B8qw.1km', '#eeb', 'augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit', 'ccasole', false, true, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Ranee', 'Lovstrom', 'rlovstromf@google.it', '997-162-8408', '$2a$04$FfXdIdxzU4gyOXUf4Vzku.tHzAewSMCnHhrkT85TZYx//wkblF3q2', '#1f5', 'magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel', 'rlovstromf', true, false, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Zarla', 'Wale', 'zwaleg@fastcompany.com', '163-836-0666', '$2a$04$/8NgmlDzm9BcZL/lymxnOeoNn/ofCNr76T2X9nDL/dKsT63qqr276', '#226', 'vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in', 'zwaleg', false, false, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Darlene', 'Ryan', 'dryanh@de.vu', '317-818-5987', '$2a$04$o6nX22Z674CPe.zWTmDHguX3NZUXsRitjqcdK0yY14B/jl1wkp9HK', '#b1d', 'consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam', 'dryanh', false, true, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Nate', 'Thornthwaite', 'nthornthwaitei@fastcompany.com', '669-245-6085', '$2a$04$rdvrZFnLnL2VuSHd8FexweFiprYgeO1GcN81mWYh.BNcanmAWmt9K', '#a5f', 'sed augue aliquam erat volutpat in congue etiam justo etiam pretium', 'nthornthwaitei', true, true, null);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Corinne', 'Hanburry', 'chanburryj@networkadvertising.org', '338-973-5038', '$2a$04$UBOE9CV7OA3N2EsXeaC5bu5liEYNikUtI3LiMuRdtbeWyD6F4YF3y', '#57d', 'erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus', 'chanburryj', true, true, null);

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








