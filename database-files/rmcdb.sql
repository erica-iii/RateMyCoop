
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




-- Sample data for each table
INSERT INTO advisors (firstName, lastName, email, phone, passwordHash, username, activityStatus)
VALUES
('John', 'Doe', 'john.doe@email.com', '555-0101', 'hashed_password_1', 'johndoe', 1),
('Jane', 'Smith', 'jane.smith@email.com', '555-0102', 'hashed_password_2', 'janesmith', 1),
('Bill', 'Turner', 'bill.turner@email.com', '555-0103', 'hashed_password_3', 'billturner', 1);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Zechariah', 'Penchen', 'zpenchen0@over-blog.com', '793-544-2484', '$2a$04$72Zp1zlaeKU5NsvqTvDiyOm2WZgJJJD3f6WY.bm/RwiA4Zljn1uf6', 'lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis', 'zpenchen0', false);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Ilysa', 'Graysmark', 'igraysmark1@icq.com', '934-202-8943', '$2a$04$uZR6D0aUYHRh8KxfcZ.qYu7txQU1J6rMf.9dJscabKNTHCXZ7VAaO', 'nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel', 'igraysmark1', true);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Trev', 'Evett', 'tevett2@shop-pro.jp', '348-507-6701', '$2a$04$MvntNWlbuiMfVEmb/nGr1OLfB.KVjDqdJ2MUtzf0IOhwJy7d68262', 'posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend', 'tevett2', false);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Jessica', 'Iredell', 'jiredell3@mac.com', '761-185-0875', '$2a$04$2ABhbivRv0yAw4CyVZt/M.kV2OCcb.L8WQnZOWZhBN7Lj6sMkzSsa', 'nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in', 'jiredell3', false);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Madeline', 'Bethell', 'mbethell4@squidoo.com', '572-871-5381', '$2a$04$hEpK5SSS2EniBevtEJTQMO//sU..AfI7IBGmnkCjL0aA40U79k.Wy', 'et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut', 'mbethell4', true);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Jaymee', 'Bonnick', 'jbonnick5@lycos.com', '227-593-6890', '$2a$04$747/GC.jPz0XmhQUe/hGFOYqjv53eOY6eVIP6jaQp2zTOcAeFb6Pm', 'potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas', 'jbonnick5', true);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Gordon', 'Kupec', 'gkupec6@skype.com', '134-256-3685', '$2a$04$.M12bIYfzCaJSLMJTrItae1cFUFsvXjY/moux.HCauWa9udCprDMe', 'diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam', 'gkupec6', false);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Georgette', 'Yonge', 'gyonge7@slideshare.net', '155-708-1496', '$2a$04$PctvlAd60yWiLKV1qGon/uIUlR.QHS88XWGqCl1TOzKP0YMOrzV36', 'montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa', 'gyonge7', true);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Symon', 'Blaszczak', 'sblaszczak8@si.edu', '308-262-9464', '$2a$04$LixR9UULImwAU/FIwp2DBu0o5dcTxNZVWSl2Xd20LCXZIjymPf8b6', 'primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor', 'sblaszczak8', true);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Innis', 'Stratten', 'istratten9@aol.com', '975-282-3329', '$2a$04$6uAcr5uxDc1kgt/RXj7BS.86CmMnQXcpzJqrJdJ6ja/LVx2hIFLUG', 'sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in', 'istratten9', false);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Ernest', 'Forker', 'eforkera@seesaa.net', '799-962-5488', '$2a$04$O.mPViEGvCJ9Z8NctIdI7utkitrzxRXKu0hFNQiquVaHfl0SmybfS', 'pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu', 'eforkera', false);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Rhody', 'Thireau', 'rthireaub@ebay.com', '770-361-2764', '$2a$04$UZT7A0QotsKHE/jnWeDC5OpGnOP1qrTV6RGP2ZgIpzlwcvzuu7r5e', 'ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices', 'rthireaub', false);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Sven', 'McElhinney', 'smcelhinneyc@bbb.org', '788-973-3305', '$2a$04$rkOg.xKTMTIMjZeCXdEH3ec/rgyR6LbQMGakck5B3qPnVaEC6mkt6', 'vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in', 'smcelhinneyc', true);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Ursuline', 'Strike', 'ustriked@ed.gov', '948-612-9452', '$2a$04$79M9xDJRi8X7B/eROn0vleGjnK8ZCLBqksPoz8ed3Cxmugna2KHH2', 'consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla', 'ustriked', true);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Pace', 'Abramchik', 'pabramchike@virginia.edu', '721-543-7872', '$2a$04$GnK57iaGO511VxdPu/uZGeqUx5VJiZhsq3ST/weqRNLxzYCA0s01e', 'purus phasellus in felis donec semper sapien a libero nam dui', 'pabramchike', false);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Mira', 'Gartsyde', 'mgartsydef@php.net', '369-807-1752', '$2a$04$L9riz5PmXGSJP8i4i6./5u7zE89rNvw.gAjbd/ep1wNn4h8K.W13e', 'dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi', 'mgartsydef', false);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Ram', 'Levesque', 'rlevesqueg@scribd.com', '247-264-9671', '$2a$04$xaTER90/UVHvEE0KhqNYL.ZqVtp4OMJRmELQ7sgxr/zFCdKsilZCO', 'justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra', 'rlevesqueg', true);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Liv', 'de Guerre', 'ldeguerreh@technorati.com', '321-423-1144', '$2a$04$6YiV9KEZTUEB2TII4FrFw.8Jeh.hNVsHuarZqLXep09f/t08dZL9C', 'mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac', 'ldeguerreh', true);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ( 'Orv', 'Geldart', 'ogeldarti@about.com', '187-778-9261', '$2a$04$ya6pEfbkRDfjQGDc3vp7..C2YqyN1saRdVKUq.26I3sThChWbllUu', 'ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque', 'ogeldarti', true);
insert into advisors ( firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ( 'Nessy', 'Sebyer', 'nsebyerj@abc.net.au', '496-101-3429', '$2a$04$R9Up28pTvkWZDFsHBcg0D.QwRd6xYqVZR3xFEHxVZWtxpBDrx6koW', 'libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet', 'nsebyerj', true);

-- Inserting sample data for students
INSERT INTO students (firstName, lastName, email, phone, passwordHash, username, advisor)
VALUES
('Alice', 'Johnson', 'alice.johnson@email.com', '555-0201', 'hashed_password_4', 'alicejohnson', 1),
('Bob', 'Williams', 'bob.williams@email.com', '555-0202', 'hashed_password_5', 'bobwilliams', 2),
('Charlie', 'Davis', 'charlie.davis@email.com', '555-0203', 'hashed_password_6', 'charliedavis', 3);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Jolie', 'Balazot', 'jbalazot0@networkadvertising.org', '922-858-3438', '$2a$04$NWENB8PneHQRE9OSRsRbZeirt6FC1bDE2LN/4QVM8.C8sY1j73oWK', '#8d1', 'eget vulputate ut ultrices vel augue vestibulum ante ipsum primis', 'jbalazot0', true, false, '20');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Guenevere', 'Woof', 'gwoof1@mozilla.org', '666-585-3632', '$2a$04$C54UsHlUjnshA3h62xBWk.bFj7Nk992CvQslKx6gyHYA.8AujuOdy', '#e78', 'non interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia', 'gwoof1', false, true, '12');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Ange', 'Frankcombe', 'afrankcombe2@bbc.co.uk', '486-606-1241', '$2a$04$TpJBu8r/UGaho10.Cvzxg.bgIkvjhs1K8lDs.csyDntmqWMhnH1nm', '#c8f', 'ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at', 'afrankcombe2', true, true, '3');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Merv', 'Lavery', 'mlavery3@meetup.com', '537-911-0662', '$2a$04$6.EwRPfO1uli2F/FO4G7jOoPMsOlT9m4/syPOUsRSquaq6pzmhf.2', '#d4b', 'aliquam non mauris morbi non lectus aliquam sit amet diam in', 'mlavery3', true, false, '15');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Oliy', 'Meak', 'omeak4@cisco.com', '779-950-0528', '$2a$04$U6wuX2QziKKdo9mvtnAFP.J1vlPsuf.DaM15TsCwruaMdUKneevX.', '#086', 'nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor', 'omeak4', false, true, '18');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Bobine', 'Rable', 'brable5@ucoz.com', '173-530-0313', '$2a$04$4f2/.61rVeFxMAE0H.9Oq.lUFFb8WVkrluWaak/VfFIM0d7uy9RTO', '#9c6', 'vulputate elementum nullam varius nulla facilisi cras non velit nec', 'brable5', false, true, '14');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Evelyn', 'Irons', 'eirons6@joomla.org', '947-811-6458', '$2a$04$ifuBgsxAQPkzERjzGbnYiuO6QtxYemJk3u3QdOmIYeTyjR69gacXC', '#733', 'amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at', 'eirons6', false, true, '1');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Amelita', 'Union', 'aunion7@wisc.edu', '287-993-7075', '$2a$04$PwKEh/8IW0UH/rxxjQFIEegVXxe3A5XdsAZrCiMNenYrG5CIcomke', '#4b9', 'vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat', 'aunion7', true, true, '13');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Bethina', 'De Anesy', 'bdeanesy8@mtv.com', '686-350-9242', '$2a$04$yQVFC97eOhcIxLZZTW9MceryDypOXJUgIwLpPPFv6NRhlxzUzOavC', '#127', 'tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum', 'bdeanesy8', false, false, '9');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ( 'Charmane', 'Coleridge', 'ccoleridge9@t-online.de', '264-370-7774', '$2a$04$OEbIf4cg8/6FoFrzeQMzE.IGtdKyrA6VfgWSHrV26SVnFmYrOyG.S', '#ae8', 'varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros', 'ccoleridge9', true, true, '2');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ( 'Felice', 'Jerrard', 'fjerrarda@reverbnation.com', '798-719-2966', '$2a$04$ToySkychd9X8iQnJgO.hQeVshx7bu.6lj0S/1G1DYV1W4rMPeNxGC', '#c0f', 'cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae', 'fjerrarda', false, false, '11');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ( 'Orson', 'Birkby', 'obirkbyb@salon.com', '770-633-1745', '$2a$04$BpisQG22aZtyZYy7nUenYO2GCShTYIJ7ldyslnoYU0jIyUDuqSmHu', '#ab3', 'vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet', 'obirkbyb', true, true, '4');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ( 'Hally', 'Jeannel', 'hjeannelc@patch.com', '760-464-2389', '$2a$04$t8gYL2u/AssPFJaUEEZKfuBu8yh1Chne.snHwB.1mp8EG2hnIgMym', '#97a', 'metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam', 'hjeannelc', true, true, '16');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ( 'Pete', 'Barrowclough', 'pbarrowcloughd@canalblog.com', '423-932-6549', '$2a$04$FEUf9Zh0v04voFGDHVSsWug29xPgMwas/BFGI5PjP40KMSLb6vs6G', '#ee2', 'ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque', 'pbarrowcloughd', true, false, '5');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ( 'Brien', 'Knightley', 'bknightleye@nbcnews.com', '454-321-0050', '$2a$04$SGZqgch3WLteG/ikScbyLuiumnHRYf0RzEFiTenDkm0TJojRf2bB6', '#883', 'parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean', 'bknightleye', false, false, '6');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ( 'Arlie', 'Munday', 'amundayf@wsj.com', '149-127-5975', '$2a$04$ZHmo5Q8dRyFC/MsWYhBjkOHGj6Vd94nTsIrqBfuZNVON6NmRUaTia', '#803', 'orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat', 'amundayf', false, true, '19');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ( 'Zelda', 'Sennett', 'zsennettg@hostgator.com', '271-650-6306', '$2a$04$NEgBL/v41vyZxCGUo.RfgOBsj4bVKv0PZyh22EjJobVZfgddQqOVK', '#af5', 'amet cursus id turpis integer aliquet massa id lobortis convallis', 'zsennettg', true, true, '7');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ( 'Raye', 'Mingey', 'rmingeyh@w3.org', '464-321-3949', '$2a$04$PTIg7qB1Eed1Xs89COaRhOVf8Z5ukQbI47V3W7L0IErJBdtPf3L7W', '#b0c', 'leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras', 'rmingeyh', true, false, '17');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ( 'Norry', 'Scoffham', 'nscoffhami@ocn.ne.jp', '305-738-9482', '$2a$04$qebqVQTSwCYdvnSVMKEyZuaKf1g5ODIrnw6DeeTBzuhq71zMvxlHS', '#d44', 'vel est donec odio justo sollicitudin ut suscipit a feugiat et eros', 'nscoffhami', true, true, '8');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ( 'Odie', 'Swinburn', 'oswinburnj@123-reg.co.uk', '232-979-5648', '$2a$04$R.pVSdn58lCaNYjAqAtqjOaVrA146rW0KgXAg9v9njjJH/NWDCw.S', '#129', 'est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis', 'oswinburnj', true, true, '10');

-- Inserting sample data for student_stats

insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (1, 3.89, 'Female', 'Argentinian', 'DC Circuits', 62, 60, 30, 'AmetLobortis.ppt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (2, 1.74, 'Bigender', 'Kiowa', 'DV Camera Operator', 21, 61, 40, 'Risus.mov');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (3, 0.16, 'Female', 'Pakistani', 'Jet Ski', 94, 41, 76, 'VivamusMetusArcu.avi');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (4, 0.35, 'Female', 'Asian', 'Military Training', 42, 83, 53, 'DiamNequeVestibulum.pdf');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (5, 2.23, 'Agender', 'Paiute', 'ICH-GCP', 20, 21, 78, 'NecNisiVolutpat.xls');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (6, 2.93, 'Male', 'Navajo', 'Commercial Kitchen Design', 15, 56, 21, 'VitaeConsectetuer.txt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (7, 0.48, 'Female', 'Alaskan Athabascan', 'Non-Conforming', 63, 94, 32, 'Nisl.avi');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (8, 1.05, 'Male', 'Venezuelan', 'Xcart', 96, 13, 41, 'Ipsum.tiff');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (9, 0.51, 'Female', 'Indonesian', 'Kaspersky Antivirus', 60, 55, 64, 'CommodoPlaceratPraesent.ppt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (10, 3.15, 'Male', 'Taiwanese', 'HCM Processes &amp; Forms', 46, 75, 71, 'Euismod.pdf');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (11, 0.51, 'Male', 'Ecuadorian', 'Feature Films', 74, 35, 26, 'MiInPorttitor.pdf');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (12, 0.79, 'Agender', 'Chinese', 'SMT Kingdom', 13, 86, 6, 'EuOrciMauris.mp3');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (13, 0.78, 'Female', 'Apache', 'Omniture', 32, 82, 24, 'IpsumPrimisIn.ppt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (14, 3.81, 'Female', 'Tongan', 'Access', 33, 44, 63, 'Luctus.mp3');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (15, 2.89, 'Male', 'Micronesian', 'CQS', 93, 100, 80, 'Pulvinar.xls');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (16, 3.96, 'Female', 'Yaqui', 'NCover', 84, 86, 18, 'Convallis.avi');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (17, 3.34, 'Female', 'Apache', 'QAD', 6, 96, 24, 'Eu.ppt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (18, 0.57, 'Female', 'Ottawa', 'Corporate Identity', 75, 66, 99, 'TortorSollicitudin.tiff');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (19, 2.42, 'Female', 'Yakama', 'XML Schema', 100, 64, 25, 'Duis.ppt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (20, 0.52, 'Female', 'Cambodian', 'Piping', 40, 2, 82, 'EleifendQuamA.tiff');

-- Inserting sample data for companies
INSERT INTO companies (companyName, repEmail, repPhone, website, passwordHash, activityStatus)
VALUES
('TechCorp', 'contact@techcorp.com', '555-0301', 'www.techcorp.com', 'hashed_password_7', 1),
('MediPlus', 'contact@mediplus.com', '555-0302', 'www.mediplus.com', 'hashed_password_8', 1),
('Innovate Ltd', 'contact@innovateltd.com', '555-0303', 'www.innovateltd.com', 'hashed_password_9', 1);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Latz', 'mlernihan0@newyorker.com', '699-717-1347', '', '$2a$04$OiDDhZsjGUw11ZCfjLTx6O5wI/XY1P2FKFZtNBcKIUCzbXrt6pvy2', 'grid-enabled', 'eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Oba', 'afilipchikov1@disqus.com', '216-486-4206', '', '$2a$04$hPIf4OKRfLlMB1RRjNB4ZeGS498zlu1rpZvgEqp5ComwBTVCMblCe', 'transitional', 'eget eleifend luctus ultricies eu nibh quisque id justo sit', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Meetz', 'zcattroll2@berkeley.edu', '159-184-7117', '', '$2a$04$6t5XM7VsFfZnVhnkmatJieC48A2Jm1g4dGCxEBqb2fqD5IDczaQMa', 'bottom-line', 'amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Tagpad', 'lmallall3@barnesandnoble.com', '210-902-1903', '', '$2a$04$02i51yk.iUHx38wuOcyF3uG6XHIW8zpMDs4jmfOmUX15x0bPnQKnW', '24 hour', 'et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Tagpad', 'tportt4@ocn.ne.jp', '534-294-2748', '', '$2a$04$RSUJEFp9AACUOr.4ivjGduUPMQ.l6dVdgipqhZMeVWkTBqb4jNgwK', 'Fully-configurable', 'turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Photobean', 'briby5@mysql.com', '573-263-1267', '', '$2a$04$c2E.uM7Nzn9qOkHXI/Esc.fDNeROdBtXegiPQeUjkdFBTXwxlPqf.', 'Cross-group', 'lacus morbi quis tortor id nulla ultrices aliquet maecenas leo', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Buzzster', 'ttyas6@epa.gov', '471-491-3456', '', '$2a$04$tjWb.n.4eNk3XxxxMQqBZuQYuJeqJkdAXRqeoRS5dkP5cSeGMxwhe', 'bottom-line', 'massa id lobortis convallis tortor risus dapibus augue vel accumsan', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Brainbox', 'rwannop7@purevolume.com', '540-698-3841', '', '$2a$04$7.IF8/5sKPuFUr.UoxsUbO3TcgMT4MeljBV3CYdnaqWpasWT5mKAS', 'flexibility', 'tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Meembee', 'aweekly8@posterous.com', '959-679-8405', '', '$2a$04$gUblh/R2e4QqsXg4KXi0QOlWCfoF9EltKT3R2uJ1XPH.rG4.Y9CJy', 'De-engineered', 'massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Npath', 'lmcgrane9@examiner.com', '378-616-7026', '', '$2a$04$LdtvrV7GCcQIRCxX8S63tOEviXX.HqXXQT87OGrnM/qKq2ytAtdk.', 'synergy', 'vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Photolist', 'ocoila@drupal.org', '913-487-1433', '', '$2a$04$L9wkvoOdR/tYC2redyqIqesWbX0iqr6nYNZDhyPGVIif4RgjvPTIO', 'cohesive', 'sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Feedmix', 'ijaslemb@nytimes.com', '623-484-4674', '', '$2a$04$poAe4bNB9TJkUfr/sPRNjOtyJyHhxcoZL0cWqItkyZd2K1w4A4Pvu', 'dedicated', 'nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Meeveo', 'ccrosterc@google.cn', '993-629-5864', '', '$2a$04$F00mY92UXhbWAEzZWO53s.e/zsWidJZnRc7SbQMeGd5qX3XdugnsS', 'zero administration', 'blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Thoughtmix', 'alangsburyd@nytimes.com', '951-713-0400', '', '$2a$04$yEGfHTrSz8t3OqNf2P29aukFk.hotTv/kBU0keSZfx/4H9PZClRf2', 'content-based', 'magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Jazzy', 'cmellsope@ft.com', '644-920-0306', '', '$2a$04$WyHVfHgWEWmVvUuC.5w9Le6DJuJglXB6X0uLYw3bIihFMFQSEfegm', 'demand-driven', 'sit amet eleifend pede libero quis orci nullam molestie nibh in lectus', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Twiyo', 'pkedslief@myspace.com', '422-972-3494', '', '$2a$04$MJGYxTZQtUMETOAL8pomuOpSTeF25wts273MV/suO4qDwxJK339bq', 'tertiary', 'ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Zoomlounge', 'ptolchardg@domainmarket.com', '446-251-9557', '', '$2a$04$ZMEGFGrJXBmZ3Er5fpFBU.gVVqdlFFrkIGNQDeuiH/7j.g4QFMrb6', 'Fully-configurable', 'venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Skyba', 'dquinnh@wufoo.com', '972-332-8774', '', '$2a$04$u8nBw1S10nEsSRloEHevLeZj7Hn.QWbUBOSLK88M0NExqdLMS9IeW', 'background', 'curabitur in libero ut massa volutpat convallis morbi odio odio elementum', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Buzzshare', 'larnaudeti@cnet.com', '666-246-7444', '', '$2a$04$ir6g6T094Wnjugbe7V0N1e.8iu5ZsSmr8Qc18lxCgSYI/az4xbAHi', 'Enterprise-wide', 'ut at dolor quis odio consequat varius integer ac leo pellentesque', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Omba', 'cajeanj@state.tx.us', '759-748-1331', '', '$2a$04$QAGbWzLCBZDVSwfcr79XbuvYtY6wmOGjyZ16K8Cs2n/DD2.dZthO2', 'demand-driven', 'sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula', false);

-- Inserting sample data for worked_at

insert into worked_at (studentId, companyId) values (1, 1);
insert into worked_at (studentId, companyId) values (2, 2);
insert into worked_at (studentId, companyId) values (3, 3);
insert into worked_at (studentId, companyId) values (4, 4);
insert into worked_at (studentId, companyId) values (5, 5);
insert into worked_at (studentId, companyId) values (6, 6);
insert into worked_at (studentId, companyId) values (7, 7);
insert into worked_at (studentId, companyId) values (8, 8);
insert into worked_at (studentId, companyId) values (9, 9);
insert into worked_at (studentId, companyId) values (10, 10);
insert into worked_at (studentId, companyId) values (11, 11);
insert into worked_at (studentId, companyId) values (12, 12);
insert into worked_at (studentId, companyId) values (13, 13);
insert into worked_at (studentId, companyId) values (14, 14);
insert into worked_at (studentId, companyId) values (15, 15);
insert into worked_at (studentId, companyId) values (16, 16);
insert into worked_at (studentId, companyId) values (17, 17);
insert into worked_at (studentId, companyId) values (18, 18);
insert into worked_at (studentId, companyId) values (19, 19);
insert into worked_at (studentId, companyId) values (20, 20);




-- Inserting sample data for coops
INSERT INTO coops (jobTitle, hourlyRate, location, industry, summary, company)
VALUES
('Software Developer', 25.00, 'San Francisco', 'Tech', 'Developed applications for clients', 1),
('Intern', 18.50, 'Los Angeles', 'Healthcare', 'Assisted with patient data management', 2),
('Electrical Engineer Intern', 22.00, 'Chicago', 'Engineering', 'Worked on product development', 3);
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Electrical Engineer', '38.71', 'Baluk', 'Education', 'auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis', '11');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Senior Sales Associate', '36.01', 'Laban', 'Healthcare', 'fermentum justo nec condimentum neque sapien placerat ante nulla justo', '20');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Systems Administrator I', '27.71', 'Gagarin', 'Manufacturing', 'magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer', '16');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Account Executive', '29.36', 'Gachancipá', 'Other', 'dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus', '13');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Office Assistant II', '25.05', 'Itaí', 'Finance', 'sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem', '14');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Analog Circuit Design manager', '28.78', 'Nangerang', 'Manufacturing', 'aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum', '2');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Paralegal', '29.63', 'Skövde', 'Healthcare', 'eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed', '15');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Teacher', '39.80', 'Moyuan', 'Education', 'ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed', '7');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Senior Sales Associate', '36.07', 'Kertorejo', 'Technology', 'id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus', '18');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('VP Product Management', '20.61', 'Ruukki', 'Manufacturing', 'donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac', '10');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Graphic Designer', '25.21', 'Qaryūt', 'Finance', 'sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede', '5');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Executive Secretary', '30.41', 'Yihe', 'Technology', 'quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit amet', '1');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Analog Circuit Design manager', '25.72', 'Al Bayḑā’', 'Technology', 'ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est', '4');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Database Administrator IV', '32.44', 'Nentón', 'Healthcare', 'diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu', '9');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Human Resources Manager', '21.97', 'Aloleng', 'Manufacturing', 'eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum', '6');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Director of Sales', '38.23', 'Longzhou', 'Education', 'congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio', '8');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Librarian', '34.62', 'Nueva Ocotepeque', 'Education', 'sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi', '17');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Internal Auditor', '26.16', 'Xuefeng', 'Manufacturing', 'adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in', '3');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Senior Editor', '34.63', 'Gyangqai', 'Manufacturing', 'dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat', '19');
insert into coops (jobTitle, hourlyRate, location, industry, summary, company) values ('Director of Sales', '33.04', 'Napak', 'Healthcare', 'ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus', '12');



-- Inserting sample data for reviews


insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('11', '17', false, 1, '1', 116174576, 'turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('18', '15', true, 1, '7', 994177391, 'volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('10', '2', false, 4, '19', 972077829, 'ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('3', '11', false, 4, '13', 166760523, 'luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('1', '12', false, 3, '17', 961010876, 'erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('4', '4', true, 5, '15', 235546674, 'in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('6', '1', false, 1, '2', 472054643, 'vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('7', '16', true, 3, '4', 852890909, 'sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('15', '18', true, 4, '3', 331930693, 'nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('5', '14', false, 4, '20', 93863672, 'erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('12', '13', false, 1, '8', 458292794, 'sit amet cursus id turpis integer aliquet massa id lobortis');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('19', '5', true, 2, '14', 795527964, 'nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('20', '6', false, 5, '11', 248047106, 'morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('17', '10', true, 2, '5', 154088372, 'nec sem duis aliquam convallis nunc proin at turpis a pede posuere');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('13', '9', false, 1, '16', 747208719, 'odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('2', '19', true, 2, '9', 417713889, 'nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('14', '7', true, 1, '18', 715881474, 'a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('16', '3', false, 2, '12', 634336756, 'non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('8', '20', true, 2, '10', 363655836, 'felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae');
insert into reviews (poster, reviewOf, anonymous, stars, coopId, likes, content) values ('9', '8', false, 2, '6', 407832226, 'eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum');




-- Inserting sample data for comments

insert into comments (reviewId, content, poster) values ('12', 'aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent', '2');
insert into comments (reviewId, content, poster) values ('8', 'elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi', '7');
insert into comments (reviewId, content, poster) values ('16', 'sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum', '18');
insert into comments (reviewId, content, poster) values ('17', 'et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo', '13');
insert into comments (reviewId, content, poster) values ('13', 'non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus', '15');
insert into comments (reviewId, content, poster) values ('14', 'ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec', '10');
insert into comments (reviewId, content, poster) values ('4', 'vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et', '20');
insert into comments (reviewId, content, poster) values ('15', 'dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien', '6');
insert into comments (reviewId, content, poster) values ('20', 'feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl', '3');
insert into comments (reviewId, content, poster) values ('18', 'ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras', '16');
insert into comments (reviewId, content, poster) values ('9', 'faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in', '8');
insert into comments (reviewId, content, poster) values ('10', 'donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in', '19');
insert into comments (reviewId, content, poster) values ('5', 'risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis', '1');
insert into comments (reviewId, content, poster) values ('2', 'nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum', '11');
insert into comments (reviewId, content, poster) values ('3', 'auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis', '4');
insert into comments (reviewId, content, poster) values ('11', 'ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida nisi at', '9');
insert into comments (reviewId, content, poster) values ('6', 'massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar', '12');
insert into comments (reviewId, content, poster) values ('1', 'nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque', '17');
insert into comments (reviewId, content, poster) values ('7', 'amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan', '5');
insert into comments (reviewId, content, poster) values ('19', 'ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit', '14');

-- Inserting sample data for system_admins

insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Evita', 'Gulliman', 'egulliman0@harvard.edu', '528-978-9827', '$2a$04$U51Vx5xl7kzn2V52D.Mzg.JUfk3PbkIM3gyiJBdYlTHarp/4dR1na', 'egulliman0');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Leanna', 'Poppleston', 'lpoppleston1@altervista.org', '768-507-8326', '$2a$04$Q93oBhGm41Ksz1l63it8pue/rPpcpyVUJwRN5L/xZYVOOQk/VjbzG', 'lpoppleston1');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Cassius', 'Skim', 'cskim2@cnbc.com', '138-467-7824', '$2a$04$hbt6YhcAmgmXEjUV2PChTeHqYYTKJHYf.X7h7McFjjHkfZ9X7jf76', 'cskim2');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Georgeta', 'Gerardet', 'ggerardet3@earthlink.net', '791-361-9470', '$2a$04$f.Pj86qREkNIitm5VgKdWe2cF6cRXb4LEB8GKIOJntAOBSW.4tK/y', 'ggerardet3');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Billie', 'Copland', 'bcopland4@jugem.jp', '414-143-7490', '$2a$04$eitMQfHRazl4cqPWFQHbpuw5I95ph7KKnpwJdFb2TeHZCO9q1oL5.', 'bcopland4');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Marje', 'Sherry', 'msherry5@imgur.com', '314-390-0679', '$2a$04$nGraFRH1apCnPdlMy1hg2uxlOdrtwIgLZpQ5C6wxjMm61MmTq3Zmy', 'msherry5');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Herminia', 'Deakan', 'hdeakan6@mit.edu', '185-541-5723', '$2a$04$RiXmRGph19MmZ4AHeAsM6OWGN8hVFnHHhWiYowb4DzxCScMIPbj4W', 'hdeakan6');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Pamela', 'Klainman', 'pklainman7@miitbeian.gov.cn', '848-141-0850', '$2a$04$ijqr66nLcUGZGYM488oauOCuI/wnCT0GEkLwKPVXvDnyCw0W8Xg9W', 'pklainman7');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Shawn', 'Tewes', 'stewes8@linkedin.com', '818-871-0781', '$2a$04$MxRaGhT1hoRUoAg9ac6mG.LYIWnWINM6UbmKleImPfa7rmGPJY8nm', 'stewes8');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Ashley', 'Torbett', 'atorbett9@prnewswire.com', '736-533-3209', '$2a$04$nsdQGjh2IyB06O3t5XIou.7Ytg1UwaGQ.pHfgZtg3nBZWfHh4iNT2', 'atorbett9');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Martita', 'Bier', 'mbiera@google.it', '737-598-5805', '$2a$04$6F0rKBIoOBRLeUzpdx627.spRkBx2LblJvFG3/ROzMEBhj1txGBTC', 'mbiera');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Pen', 'Darville', 'pdarvilleb@usda.gov', '187-753-7138', '$2a$04$af8HCwwM9zMchc3PGidOiOdBAEEkJWLC77BJZaPi3O3aYhPN5GUYW', 'pdarvilleb');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Bessie', 'Andersson', 'banderssonc@cpanel.net', '960-194-1637', '$2a$04$NMAZetiWsNW.4YK4lCKA0uIKelqwlzq6D2DVLrAiwFBPNxvd2Z/cq', 'banderssonc');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Cori', 'Hedon', 'chedond@about.com', '144-330-2323', '$2a$04$YgKK4sq9EZz9fGVHvRJX8uTCAa.kQJ5sm9buoEThWXZPvxqX3BK.O', 'chedond');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Marchelle', 'Whiteson', 'mwhitesone@house.gov', '456-229-0996', '$2a$04$jvu6bWD.iLg0VbgE2xc6y.c/94z/oeOQVlGvVD3vE17cYJNHFUnM2', 'mwhitesone');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Alvie', 'Tritton', 'atrittonf@apache.org', '523-898-4651', '$2a$04$jn4bEk5VtU1yqIwy8SfmKe.AaeP/sJCvKjBgjIvnEjNIU.2ftSvs2', 'atrittonf');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Elonore', 'West', 'ewestg@squarespace.com', '440-857-1075', '$2a$04$ZjZqBzEbyrwGxfVICnv0teDf4AFojWpjRCCfjunENmrM9Xbbhmmg.', 'ewestg');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Burk', 'Waiton', 'bwaitonh@printfriendly.com', '240-414-9378', '$2a$04$S0kV.CNIWY9lC05IJCNB8O3BVDSVRUm.0m96uv.iBnQolrCRCozWu', 'bwaitonh');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Corissa', 'Bernette', 'cbernettei@de.vu', '209-404-2428', '$2a$04$APgwLsO8xXRLqQl3ZgZpy.kcSllJXALT5/nMvGx1eHyIwHH7bnkOC', 'cbernettei');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Bertine', 'Enderlein', 'benderleinj@ucsd.edu', '816-571-6798', '$2a$04$VFaxoEktuNVQE1dAJjBlju63GVxcQv.FJmhJheLlQjO4xxsQo7jfO', 'benderleinj');

-- Inserting sample data for requests

insert into requests (details, resolveStatus, companyId, studentId) values ('tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis', false, '1', '9');
insert into requests (details, resolveStatus, companyId, studentId) values ('mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem', false, '14', '13');
insert into requests (details, resolveStatus, companyId, studentId) values ('posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus', false, '12', '8');
insert into requests (details, resolveStatus, companyId, studentId) values ('ultrices phasellus id sapien in sapien iaculis congue vivamus metus', false, '7', '11');
insert into requests (details, resolveStatus, companyId, studentId) values ('ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero', true, '19', '12');
insert into requests (details, resolveStatus, companyId, studentId) values ('id massa id nisl venenatis lacinia aenean sit amet justo morbi ut', true, '4', '1');
insert into requests (details, resolveStatus, companyId, studentId) values ('nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla', false, '3', '14');
insert into requests (details, resolveStatus, companyId, studentId) values ('sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia', true, '9', '20');
insert into requests (details, resolveStatus, companyId, studentId) values ('aenean auctor gravida sem praesent id massa id nisl venenatis lacinia', false, '8', '17');
insert into requests (details, resolveStatus, companyId, studentId) values ('augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea', true, '20', '15');
insert into requests (details, resolveStatus, companyId, studentId) values ('et tempus semper est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante', false, '18', '7');
insert into requests (details, resolveStatus, companyId, studentId) values ('cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque', true, '15', '2');
insert into requests (details, resolveStatus, companyId, studentId) values ('elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet', true, '11', '10');
insert into requests (details, resolveStatus, companyId, studentId) values ('ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam', true, '5', '19');
insert into requests (details, resolveStatus, companyId, studentId) values ('nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum', true, '13', '6');
insert into requests (details, resolveStatus, companyId, studentId) values ('elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at', true, '16', '18');
insert into requests (details, resolveStatus, companyId, studentId) values ('ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra', true, '10', '16');
insert into requests (details, resolveStatus, companyId, studentId) values ('donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis', true, '2', '4');
insert into requests (details, resolveStatus, companyId, studentId) values ('ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at', false, '6', '5');
insert into requests (details, resolveStatus, companyId, studentId) values ('aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet', false, '17', '3');


-- Inserting sample data for system_updates
insert into system_updates (details, updatedBy) values ('vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur', '8');
insert into system_updates (details, updatedBy) values ('tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac', '14');
insert into system_updates (details, updatedBy) values ('adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus', '5');
insert into system_updates (details, updatedBy) values ('mauris enim leo rhoncus sed vestibulum sit amet cursus id turpis', '13');
insert into system_updates (details, updatedBy) values ('vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac', '17');
insert into system_updates (details, updatedBy) values ('orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis', '9');
insert into system_updates (details, updatedBy) values ('suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur', '19');
insert into system_updates (details, updatedBy) values ('nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit donec diam', '1');
insert into system_updates (details, updatedBy) values ('ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec', '4');
insert into system_updates (details, updatedBy) values ('a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis', '16');
insert into system_updates (details, updatedBy) values ('et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere', '6');
insert into system_updates (details, updatedBy) values ('justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique', '7');
insert into system_updates (details, updatedBy) values ('enim leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa', '15');
insert into system_updates (details, updatedBy) values ('eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus', '10');
insert into system_updates (details, updatedBy) values ('ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis', '3');
insert into system_updates (details, updatedBy) values ('dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit', '2');
insert into system_updates (details, updatedBy) values ('nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur', '20');
insert into system_updates (details, updatedBy) values ('sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim', '18');
insert into system_updates (details, updatedBy) values ('metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque', '12');
insert into system_updates (details, updatedBy) values ('dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros', '11');


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
    WHERE statSharing != 0 AND jobTitle = 'Intern'
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








