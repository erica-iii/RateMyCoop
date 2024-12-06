
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
    hourlyRate int,
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

-- creating an advisor/student recommedation and feedback table
DROP TABLE IF EXISTS recommendations;
CREATE TABLE recommendations (
    recommendationId int AUTO_INCREMENT NOT NULL,
    studentId int NOT NULL,
    advisorId int NOT NULL,
    coopId int NOT NULL,
    feedback text NOT NULL,
    PRIMARY KEY (recommendationId),
    CONSTRAINT fk_sid FOREIGN KEY (studentId) REFERENCES students (studentId) ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT fk_aid FOREIGN KEY (advisorId) REFERENCES advisors (advisorId) ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT fk_cid FOREIGN KEY (coopId) REFERENCES coops (coopId) ON UPDATE cascade ON DELETE cascade
);

CREATE INDEX id ON recommendations (recommendationId);



-- Sample data for each table
INSERT INTO advisors (firstName, lastName, email, phone, passwordHash, username, activityStatus)
VALUES
('John', 'Doe', 'john.doe@email.com', '555-0101', 'hashed_password_1', 'johndoe', 1),
('Jane', 'Smith', 'jane.smith@email.com', '555-0102', 'hashed_password_2', 'janesmith', 1),
('Bill', 'Turner', 'bill.turner@email.com', '555-0103', 'hashed_password_3', 'billturner', 1);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Chick', 'Beagrie', 'cbeagrie0@gizmodo.com', '412-870-7204', '$2a$04$tIGd4wtJ.cFvXS9Rq/anL.kOo2hxbTr/kyVLe7pcCEnRqAwMHjnUC', 'parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes', 'cbeagrie0', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Randolf', 'Smeall', 'rsmeall1@etsy.com', '504-607-5798', '$2a$04$UFejR8/M/IY/zY6RUU3mvusNd45s5IwshgvVMRwHwa2HOOKxckrb2', 'habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget', 'rsmeall1', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Aloisia', 'Burston', 'aburston2@cmu.edu', '765-654-1591', '$2a$04$2lRK.z4sbWOZ1Pnz6D/rhOQHmqlp7wXfUjPqT4vX2xS6wLjHTRI4.', 'potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis', 'aburston2', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Correna', 'Searby', 'csearby3@google.it', '930-434-4997', '$2a$04$nryQs09QEx3DZfC1jQE8f.GE05kcVVojhBZXfgv4L8D18J.OHXA1W', 'sollicitudin mi sit amet lobortis sapien sapien non mi integer', 'csearby3', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Ilysa', 'Chamberlin', 'ichamberlin4@bandcamp.com', '377-941-9496', '$2a$04$hkOvCIJpBCVd91SkMvo7veQP8yDOiJwJUhOCeHrw0Jd..njC2FpRq', 'vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis', 'ichamberlin4', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Simona', 'Getcliffe', 'sgetcliffe5@jigsy.com', '324-432-8017', '$2a$04$16k2t.qoIlCjBPobwxEwTeZd9vFYBfKp04x4epG8.BDhhZPNfs3qW', 'non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus', 'sgetcliffe5', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Lilah', 'Rau', 'lrau6@jiathis.com', '249-428-1150', '$2a$04$G.Oslk1R38VTTsUCwIPvHOUK74OHam54QtD4YCrfAqs3QiGS8vIcK', 'mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit', 'lrau6', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Ortensia', 'McRinn', 'omcrinn7@redcross.org', '221-152-6972', '$2a$04$8IgxXonqUEj1RqMUqITr0eLWV15hsiQ/VnPJjHFnDAwuE2YnElWMi', 'mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque', 'omcrinn7', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Dore', 'Maitland', 'dmaitland8@weibo.com', '208-692-5432', '$2a$04$F9OtuGK/rx7iTORUZMFMGen00bJVm4arQQaIDAz9z5MdVo6.TCyLm', 'dui nec nisi volutpat eleifend donec ut dolor morbi vel', 'dmaitland8', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Ozzy', 'Lowndes', 'olowndes9@google.co.uk', '770-787-4474', '$2a$04$V6N5Pd94DTKdLC.L/4qWoe7sHNObdSq5jV6HMnJqknywfp9MCpwBe', 'aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent', 'olowndes9', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Gwyn', 'Ledgeway', 'gledgewaya@google.ca', '561-617-5172', '$2a$04$i2c7YogtcjNiX/ffQQpFVOS6Bh1pCQi7pjVZf6Y9ecUeg0O5nUbVu', 'in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt', 'gledgewaya', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Dyana', 'Muldownie', 'dmuldownieb@t.co', '231-675-5360', '$2a$04$5j9NSWNGZKCfHSqLpMif3udsy1i9.HwxSK6jgJuU24rhb4AV6ct6S', 'suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem fusce consequat', 'dmuldownieb', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Roland', 'Hargess', 'rhargessc@imageshack.us', '567-470-6418', '$2a$04$qttRXKT85rD7WynbRiSpguidZu3xkkjmqRta7INBrZ5SuyT/tx0Im', 'enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec', 'rhargessc', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Celestine', 'Thomsen', 'cthomsend@telegraph.co.uk', '622-501-6424', '$2a$04$kKEr49YGMKBPatsG/K2ZJOQtJ3uPIkZyGirotz2EYOJAUORt74DOW', 'justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus', 'cthomsend', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Clifford', 'Bartolomeotti', 'cbartolomeottie@marketwatch.com', '584-301-7793', '$2a$04$.svuIZcQL.YS8SCEWl69f.sVw5coyo1lJ8nVhQCFsPwyGHqEERDXO', 'porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in', 'cbartolomeottie', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Darlleen', 'Kernaghan', 'dkernaghanf@yahoo.com', '429-335-8908', '$2a$04$fHJQ9V9L9TzSFGvuJe5kDOexzYuGlog2EU22zkGpxEnYjtRprMueq', 'sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut', 'dkernaghanf', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Keefe', 'Dahlgren', 'kdahlgreng@cisco.com', '423-271-3162', '$2a$04$P6SmNbBbkPbqc/2BdJSE/eOjfVr5clsZN35Tzgn5FR82dIsWA0vCi', 'at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent', 'kdahlgreng', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Maxie', 'Sperrett', 'msperretth@nih.gov', '372-789-2851', '$2a$04$AIO28V66bXSBl077Q.U76uO6COa9dsPctfOgQs3Virp/E6syP3zIu', 'praesent id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio', 'msperretth', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Livvie', 'Martinets', 'lmartinetsi@etsy.com', '901-783-2861', '$2a$04$UGT.9SjLQdMzQ00ZD1Fu6u1yfS8L1JiQU0tKU5EvaRKIq9Sb3hsX.', 'vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae duis faucibus accumsan', 'lmartinetsi', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Stepha', 'Caudrelier', 'scaudrelierj@hostgator.com', '634-629-4523', '$2a$04$a28tZGAfQeyDaBpq2glIReD1Al9YxMhrpiFcyfnFkUQhUsNGQ1rvW', 'elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in', 'scaudrelierj', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Danila', 'Hiddy', 'dhiddyk@timesonline.co.uk', '414-198-2358', '$2a$04$l9WSkJYgK4dS4VQ9Ud6eOOFvvVYcI7V1eaxt7tvzDW.ETkdLFLW9i', 'ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst', 'dhiddyk', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Clare', 'Locke', 'clockel@usatoday.com', '493-706-5159', '$2a$04$CrguIF5nGP7unosbBHZkEul33WiDUL35gBAC4.tNrO5wC2bDcYmx.', 'est donec odio justo sollicitudin ut suscipit a feugiat et', 'clockel', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Conny', 'Mallebone', 'cmallebonem@soundcloud.com', '550-761-7975', '$2a$04$XUbiTgwg07oMknOS/LwJueRCyxWARigifjxwZxyj8DqHczYsdkt0O', 'nulla integer pede justo lacinia eget tincidunt eget tempus vel pede', 'cmallebonem', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Cordy', 'Calender', 'ccalendern@weather.com', '437-766-9887', '$2a$04$WcBwqUYuj2.o8IJY76TDxOfrBIHltAMShxbwAXSi4bR2mrL8weNAS', 'non pretium quis lectus suspendisse potenti in eleifend quam a odio in', 'ccalendern', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Skippie', 'Crimpe', 'scrimpeo@w3.org', '718-242-1752', '$2a$04$29gWt.9AOuIFMz8f0PPdc.RcEmuvhj7gz6dUnB7D2.vqCJaMDjohK', 'bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus', 'scrimpeo', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Chrystal', 'Dilke', 'cdilkep@cisco.com', '251-940-0947', '$2a$04$vIDESWFwSEaX9nIeuPyr7.k7qlHPo9oU4N/ig2LkNnj0EetmEcFYu', 'et tempus semper est quam pharetra magna ac consequat metus sapien ut', 'cdilkep', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Sidonnie', 'Skough', 'sskoughq@addthis.com', '176-621-3625', '$2a$04$tYzjShhR9A4MoiCUGaANUO47vX8RcCR.DO2Axc7gQo0T.jphsXgxW', 'erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris', 'sskoughq', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Chelsy', 'Spavon', 'cspavonr@nsw.gov.au', '355-679-8011', '$2a$04$l3S77LwCz0KkRygeZB75o.BWrqbmqx6yhWMlpsaL7v0sF5vXjYMc.', 'pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean', 'cspavonr', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Wayland', 'Rylstone', 'wrylstones@spotify.com', '759-419-2274', '$2a$04$WrAPLZXO0Gaj4lQ68AtsiuVvapYv.nMy4AlS0tUjSjhRzU16tAb5q', 'placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit', 'wrylstones', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Lucinda', 'Degoix', 'ldegoixt@washington.edu', '917-776-3478', '$2a$04$Mr0yb/hMJ8mw6XqfatvfAOnggcQQr.AE4vYaiKfSGGPnV5SM6vVPW', 'ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel', 'ldegoixt', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Stacy', 'Cosbey', 'scosbeyu@independent.co.uk', '893-455-1284', '$2a$04$tYq11l6RU0Wly/WNY9d61.DvTqJlBz8R3jj0lj0/ATynLx.smjy0.', 'luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida', 'scosbeyu', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Titos', 'Kingdon', 'tkingdonv@g.co', '468-893-0509', '$2a$04$gG4sS.NYb0aWE7ut.5jH8.uHnKq.rwG6mpYZgyc1fNuqAlgzEK65u', 'erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec', 'tkingdonv', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Hill', 'Blanchette', 'hblanchettew@examiner.com', '901-371-1984', '$2a$04$GfRyLTeOBDT55LrdjisDG.Rjp3E9Qy2sWfmLDJLvYxnzj6Al0g9xi', 'justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio', 'hblanchettew', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Edie', 'Tolchar', 'etolcharx@marriott.com', '676-814-1145', '$2a$04$NOX.pqUnia1sSQzqhmUq9OuzUgIOKf06vXtvBcibOJNYjg3v2/Q6y', 'elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat', 'etolcharx', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Helenelizabeth', 'Frensch', 'hfrenschy@baidu.com', '591-199-7042', '$2a$04$WzwDGJycs.oSgcdJbXQ8R.ZB962cDnsAty6ViOE.o/RRIYhIaJ6h2', 'amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui', 'hfrenschy', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Randa', 'Davidsohn', 'rdavidsohnz@wikia.com', '283-555-1131', '$2a$04$C.2Ghpf1f3DLG85NBMSdGeZu6UBryLeTrgD2hizAy8DBf3dna.uzS', 'vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend', 'rdavidsohnz', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Katharina', 'Caldicott', 'kcaldicott10@zdnet.com', '678-734-3228', '$2a$04$DGP7a6Uh3Xca2ES522KROOApFtj5MseycOf2.l8HIFWjljnfDxPY2', 'ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus', 'kcaldicott10', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Hobie', 'Andrzejak', 'handrzejak11@dailymotion.com', '766-768-9556', '$2a$04$HcKqzP98TsexBZ2E29ldheXbrhiOP6IcKCR6GHXZHYaM6rK6iBzhq', 'aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia', 'handrzejak11', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Benedicto', 'Walesa', 'bwalesa12@sakura.ne.jp', '743-807-2089', '$2a$04$nuboUlVHiTQqzdNKtwuG6OILl35zKgTa1k30xn.KamhOpttp7lm7O', 'donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi', 'bwalesa12', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Gwenore', 'Wallbrook', 'gwallbrook13@redcross.org', '541-522-5921', '$2a$04$SrtjvcM0V9ZVGiBlVVaaEuMCVHmIFU6tLP/nkv6bsGfQsO8ARssRe', 'ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est', 'gwallbrook13', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Trula', 'Grimsdith', 'tgrimsdith14@washingtonpost.com', '342-930-6445', '$2a$04$3imXrI5W51iq2Nq/BqtixOqxoi85NkB3ePx0iwi2Jyn1yuWEJoadG', 'justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare', 'tgrimsdith14', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Ingra', 'Barock', 'ibarock15@privacy.gov.au', '635-495-0949', '$2a$04$LMgaoLxAmHv/KE/9.8lYD.tOie3rlJzobHP805KVjIfirlUcirO.S', 'purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut', 'ibarock15', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Terrell', 'Garshore', 'tgarshore16@elpais.com', '270-712-8935', '$2a$04$UDML7TGfP9FBZhI1cLy9pu4pA.JETJ.Lxhi1.rZ9rC1k84Do0wEU2', 'nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla', 'tgarshore16', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Jacklyn', 'Tewkesbury', 'jtewkesbury17@theatlantic.com', '550-767-7791', '$2a$04$r1bX/EKF1/rQq1KQAgi2H.XnFAyUBtUdd1nsWJQ/5t3KrUbtJMBYy', 'ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi', 'jtewkesbury17', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Lula', 'Arnoldi', 'larnoldi18@yale.edu', '138-704-1615', '$2a$04$FZOC7VZLrqlbr4PUrQ48DeZcJhOQVt5QHEPQ1NY.L7i22Sx9UCu2W', 'praesent blandit lacinia erat vestibulum sed magna at nunc commodo', 'larnoldi18', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Lina', 'Kielty', 'lkielty19@about.me', '729-978-1320', '$2a$04$StCf5ZPufArFbMMLhRhbaewsRZDsg04vVOr2aXqVco0sAq.HmQ9Vm', 'viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec', 'lkielty19', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Barbie', 'Gerraty', 'bgerraty1a@dyndns.org', '734-508-1086', '$2a$04$w1E17aZgBNQ/nmQH8Q9bEOchozpJtFhP1pqC.XkEABfbdsjb3wdu6', 'gravida nisi at nibh in hac habitasse platea dictumst aliquam', 'bgerraty1a', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Robinson', 'Larcier', 'rlarcier1b@t-online.de', '303-179-2702', '$2a$04$QSSLF/ZdCkzRvGuh2XPxUuAIcqZigvViRjisUT.jquuebHGN2apfS', 'turpis a pede posuere nonummy integer non velit donec diam neque vestibulum', 'rlarcier1b', true);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Randie', 'Malia', 'rmalia1c@usnews.com', '243-959-7014', '$2a$04$DNpa9C9251wh/BLqK27WaeTdaV8cTtnnMguOFMhewiU7WCcsYFa02', 'curabitur in libero ut massa volutpat convallis morbi odio odio', 'rmalia1c', false);
insert into advisors (firstName, lastName, email, phone, passwordHash, profile, username, activityStatus) values ('Cora', 'Haglinton', 'chaglinton1d@tmall.com', '892-780-2319', '$2a$04$EJz2ILXjbwR7FdlOPkAMQeu6EfKxU8sMk5bJ677awq5cSo38aL5mG', 'urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat', 'chaglinton1d', true);

-- Inserting sample data for students
INSERT INTO students (firstName, lastName, email, phone, passwordHash, username, advisor)
VALUES
('Ellie', 'Ryder', 'ellie.ryder@email.com', '555-0201', 'hashed_password_4', 'ellieryder', 1),
('Bob', 'Williams', 'bob.williams@email.com', '555-0202', 'hashed_password_5', 'bobwilliams', 2),
('Charlie', 'Davis', 'charlie.davis@email.com', '555-0203', 'hashed_password_6', 'charliedavis', 3);
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Alie', 'Barok', 'abarok0@springer.com', '760-710-7520', '$2a$04$rjBTNUoKJJWe8i5hPO50V.YLNEyCpoU2LR84rfm8p.NJvL5t4mwPW', '#2cb', 'sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue', 'abarok0', true, false, '13');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Lock', 'Pocklington', 'lpocklington1@oakley.com', '895-880-2841', '$2a$04$X2irfQrJRnymiMe/oMlYXekMUTHDuSuxynSWz63dFT5kIaGn2Ov5S', '#681', 'nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam', 'lpocklington1', false, false, '47');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Edgardo', 'Trevaskiss', 'etrevaskiss2@jigsy.com', '780-824-7338', '$2a$04$2DywSFqzlQFXOLc4VUy08eStF3iRh2xMLEUm/QDb.G5xsd.KICv0S', '#8db', 'primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra', 'etrevaskiss2', false, true, '32');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Nana', 'Staniland', 'nstaniland3@istockphoto.com', '260-704-7290', '$2a$04$JlsKtS5aNbFpgu2AK/eTYuatEhM9UlgKOaLNByWHXCiF1tX3EaPMS', '#1fa', 'diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac', 'nstaniland3', true, true, '18');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Averil', 'Killingsworth', 'akillingsworth4@a8.net', '162-301-3563', '$2a$04$hHm2rPG2vcSGKq/v.q.wHOa52dcQfytH3KsHmEq40syz7a3.0BZrC', '#ee6', 'morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate justo', 'akillingsworth4', false, true, '19');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Reine', 'Kilmurray', 'rkilmurray5@t-online.de', '104-149-9187', '$2a$04$uCUWlBqgC1eY0Qx54mt6weeqUQMsp49nm5Uj./dJSnD/RJft5p0Ne', '#111', 'donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam', 'rkilmurray5', true, true, '3');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Ezmeralda', 'Reynold', 'ereynold6@google.nl', '467-786-7318', '$2a$04$nokAvcFQ2utqNGJfm1qJHOD8HmCgblEPU0T3Xb5Zes5X7Omz2m7r.', '#725', 'accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec', 'ereynold6', false, false, '7');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Amitie', 'Keeney', 'akeeney7@squarespace.com', '669-886-2602', '$2a$04$G1z2HcOiDYaH2cUSARfq1.u/4EAcLyN6ZZ69k03cj9jTX1uUW0Ib.', '#e10', 'justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse platea', 'akeeney7', false, true, '37');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Dedra', 'Antham', 'dantham8@lycos.com', '131-151-3313', '$2a$04$2TMljgthsBmf8w6T2BlgpebctdcAndrfXdVd.pqnhazuUsz.jEMC6', '#112', 'id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas', 'dantham8', true, true, '30');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Pietro', 'Broadberry', 'pbroadberry9@studiopress.com', '779-490-2313', '$2a$04$OjTHA.dbHsvqAXN6tDPE.eEN6ByMgzB4iRQOroLn.rTrU95O9GUYG', '#d89', 'vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum', 'pbroadberry9', false, false, '43');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Gery', 'Print', 'gprinta@google.fr', '454-333-2044', '$2a$04$HYvQArgUhl/Jn6tULjyOOeBgaZGD.5oU4Y/ZIjUSNkHIIHwuDByda', '#f48', 'rhoncus dui vel sem sed sagittis nam congue risus semper', 'gprinta', true, true, '10');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Nydia', 'Withur', 'nwithurb@ycombinator.com', '706-805-9088', '$2a$04$a86u.Hu1iXX5dcZT3.EAkuy28swIeoxo0eb5Cw2qrqQQhnRcGp1GG', '#285', 'parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id', 'nwithurb', true, true, '1');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Kacy', 'Currom', 'kcurromc@slideshare.net', '442-713-2471', '$2a$04$h3YNh5Y6z9cKeqLA9haBr.sgpRq7lpjOoVpki72B8FZIo2mpVTAyG', '#ede', 'magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum', 'kcurromc', false, false, '28');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Layney', 'Belly', 'lbellyd@ftc.gov', '657-725-0204', '$2a$04$L0E2xNPJpyMBKIxYT1Nbc.5DOU5NUyeo4EGw6l2gYwM9MSkoeN93S', '#6b6', 'orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate', 'lbellyd', true, true, '6');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Zenia', 'Batterson', 'zbattersone@omniture.com', '963-715-6763', '$2a$04$.WdSJJBHh39tBF44sTaGIuHFv74VOvmf8TMdabtGRw6FK3Fxp1OrC', '#1b8', 'ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere nonummy integer non velit', 'zbattersone', true, true, '9');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Thaddeus', 'Pagnin', 'tpagninf@blogspot.com', '244-174-2949', '$2a$04$xX5M5u.o5WHadOZsFqfnC.5xZj2H6e3EmRcUdR6PonHuPV/cbT5sy', '#597', 'duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede', 'tpagninf', true, false, '48');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Bernie', 'McGeachey', 'bmcgeacheyg@mail.ru', '129-810-0653', '$2a$04$J22dD5sHHvrTiijUyWDtjOXHcur0.xahXzWJ3suVpvBT0jU7dkNw2', '#bcd', 'luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat', 'bmcgeacheyg', true, true, '15');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Benjamin', 'Dell', 'bdellh@flavors.me', '962-916-3051', '$2a$04$qXvp6dZ2H3CrHpZUrTxuUebPGP2/1tY2ZUx.92T0ZueatXl7TyjD6', '#ffd', 'nunc purus phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id consequat in', 'bdellh', false, false, '36');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Shawn', 'Stive', 'sstivei@storify.com', '379-740-3036', '$2a$04$vprZuuEATRARltQsB4aDue0so9OAJNDp0Tde1DfvPyeHPyDrkJSNy', '#68a', 'ac consequat metus sapien ut nunc vestibulum ante ipsum primis', 'sstivei', true, false, '26');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Gregg', 'Picheford', 'gpichefordj@techcrunch.com', '205-535-6153', '$2a$04$/X75CmN4HO1hPZBz0tI7YepGf3LGULtIC4a7KvvrQkjx77QUyowHa', '#dc3', 'aliquam quis turpis eget elit sodales scelerisque mauris sit amet', 'gpichefordj', false, false, '21');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Valenka', 'Bartleman', 'vbartlemank@cloudflare.com', '600-191-1841', '$2a$04$z9TO/sI.q5oo/9pGuv.uherOAtyFjiHN4tm0J0hiShYZvEQ13Cbae', '#ab7', 'varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus', 'vbartlemank', false, true, '17');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Krissy', 'Van Zon', 'kvanzonl@github.com', '997-541-4116', '$2a$04$BA6vJmeZUar.QRnNl/bHpeZnKXaP3GrXFGzoIaXhsLWpJTHr77riG', '#006', 'vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices', 'kvanzonl', true, false, '16');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Jacki', 'Feldmesser', 'jfeldmesserm@oracle.com', '931-835-5484', '$2a$04$mfRE5RH2kJVORyJzTTY1oeZxnzTw3bfwJx4T03tLEnyxjDohijL/O', '#89b', 'non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim', 'jfeldmesserm', true, true, '11');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Alicea', 'Moisey', 'amoiseyn@salon.com', '661-918-1667', '$2a$04$ZJjtjCB2SXbCOrKXu5BfRee4E4naaV4fha3ta2BKKqRvLGRsoAzXK', '#862', 'vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus', 'amoiseyn', false, true, '38');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Granthem', 'Druhan', 'gdruhano@mlb.com', '496-735-0938', '$2a$04$2GA8aTMkAAv9.QfXkzA4UuM5QNAo7YuQubROQ8ajJKenSH5ycKJ1y', '#bbb', 'donec semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed', 'gdruhano', false, true, '35');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Piggy', 'Hurdedge', 'phurdedgep@hugedomains.com', '546-874-2418', '$2a$04$LkDkb/WnXth8P7u0gqswJ.Zu5a8wCOabRxXM/HPPEryVjCMD0kuui', '#263', 'in porttitor pede justo eu massa donec dapibus duis at velit', 'phurdedgep', false, true, '8');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Caril', 'Demetr', 'cdemetrq@umich.edu', '761-225-0141', '$2a$04$cImgY5bjD8Lk7djCdR8cGeGURZeRJt3M/GYG6vGS.3Tm.RKQFyRwm', '#79f', 'nec nisi volutpat eleifend donec ut dolor morbi vel lectus in', 'cdemetrq', true, false, '27');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Ulrika', 'Thames', 'uthamesr@oaic.gov.au', '776-807-9447', '$2a$04$gg.R6zgLvE6RC7MiLitam.fOT5.cE96wKrJZSVnjdINlpRAzscVuC', '#cf2', 'in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus', 'uthamesr', false, true, '40');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Tamas', 'Iorillo', 'tiorillos@state.gov', '952-218-4696', '$2a$04$/0yX7N147paVA.6pWfZRz.cjuqmsjhAxXjXiK.M87a1bCCbADG5Cy', '#5fe', 'odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat', 'tiorillos', false, false, '45');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Janie', 'Ouslem', 'jouslemt@ibm.com', '714-267-9379', '$2a$04$PHQVIiP/tOzC.APRlXTm0eMMoE5jSJfCiRrL/UsKxRGjLohT6rYfG', '#134', 'faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor', 'jouslemt', true, true, '23');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Melvin', 'Vasentsov', 'mvasentsovu@vistaprint.com', '771-490-4516', '$2a$04$PXdmylX7VxMaWcxao/2HNe3fn/UX.VNu.ubOECUrSdu26arIMr9H2', '#9d2', 'at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget', 'mvasentsovu', true, false, '49');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Marwin', 'Warstall', 'mwarstallv@rediff.com', '930-648-4228', '$2a$04$pHVLkMru.M9mX/fU91/G5emH0ZgsicYfgadu6ZYI0R/RSNhHJzCOC', '#3a4', 'interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae', 'mwarstallv', true, false, '24');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Brade', 'Quaintance', 'bquaintancew@livejournal.com', '342-185-0671', '$2a$04$DHlgRDJ8keSXXoMD1gBjV.1IzVbMHdOxUjMIc/vhmX95h4RRR83nK', '#768', 'in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse potenti', 'bquaintancew', true, false, '46');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Katerine', 'Scholtz', 'kscholtzx@twitter.com', '171-537-4130', '$2a$04$Nf5RhHmOd/WX8BD.0da06.thgxGfOqJIcyUOmvUlhIg6RYjeAeFSy', '#302', 'lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed', 'kscholtzx', false, true, '25');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Eddy', 'Orgee', 'eorgeey@omniture.com', '448-945-7893', '$2a$04$IhgyAk4hiFwBTUOphqvAkezmCTZrgyKcoEq/XAu0i3fX9/WVglsqO', '#1ce', 'iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla', 'eorgeey', false, false, '39');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Pamella', 'Gepp', 'pgeppz@so-net.ne.jp', '919-725-0771', '$2a$04$p6fiNVRJUoL1ebute1oHMuW6/gWSnEpuAFH1GjO0eVHE1Wa8QSbx2', '#ba9', 'eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl', 'pgeppz', true, true, '44');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Hillary', 'Crips', 'hcrips10@home.pl', '698-299-7498', '$2a$04$QNM9svkl0a4sP1bBDJ.sWe3b2PzkQDVZT3ZEuwRb1Qr3tzw5EOsn6', '#aa3', 'luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien', 'hcrips10', true, false, '33');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Cassie', 'Fotherby', 'cfotherby11@phoca.cz', '712-233-5636', '$2a$04$2nqfuz9zFxQI3Ah1RklQy.IPU/gDdLyi2dXpt.tSPL1.XslW49Q.2', '#0d1', 'vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient', 'cfotherby11', true, true, '29');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Emilio', 'Natwick', 'enatwick12@state.tx.us', '669-299-3224', '$2a$04$xTI7PKAnggBEhQ9eFVTMC.yzibq9.aEwzquTIwDP6X6l8jvIF0JMq', '#5f2', 'neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean sit amet', 'enatwick12', true, false, '12');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Nat', 'Cheverell', 'ncheverell13@wunderground.com', '765-318-0521', '$2a$04$f429AGnfKhE2jRyqZCbxAuChkjjJ1pt3BHSnuAVWngN.6r0OKV57m', '#c34', 'libero ut massa volutpat convallis morbi odio odio elementum eu interdum', 'ncheverell13', false, true, '5');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Cathrine', 'Bridgnell', 'cbridgnell14@sciencedirect.com', '515-630-2168', '$2a$04$zN1HiieZZDDINkPRl1ydXebcci0tkaI0orFl51HaJijJ3/sbFAWFS', '#710', 'dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum', 'cbridgnell14', true, true, '34');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Bev', 'O''Codihie', 'bocodihie15@prnewswire.com', '131-759-7963', '$2a$04$RsXUE6cyxplr6IOwyQcd.eo0yo6zS4nNujFDkQfA8Ec.PNu/iaP1G', '#28f', 'id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet', 'bocodihie15', false, false, '4');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Elayne', 'Wrightim', 'ewrightim16@nytimes.com', '895-702-9698', '$2a$04$p.oQVDoXrzq6o58XQz4JYedLoO5jMzRe5QBDB0icw7IiT2IIHlOqK', '#313', 'ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec', 'ewrightim16', true, false, '50');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Nellie', 'L''Homme', 'nlhomme17@huffingtonpost.com', '722-740-4140', '$2a$04$HMFcTqjF0HzRzEcoCq08euYSWO37G1FdDS0V9a3SyA6KEQPTUuFaa', '#b19', 'ut suscipit a feugiat et eros vestibulum ac est lacinia', 'nlhomme17', true, true, '42');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Andrus', 'Linebarger', 'alinebarger18@whitehouse.gov', '372-161-2206', '$2a$04$4ih40bRDIcfRBHJQgYTw.eyY5MB1OQZyX18ZqKxicdMXnswZ7nBUa', '#ad9', 'tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum', 'alinebarger18', false, false, '31');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Percival', 'Lisle', 'plisle19@tinypic.com', '708-978-3982', '$2a$04$JmHBmN.ZYTLsJOLgl5ewrub8uQ0Tt5yxMpSqsYBq17ZvKRnIzfyyC', '#b46', 'eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium', 'plisle19', false, false, '20');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Ginnifer', 'Madine', 'gmadine1a@flavors.me', '188-874-5662', '$2a$04$ms7cuoBZk7y2W2fYjGXNmeDfkrxOfjNTDaJNz35oP6Xjl5TnFuunK', '#367', 'in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut', 'gmadine1a', true, true, '14');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Meir', 'Dericot', 'mdericot1b@yale.edu', '817-357-0905', '$2a$04$Mb.LEEzl0VWoc0is6u7V0.e5jdLq5QyWO5yxbIWdgkC/Ge.T1q0WC', '#c08', 'congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci', 'mdericot1b', true, false, '2');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Wanids', 'Chadbourn', 'wchadbourn1c@newsvine.com', '679-639-4687', '$2a$04$jCtMFDHvKz9rya9O7m6EEua4kmnj4GwV9DhQkJIzRg9p900t8f1LW', '#459', 'dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque', 'wchadbourn1c', false, false, '41');
insert into students (firstName, lastName, email, phone, passwordHash, intro, profile, username, activityStatus, statSharing, advisor) values ('Jay', 'Joire', 'jjoire1d@shinystat.com', '811-624-3473', '$2a$04$.KiqDHSfA8Czo4JtpFAWne13cMc5MrZRQBZ38fVmMYT34SRCE6Wau', '#074', 'quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin', 'jjoire1d', true, false, '22');

-- Inserting sample data for student_stats

insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (1, 0.81, 'Female', 'Menominee', 'QMF for Windows', 2, 2, 1, 'MorbiUt.doc');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (2, 1.02, 'Female', 'Black or African American', 'Capital Equipment Sales', 0, 0, 3, 'Et.avi');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (3, 1.24, 'Male', 'Cheyenne', 'EOC', 4, 0, 0, 'Ultrices.mpeg');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (4, 2.08, 'Male', 'Chippewa', 'Purchase Management', 4, 4, 4, 'IntegerPede.xls');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (5, 0.87, 'Male', 'Dominican (Dominican Republic)', 'Roth IRA', 2, 1, 4, 'NullaSed.avi');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (6, 1.08, 'Female', 'Melanesian', 'Make vs Buy', 2, 1, 0, 'ElementumNullam.mp3');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (7, 0.28, 'Female', 'Black or African American', 'Enzyme Kinetics', 2, 1, 3, 'VelSem.avi');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (8, 0.17, 'Male', 'Alaska Native', 'PDM', 3, 3, 3, 'Justo.ppt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (9, 3.99, 'Female', 'Taiwanese', 'GPS Applications', 2, 4, 4, 'Turpis.txt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (10, 0.64, 'Female', 'Native Hawaiian', 'Gospel', 2, 1, 1, 'Elementum.png');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (11, 3.91, 'Male', 'Polynesian', 'xCP', 2, 1, 2, 'Non.avi');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (12, 2.21, 'Male', 'Colville', 'Olfaction', 1, 2, 2, 'EtMagnisDis.mov');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (13, 2.34, 'Female', 'Apache', 'EGPRS', 2, 1, 4, 'DonecVitae.mov');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (14, 2.28, 'Female', 'Alaskan Athabascan', 'Warehousing', 4, 1, 4, 'CongueEgetSemper.mp3');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (15, 2.04, 'Genderfluid', 'Native Hawaiian and Other Pacific Islander (NHPI)', 'Fashion Design', 2, 1, 0, 'MaurisNon.tiff');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (16, 1.83, 'Male', 'Japanese', 'eEmpact', 2, 2, 0, 'PosuereNonummy.ppt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (17, 0.06, 'Female', 'Navajo', 'IS-IS', 1, 3, 0, 'QuisOdio.png');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (18, 1.94, 'Male', 'Comanche', 'Voiceovers', 2, 3, 3, 'AliquamLacusMorbi.xls');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (19, 1.21, 'Female', 'Cheyenne', 'Wufoo', 2, 1, 2, 'EstLacinia.avi');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (20, 0.96, 'Male', 'Cree', 'DWH', 4, 0, 3, 'Vel.tiff');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (21, 0.77, 'Female', 'Iroquois', 'Pharmaceutics', 3, 2, 3, 'AFeugiatEt.txt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (22, 3.47, 'Female', 'Black or African American', 'Bodywork', 4, 1, 1, 'NullamOrci.ppt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (23, 1.13, 'Female', 'Alaska Native', 'Gyrotonic', 2, 3, 0, 'UrnaUt.doc');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (24, 2.19, 'Female', 'Potawatomi', 'Core Banking', 4, 4, 4, 'Sed.ppt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (25, 2.94, 'Male', 'Cherokee', 'z/VM', 4, 1, 1, 'PellentesqueVolutpat.mov');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (26, 1.11, 'Female', 'Seminole', 'CDL', 1, 4, 0, 'IpsumPrimisIn.mov');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (27, 3.29, 'Female', 'White', 'PXI', 1, 1, 0, 'EgetElit.mp3');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (28, 1.63, 'Male', 'Puget Sound Salish', 'Solaris Zones', 1, 3, 3, 'PhasellusSitAmet.ppt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (29, 3.53, 'Female', 'Chippewa', 'Linux', 2, 2, 2, 'LigulaSit.xls');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (30, 0.98, 'Female', 'Dominican (Dominican Republic)', 'XML-RPC', 4, 2, 1, 'Ac.jpeg');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (31, 2.8, 'Female', 'Peruvian', 'Fences', 4, 2, 0, 'OrciLuctusEt.txt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (32, 3.67, 'Male', 'Houma', 'ATP', 0, 3, 0, 'SitAmetNulla.avi');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (33, 2.53, 'Female', 'Iroquois', 'Voiceovers', 0, 0, 1, 'Ut.ppt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (34, 1.34, 'Female', 'Chippewa', 'Zoo', 3, 3, 3, 'Sollicitudin.xls');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (35, 2.03, 'Bigender', 'Aleut', 'SSAE 16', 1, 4, 3, 'In.txt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (36, 3.77, 'Female', 'Chinese', 'Virtual DJ', 2, 2, 1, 'VulputateUtUltrices.pdf');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (37, 0.87, 'Female', 'Bangladeshi', 'MDL', 1, 0, 4, 'CurabiturIn.tiff');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (38, 0.54, 'Male', 'Chinese', 'Statistical Data Analysis', 2, 2, 4, 'LiberoNamDui.avi');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (39, 0.91, 'Female', 'Colombian', 'IGOR Pro', 1, 1, 3, 'PotentiInEleifend.avi');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (40, 3.6, 'Female', 'Dominican (Dominican Republic)', 'AAC', 1, 4, 1, 'AcNibh.ppt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (41, 1.62, 'Male', 'Asian', 'After Effects', 1, 1, 2, 'Posuere.ppt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (42, 2.49, 'Polygender', 'Spaniard', 'Wicklander-Zulawski Interview &amp; Interrogation', 2, 4, 3, 'MontesNasceturRidiculus.avi');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (43, 1.42, 'Female', 'Alaska Native', 'GMP', 2, 0, 4, 'InFelisDonec.mp3');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (44, 0.78, 'Female', 'Eskimo', 'Jet Fuel', 0, 1, 1, 'LacusMorbiSem.mp3');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (45, 2.09, 'Female', 'Fijian', 'RPT', 4, 3, 2, 'Posuere.xls');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (46, 0.22, 'Male', 'Latin American Indian', 'Ehcache', 0, 4, 4, 'EtUltrices.tiff');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (47, 3.42, 'Female', 'Bangladeshi', 'XUL', 2, 4, 3, 'Sed.pdf');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (48, 0.19, 'Female', 'Salvadoran', 'OTM', 1, 0, 0, 'NibhInLectus.ppt');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (49, 3.73, 'Male', 'Filipino', 'PFP', 4, 1, 1, 'IntegerTincidunt.jpeg');
insert into student_stats (studentId, gpa, gender, ethnicity, major, numCoop, numClubs, numLeadership, resume) values (50, 3.05, 'Female', 'Korean', 'IQ Navigator', 2, 0, 3, 'AliquamSitAmet.mp3');

-- Inserting sample data for companies
INSERT INTO companies (companyName, repEmail, repPhone, website, passwordHash, activityStatus)
VALUES
('TechCorp', 'contact@techcorp.com', '555-0301', 'www.techcorp.com', 'hashed_password_7', 1),
('MediPlus', 'contact@mediplus.com', '555-0302', 'www.mediplus.com', 'hashed_password_8', 1),
('Innovate Ltd', 'contact@innovateltd.com', '555-0303', 'www.innovateltd.com', 'hashed_password_9', 1);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Babbleset', 'uellerby0@squidoo.com', '703-342-9284', '', '$2a$04$1Xjv3v49cTtRz9I5uUDquuIYrGrae3EzMoV9ffXJoN4MhCMEPTs7.', '#07d', 'arcu libero rutrum ac lobortis vel dapibus at diam nam tristique tortor eu pede', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Tazzy', 'ctax1@w3.org', '649-462-9714', '', '$2a$04$evptEHtIRBQJjwd0hirXtO5PRYSAwUTQRvJaP1AB7RjvtB5eImFNu', '#9f4', 'integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Youtags', 'rducastel2@vistaprint.com', '729-941-2226', '', '$2a$04$w.XcYqEAOwdKq9Lwq64z0.sMVV6I3R7qzqeDB3Om2N0tta6lSiEXi', '#7eb', 'morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Lajo', 'aclacey3@clickbank.net', '233-886-8169', '', '$2a$04$JNsO4ZrMBloKH34sQyzbfOylJ9.9eaxHSgxc/UeIdVCPHMhi93oLu', '#279', 'lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Wikizz', 'senever4@last.fm', '727-962-9798', '', '$2a$04$JXVtOJ3H7VNGM14D37HlQ.sTaTKGhoLF.teIrnJ22hxNZTaJhEeHi', '#6ac', 'in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Snaptags', 'bnorthern5@alibaba.com', '864-613-4033', '', '$2a$04$X99ml4WWCimwW3t136tMduSySrvjPKCoEkmavC.A3D3PXmTU4fO2i', '#897', 'nisi volutpat eleifend donec ut dolor morbi vel lectus in quam', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Skalith', 'jaloway6@youtube.com', '338-472-4816', '', '$2a$04$pBKPSh91kDK3TOaS3HOXDeUqK5sI.Ou8HJPnTnAwRmrL.DI/6Cklm', '#e2a', 'proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Rooxo', 'gwheatland7@acquirethisname.com', '407-168-0013', '', '$2a$04$A7V7cUE0l8ZN/p9GuHIiFesSmv0pxxSVF014bqLrHefH7nGhBe90.', '#e06', 'eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Mydeo', 'idickey8@si.edu', '977-603-0150', '', '$2a$04$LCOlzpGB3Vts2r6Mn5SDnOiNj1BvqCAMbxawaDhxEnJYSgMqNxYh6', '#243', 'porttitor lorem id ligula suspendisse ornare consequat lectus in est', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Skipfire', 'lbolding9@desdev.cn', '326-359-1235', '', '$2a$04$abq55ZAlol0ZVo3tYYC6v.8iC0MvpUZ4XXxud0t/NCDkULcX5xR9K', '#2f8', 'accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Tagtune', 'kfavella@nationalgeographic.com', '481-596-3706', '', '$2a$04$DXFTVufWHUmh/xk1r4UtwO9OKphCAl4JouxVHbIY3AlJDjGL4kA4O', '#f96', 'semper sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Yabox', 'asiddonb@washingtonpost.com', '576-248-3838', '', '$2a$04$5zG/VoyXqwYcfZFNbm0s/uLLNH4U0ORtwPO3wXBrhBoJWrsqxZSc.', '#e4a', 'lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Flipbug', 'dpibworthc@dion.ne.jp', '685-787-8883', '', '$2a$04$9864X/Oowcv7Hfby7qMkq.6aG4Xwz0p8rVMkhHtDcM7onGGk8bVLC', '#127', 'felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Devpoint', 'mivashinnikovd@over-blog.com', '713-860-6724', '', '$2a$04$LTmORMYsYRrxp23yqwIxXO7El.FsJbmC0OSH8EYIy6UWqWGTgFRrO', '#327', 'magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Cogilith', 'wjuliffe@360.cn', '620-777-5160', '', '$2a$04$L4QTZrqFakzKYpd4v/ZmTuw.9gmp2RHwRTjjXIa79fRyeu89WmtfG', '#07a', 'sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Gabcube', 'mhovendenf@technorati.com', '331-246-7560', '', '$2a$04$IhvzPA5xZ88Af.JcH95XE.PNNWX9dZ5Joen/Ts5wCK3DiFTjv/C3C', '#7a9', 'donec diam neque vestibulum eget vulputate ut ultrices vel augue', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Kwilith', 'jmiguelg@bravesites.com', '414-889-2085', '', '$2a$04$NEXu7jqJ.tFy/Dho7DVJMehjHmWky238O4vidDjl71obb993XUwg2', '#b9a', 'at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Zoozzy', 'aandrissh@marketwatch.com', '798-395-4378', '', '$2a$04$jZE.i5Dv7fEqb1Aox1H51.aYo/GYq20RWm7gxqWwMEAJrbR8kVBQm', '#e24', 'in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat non pretium quis lectus', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Kwilith', 'lgeraulti@domainmarket.com', '895-594-3698', '', '$2a$04$melVJZ4W5O09FoDqFg9Yu.nusRqenVnncOIwI7u0uR2jtPc1Ngo3a', '#f0e', 'elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Skyba', 'sparrissj@cornell.edu', '165-727-8092', '', '$2a$04$MghT8MIbK8EJ/EZ1kzQFtuC6PW0bumOd4lGQ1ZqENBs0ceSFmOJF.', '#aea', 'quam sapien varius ut blandit non interdum in ante vestibulum ante', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Zooveo', 'bklampkk@xinhuanet.com', '167-386-0709', '', '$2a$04$H/A8L6jnMbMSlNXzP6tV/.BWevxYg3KRRmp4JofbUS8crdxLUNz9y', '#bcd', 'semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Gabspot', 'mshoutel@hao123.com', '879-391-2809', '', '$2a$04$1hquep2x6hcUKo1L4pBVGOf1CQwMUd3cfSvBZe92mRmaKK3hOzEm.', '#75e', 'amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Babbleopia', 'zfippm@digg.com', '539-736-3268', '', '$2a$04$XEJRXe3WjCVq31k9j.Ya7uBa/PlUTh26qelasK5QOAJB4mO0IB9b.', '#6c8', 'quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Mydeo', 'rconnewn@1und1.de', '933-636-4703', '', '$2a$04$4dNdMsb201Fd2hQdSQJn6OIQ/Kp/9MHourAa5MZB/tMFEihIMxTtu', '#8d8', 'metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Eabox', 'mcamino@soup.io', '277-973-5544', '', '$2a$04$b2NBlU8Gae2yp6MpxwI9BuRj2iRjgx.7rqRx0hiXnOnJ5GEJ9bDDq', '#65c', 'odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Lazzy', 'bpaulingp@hostgator.com', '297-729-3924', '', '$2a$04$eTyJZ4T7dEUJxwX31hPaSe/7JUi./I0.Y/3Vjo6WEjFvsRQssP3Ku', '#13d', 'magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Jatri', 'bprazerq@cafepress.com', '522-761-4147', '', '$2a$04$sQ8o8z3ahR8sYUn1/3OkHOtj6QJkcNFDLxhtkO2CM9ViZsgtD5QmG', '#7fa', 'massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Dablist', 'terdisr@g.co', '655-472-6265', '', '$2a$04$i.UroUs0v/rDrUBRBF65Xe7LA2KoQsJ2t2WdDz4sfmq7jCL8viHUy', '#ceb', 'sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Thoughtbeat', 'ccrowthes@newsvine.com', '243-939-0999', '', '$2a$04$JftZLKuoISPuoLXk6vH8bupT1T8buzs.2dUbUoP2So4P6ChQ06Dwa', '#8d4', 'ut massa volutpat convallis morbi odio odio elementum eu interdum eu', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Rhynyx', 'zgiorgit@ucla.edu', '687-916-5620', '', '$2a$04$6kEDHCe5EDgbMmgwzfOvbeOjum1FasuybOlOMgV91RyTakDi2.u7i', '#795', 'sapien a libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Podcat', 'lmonkemanu@comcast.net', '973-245-4856', '', '$2a$04$0vb1Ld9bF7aAb2E/wDCX7.yOsn.YOa45mnXWZOt0vFqRSbPpo/Cri', '#1cc', 'proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Wordtune', 'cpicfordv@cisco.com', '641-290-3676', '', '$2a$04$xMqrJ5m6Xudp1gJz5.44fe/p6YSTssWxhCLEfMSpEU5nSZ8kw89x2', '#fc4', 'rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Centimia', 'bsabbatierw@usgs.gov', '555-563-8042', '', '$2a$04$uOlx9inHLCtehUwFif8UQuxi42sckenaWJbx9QIA7n81Ofy6t3j8S', '#5b5', 'at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Zoonoodle', 'wscotchbourougex@vimeo.com', '184-370-4329', '', '$2a$04$3QLciV.deYT3JWKa7iUXrOmG6Z.Z75yxRJEq2uzy52sdR2YQrRjc2', '#b2c', 'leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Reallinks', 'csayley@boston.com', '738-436-4787', '', '$2a$04$3S6NK8FHbPz/5HBrdQtRou.KGQf4wLfH2U9dDJJlGs.g9mIOPX8ei', '#047', 'nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Brainbox', 'bboyettz@example.com', '574-495-7407', '', '$2a$04$nuucfs6.QCPgr4wqsJG31eXm1IMB26kYBVoitYu2OCx16CUyNBb9G', '#eba', 'elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Vinte', 'araynard10@imdb.com', '149-915-9117', '', '$2a$04$8pI1RuHNYkb/MUEIkT3c0.f3khEywlHmXlEkdvi/nW75fZ4bgdG6O', '#efa', 'id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Quaxo', 'vspatarul11@google.de', '825-713-0328', '', '$2a$04$pm8ZJ8fw1ueherimo.9X.eDnm7KBUcT79WUoajPuXxuV.ZAlAtRFe', '#dcf', 'volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Eimbee', 'sgettins12@printfriendly.com', '372-191-0474', '', '$2a$04$8fI.glvUJJmzphKDndVCheHN0bCv/RMW238BR99H1oWzEpfTThVLG', '#5e0', 'eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Mybuzz', 'shughes13@illinois.edu', '791-549-1208', '', '$2a$04$ie90OWXlARib2zR9GwJYk.hw6cA.ljZ2HdzkP6Nc3ju3auUJAiwKS', '#67e', 'mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Riffpedia', 'cdefont14@goo.gl', '210-854-9918', '', '$2a$04$HAVFJDaTVC3//J0zG4sCvOwCxuBYr1Ky0FOdRyaOZa74kn90OIahe', '#7e5', 'ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Mudo', 'asainthill15@narod.ru', '513-899-7150', '', '$2a$04$lohEX/I3xsmWJKlj7lytceOrdqmV/uDcfv/h9o/8Mjkb1U0Vw2PCq', '#dd9', 'metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Edgeblab', 'alouche16@angelfire.com', '642-350-1212', '', '$2a$04$I6elxb9jJKZ4vBu8GZwg5OObhsdjpuARH8WjtjWhMpMEEHrjfYcGS', '#893', 'est quam pharetra magna ac consequat metus sapien ut nunc vestibulum ante ipsum primis in', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Jatri', 'msearsby17@ameblo.jp', '260-978-1000', '', '$2a$04$ryYmAbBEBCQcAp7jC1BVDeFZnerWg6D69sxc6jZgZguhtKhGpZZxC', '#f88', 'tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Wikizz', 'zkarpe18@google.cn', '946-620-5246', '', '$2a$04$2GRSHYNKRcWULBKUlHbruejv/f8nloo4x.g7FIaOn9Eel8H6gRfm6', '#7f7', 'ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Topiczoom', 'ihatz19@bloglines.com', '841-941-0513', '', '$2a$04$0bs4rdhbLCGP1JMTcjU5l.uZBBMk0mmUkA4dDN7DAPJxN7qjxyLUG', '#026', 'penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Latz', 'kparlot1a@hibu.com', '216-663-0724', '', '$2a$04$kH1xvQoZkxr0pC5aAlVKrecAO/EZOzwV0kvk9V9JxsaqsSEGb9dWq', '#0d7', 'scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Dynabox', 'gjessep1b@desdev.cn', '528-150-7826', '', '$2a$04$smGUcMLBIr8ZpL8aXgm3H.Q3Uby7oCZ5H8BGkGheCWkAuvMXAOqk.', '#199', 'elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum', true);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Cogidoo', 'gyurkov1c@vkontakte.ru', '640-937-8118', '', '$2a$04$xgTEdSzVRlBbEslazWBBoee6FmdW61R.aBBQyBKoioO811z1pQPtu', '#b65', 'metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget', false);
insert into companies (companyName, repEmail, repPhone, website, passwordHash, intro, profile, activityStatus) values ('Bubblebox', 'mwestfield1d@imageshack.us', '335-132-0262', '', '$2a$04$v.JgR.vQoY/ixF/Q/jeDrORezIMOw5M.uA3diFafMt8HXWMaBCvOq', '#1a1', 'porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit', true);

-- Inserting sample data for worked_at

insert into worked_at (studentId, companyId) values ('28', '7');
insert into worked_at (studentId, companyId) values ('18', '19');
insert into worked_at (studentId, companyId) values ('12', '29');
insert into worked_at (studentId, companyId) values ('30', '26');
insert into worked_at (studentId, companyId) values ('32', '5');
insert into worked_at (studentId, companyId) values ('19', '33');
insert into worked_at (studentId, companyId) values ('33', '16');
insert into worked_at (studentId, companyId) values ('50', '23');
insert into worked_at (studentId, companyId) values ('22', '37');
insert into worked_at (studentId, companyId) values ('5', '2');
insert into worked_at (studentId, companyId) values ('43', '21');
insert into worked_at (studentId, companyId) values ('3', '31');
insert into worked_at (studentId, companyId) values ('37', '3');
insert into worked_at (studentId, companyId) values ('42', '25');
insert into worked_at (studentId, companyId) values ('35', '17');
insert into worked_at (studentId, companyId) values ('31', '10');
insert into worked_at (studentId, companyId) values ('38', '20');
insert into worked_at (studentId, companyId) values ('36', '4');
insert into worked_at (studentId, companyId) values ('27', '9');
insert into worked_at (studentId, companyId) values ('13', '47');
insert into worked_at (studentId, companyId) values ('4', '24');
insert into worked_at (studentId, companyId) values ('39', '44');
insert into worked_at (studentId, companyId) values ('9', '11');
insert into worked_at (studentId, companyId) values ('46', '46');
insert into worked_at (studentId, companyId) values ('49', '50');
insert into worked_at (studentId, companyId) values ('26', '28');
insert into worked_at (studentId, companyId) values ('16', '6');
insert into worked_at (studentId, companyId) values ('41', '39');
insert into worked_at (studentId, companyId) values ('44', '35');
insert into worked_at (studentId, companyId) values ('48', '27');
insert into worked_at (studentId, companyId) values ('8', '43');
insert into worked_at (studentId, companyId) values ('40', '48');
insert into worked_at (studentId, companyId) values ('14', '12');
insert into worked_at (studentId, companyId) values ('29', '22');
insert into worked_at (studentId, companyId) values ('2', '49');
insert into worked_at (studentId, companyId) values ('25', '18');
insert into worked_at (studentId, companyId) values ('21', '32');
insert into worked_at (studentId, companyId) values ('11', '8');
insert into worked_at (studentId, companyId) values ('6', '30');
insert into worked_at (studentId, companyId) values ('45', '38');
insert into worked_at (studentId, companyId) values ('1', '15');
insert into worked_at (studentId, companyId) values ('23', '41');
insert into worked_at (studentId, companyId) values ('47', '13');
insert into worked_at (studentId, companyId) values ('24', '42');
insert into worked_at (studentId, companyId) values ('15', '14');
insert into worked_at (studentId, companyId) values ('7', '36');
insert into worked_at (studentId, companyId) values ('10', '34');
insert into worked_at (studentId, companyId) values ('34', '1');
insert into worked_at (studentId, companyId) values ('20', '40');
insert into worked_at (studentId, companyId) values ('17', '45');
insert into worked_at (studentId, companyId) values ('10', '41');
insert into worked_at (studentId, companyId) values ('13', '19');
insert into worked_at (studentId, companyId) values ('49', '25');
insert into worked_at (studentId, companyId) values ('19', '17');
insert into worked_at (studentId, companyId) values ('9', '23');
insert into worked_at (studentId, companyId) values ('36', '33');
insert into worked_at (studentId, companyId) values ('21', '10');
insert into worked_at (studentId, companyId) values ('35', '24');
insert into worked_at (studentId, companyId) values ('41', '2');
insert into worked_at (studentId, companyId) values ('32', '28');
insert into worked_at (studentId, companyId) values ('4', '47');
insert into worked_at (studentId, companyId) values ('24', '29');
insert into worked_at (studentId, companyId) values ('14', '35');
insert into worked_at (studentId, companyId) values ('45', '20');
insert into worked_at (studentId, companyId) values ('33', '37');
insert into worked_at (studentId, companyId) values ('3', '45');
insert into worked_at (studentId, companyId) values ('29', '13');
insert into worked_at (studentId, companyId) values ('50', '14');
insert into worked_at (studentId, companyId) values ('2', '18');
insert into worked_at (studentId, companyId) values ('25', '1');
insert into worked_at (studentId, companyId) values ('39', '15');
insert into worked_at (studentId, companyId) values ('1', '12');
insert into worked_at (studentId, companyId) values ('30', '8');
insert into worked_at (studentId, companyId) values ('6', '38');
insert into worked_at (studentId, companyId) values ('26', '5');
insert into worked_at (studentId, companyId) values ('31', '46');
insert into worked_at (studentId, companyId) values ('47', '30');
insert into worked_at (studentId, companyId) values ('5', '50');
insert into worked_at (studentId, companyId) values ('22', '22');
insert into worked_at (studentId, companyId) values ('20', '34');
insert into worked_at (studentId, companyId) values ('15', '6');
insert into worked_at (studentId, companyId) values ('12', '21');
insert into worked_at (studentId, companyId) values ('17', '32');
insert into worked_at (studentId, companyId) values ('18', '48');
insert into worked_at (studentId, companyId) values ('7', '31');
insert into worked_at (studentId, companyId) values ('11', '7');
insert into worked_at (studentId, companyId) values ('27', '49');
insert into worked_at (studentId, companyId) values ('8', '44');
insert into worked_at (studentId, companyId) values ('40', '16');
insert into worked_at (studentId, companyId) values ('46', '11');
insert into worked_at (studentId, companyId) values ('42', '26');
insert into worked_at (studentId, companyId) values ('16', '4');
insert into worked_at (studentId, companyId) values ('43', '39');
insert into worked_at (studentId, companyId) values ('44', '36');
insert into worked_at (studentId, companyId) values ('34', '43');
insert into worked_at (studentId, companyId) values ('38', '42');
insert into worked_at (studentId, companyId) values ('28', '40');
insert into worked_at (studentId, companyId) values ('23', '9');






-- Inserting sample data for coops
INSERT INTO coops (jobTitle, hourlyRate, location, industry, summary, company)
VALUES
('Software Developer', 25.00, 'San Francisco', 'Tech', 'Developed applications for clients', 1),
('Intern', 18.50, 'Los Angeles', 'Healthcare', 'Assisted with patient data management', 2),
('Electrical Engineer Intern', 22.00, 'Chicago', 'Engineering', 'Worked on product development', 3);
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('5', 'Compensation Analyst', 37.84, 'Rancho Nuevo', 'Manufacturing', 'pellentesque at nulla suspendisse potenti cras in purus eu magna');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('2', 'Software Test Engineer II', 33.52, 'Keli', 'Healthcare', 'nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('16', 'Financial Advisor', 23.18, 'Xinquansi', 'Education', 'at turpis a pede posuere nonummy integer non velit donec diam');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('47', 'Computer Systems Analyst III', 38.49, 'Bissau', 'Other', 'eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('30', 'Engineer III', 21.7, 'Ciburial', 'Education', 'dui luctus rutrum nulla tellus in sagittis dui vel nisl');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('14', 'Database Administrator IV', 24.11, 'Xiqi', 'Other', 'nunc proin at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('27', 'Database Administrator I', 24.8, 'Qaxbaş', 'Healthcare', 'lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('46', 'Desktop Support Technician', 30.49, 'Sambir', 'Healthcare', 'fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('18', 'Administrative Assistant IV', 20.21, 'Getulio', 'Education', 'morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('43', 'Account Executive', 33.46, 'Zhitan', 'Manufacturing', 'amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('44', 'Health Coach II', 27.77, 'Teslić', 'Finance', 'elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('49', 'Financial Advisor', 29.55, 'Bagusan', 'Other', 'ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('12', 'Senior Sales Associate', 26.24, 'Andrijaševci', 'Education', 'vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('48', 'Mechanical Systems Engineer', 39.6, 'Houston', 'Other', 'in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('17', 'Data Coordinator', 39.1, 'Netolice', 'Manufacturing', 'eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('50', 'Marketing Manager', 21.72, 'Phutthaisong', 'Finance', 'urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('10', 'Senior Editor', 37.92, 'Pinhão', 'Healthcare', 'posuere cubilia curae nulla dapibus dolor vel est donec odio justo');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('31', 'Nuclear Power Engineer', 25.09, 'Baiima', 'Healthcare', 'nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('33', 'Editor', 24.79, 'Dongjiang Matoukou', 'Finance', 'donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('21', 'Systems Administrator IV', 21.96, 'Cikoneng', 'Technology', 'amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('25', 'Technical Writer', 35.3, 'Tourcoing', 'Other', 'eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('9', 'Nurse', 32.36, 'Rego', 'Other', 'at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('32', 'Administrative Officer', 22.8, 'Shiziqiao', 'Education', 'euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('13', 'Product Engineer', 24.42, 'Natakoli', 'Healthcare', 'semper est quam pharetra magna ac consequat metus sapien ut nunc');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('4', 'Office Assistant I', 33.82, 'Prestea', 'Healthcare', 'condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('1', 'Social Worker', 22.7, 'Turku', 'Technology', 'amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('7', 'Business Systems Development Analyst', 32.77, 'Muliang', 'Other', 'potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('37', 'Software Test Engineer II', 37.35, 'Jianling', 'Other', 'iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('28', 'Senior Financial Analyst', 28.6, 'Itumbiara', 'Other', 'vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('45', 'Recruiting Manager', 36.53, 'Limbangan', 'Healthcare', 'hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('22', 'Analog Circuit Design manager', 38.31, 'Lorut', 'Education', 'dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('41', 'Help Desk Technician', 30.27, 'Krajanbaturno', 'Healthcare', 'maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('34', 'Paralegal', 22.71, 'Kushelevka', 'Technology', 'curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('24', 'Information Systems Manager', 31.42, 'Marugame', 'Healthcare', 'magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('35', 'Associate Professor', 24.68, 'Padangsidempuan', 'Manufacturing', 'maecenas ut massa quis augue luctus tincidunt nulla mollis molestie');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('38', 'Clinical Specialist', 34.79, 'Sandymount', 'Other', 'integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('20', 'Senior Financial Analyst', 25.35, 'Fale old settlement', 'Other', 'dolor sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('8', 'Quality Engineer', 27.66, 'Shangsanji', 'Healthcare', 'eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('36', 'Computer Systems Analyst III', 24.5, 'Masaran', 'Technology', 'consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('29', 'Senior Sales Associate', 20.2, 'Dawuhan', 'Healthcare', 'curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('6', 'Account Representative IV', 26.28, 'Karlskoga', 'Finance', 'pretium nisl ut volutpat sapien arcu sed augue aliquam erat');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('26', 'Associate Professor', 39.35, 'Toužim', 'Finance', 'est risus auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('39', 'Structural Analysis Engineer', 38.83, 'Quilo-quilo', 'Manufacturing', 'potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('23', 'Director of Sales', 34.28, 'La Unión', 'Other', 'elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('11', 'Analog Circuit Design manager', 20.52, 'Huotian', 'Healthcare', 'vehicula condimentum curabitur in libero ut massa volutpat convallis morbi');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('19', 'Quality Engineer', 38.72, 'Kunvald', 'Education', 'massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('15', 'Civil Engineer', 21.7, 'Guandian', 'Other', 'duis bibendum felis sed interdum venenatis turpis enim blandit mi');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('42', 'VP Accounting', 37.46, 'Khemarat', 'Manufacturing', 'sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('40', 'Database Administrator IV', 26.0, 'Chyżne', 'Technology', 'sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum');
insert into coops (company, jobTitle, hourlyRate, location, industry, summary) values ('3', 'Statistician I', 35.98, 'Sicamous', 'Manufacturing', 'id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi');


-- Inserting sample data for reviews


insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('5', '30', '2', false, 1, 45, 'orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('48', '7', '27', false, 5, 100, 'in lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('6', '29', '13', true, 4, 61, 'dapibus augue vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('39', '36', '6', true, 4, 33, 'morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('14', '22', '33', true, 5, 91, 'a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('10', '31', '7', true, 2, 42, 'turpis eget elit sodales scelerisque mauris sit amet eros suspendisse');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('7', '19', '25', false, 4, 100, 'amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('12', '23', '17', false, 1, 52, 'leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('29', '24', '21', false, 5, 81, 'praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('1', '8', '47', false, 2, 51, 'eros elementum pellentesque quisque porta volutpat erat quisque erat eros');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('36', '47', '8', false, 2, 74, 'odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('19', '14', '49', true, 1, 73, 'consequat varius integer ac leo pellentesque ultrices mattis odio donec');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('3', '50', '5', false, 4, 6, 'dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('13', '15', '24', true, 4, 39, 'vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('41', '28', '14', false, 2, 22, 'ipsum dolor sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('44', '12', '26', true, 3, 71, 'in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('25', '39', '10', true, 2, 8, 'varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('4', '35', '42', false, 2, 40, 'volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('50', '2', '29', true, 2, 61, 'a feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('26', '27', '41', true, 4, 57, 'ac consequat metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('33', '41', '40', true, 4, 49, 'justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('45', '33', '36', false, 4, 32, 'auctor sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('31', '3', '44', true, 5, 60, 'in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('24', '1', '48', true, 1, 91, 'mauris sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('27', '6', '15', true, 4, 50, 'vel est donec odio justo sollicitudin ut suscipit a feugiat et');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('32', '38', '4', false, 3, 58, 'curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('35', '37', '16', false, 1, 50, 'nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('42', '5', '31', true, 3, 15, 'sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('11', '34', '20', false, 1, 4, 'aliquam augue quam sollicitudin vitae consectetuer eget rutrum at lorem integer');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('21', '25', '43', false, 4, 0, 'lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('49', '4', '3', true, 2, 90, 'sed justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('30', '42', '1', false, 4, 39, 'interdum mauris non ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('15', '10', '37', false, 1, 28, 'curae nulla dapibus dolor vel est donec odio justo sollicitudin ut');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('18', '20', '11', true, 4, 75, 'id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('16', '11', '50', false, 1, 67, 'etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('34', '18', '18', true, 4, 57, 'odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('47', '45', '9', false, 1, 44, 'vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('38', '48', '28', true, 3, 33, 'eu orci mauris lacinia sapien quis libero nullam sit amet turpis');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('9', '16', '35', true, 2, 66, 'platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('37', '46', '23', true, 2, 43, 'eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('28', '21', '22', false, 2, 93, 'interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam tristique tortor');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('20', '32', '30', true, 5, 90, 'donec semper sapien a libero nam dui proin leo odio');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('8', '17', '32', false, 1, 52, 'sed tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('22', '9', '34', false, 2, 77, 'posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('40', '43', '38', true, 2, 27, 'at turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('46', '49', '46', false, 2, 22, 'cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('17', '44', '12', false, 5, 15, 'sed interdum venenatis turpis enim blandit mi in porttitor pede justo');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('23', '13', '19', false, 1, 3, 'in purus eu magna vulputate luctus cum sociis natoque penatibus et');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('43', '26', '45', false, 1, 44, 'pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla');
insert into reviews (poster, reviewOf, coopId, anonymous, stars, likes, content) values ('2', '40', '39', false, 2, 53, 'accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi');




-- Inserting sample data for comments

insert into comments (reviewId, content, poster) values ('14', 'hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget', '48');
insert into comments (reviewId, content, poster) values ('42', 'in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi', '12');
insert into comments (reviewId, content, poster) values ('1', 'eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique', '7');
insert into comments (reviewId, content, poster) values ('22', 'eros vestibulum ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut', '34');
insert into comments (reviewId, content, poster) values ('23', 'proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis', '37');
insert into comments (reviewId, content, poster) values ('27', 'convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi', '32');
insert into comments (reviewId, content, poster) values ('21', 'elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla', '2');
insert into comments (reviewId, content, poster) values ('44', 'potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt', '22');
insert into comments (reviewId, content, poster) values ('18', 'pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa', '17');
insert into comments (reviewId, content, poster) values ('16', 'metus aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus', '45');
insert into comments (reviewId, content, poster) values ('19', 'vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem', '47');
insert into comments (reviewId, content, poster) values ('41', 'nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit', '29');
insert into comments (reviewId, content, poster) values ('36', 'a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum', '10');
insert into comments (reviewId, content, poster) values ('2', 'erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor', '33');
insert into comments (reviewId, content, poster) values ('24', 'consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla', '49');
insert into comments (reviewId, content, poster) values ('11', 'in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi', '1');
insert into comments (reviewId, content, poster) values ('48', 'natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque', '36');
insert into comments (reviewId, content, poster) values ('5', 'elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum', '23');
insert into comments (reviewId, content, poster) values ('33', 'semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at', '19');
insert into comments (reviewId, content, poster) values ('25', 'ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate', '40');
insert into comments (reviewId, content, poster) values ('46', 'parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient', '16');
insert into comments (reviewId, content, poster) values ('20', 'nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra diam', '4');
insert into comments (reviewId, content, poster) values ('8', 'maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat', '9');
insert into comments (reviewId, content, poster) values ('7', 'vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget', '28');
insert into comments (reviewId, content, poster) values ('12', 'commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel', '18');
insert into comments (reviewId, content, poster) values ('34', 'nulla sed accumsan felis ut at dolor quis odio consequat varius integer', '6');
insert into comments (reviewId, content, poster) values ('31', 'leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat', '20');
insert into comments (reviewId, content, poster) values ('40', 'magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis', '5');
insert into comments (reviewId, content, poster) values ('3', 'amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque', '25');
insert into comments (reviewId, content, poster) values ('6', 'semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac', '14');
insert into comments (reviewId, content, poster) values ('17', 'vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum', '44');
insert into comments (reviewId, content, poster) values ('9', 'fusce lacus purus aliquet at feugiat non pretium quis lectus suspendisse', '30');
insert into comments (reviewId, content, poster) values ('37', 'justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet', '41');
insert into comments (reviewId, content, poster) values ('28', 'in felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec', '15');
insert into comments (reviewId, content, poster) values ('13', 'lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea', '8');
insert into comments (reviewId, content, poster) values ('30', 'aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis', '43');
insert into comments (reviewId, content, poster) values ('47', 'suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at', '35');
insert into comments (reviewId, content, poster) values ('29', 'vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci', '24');
insert into comments (reviewId, content, poster) values ('43', 'accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi', '26');
insert into comments (reviewId, content, poster) values ('50', 'primis in faucibus orci luctus et ultrices posuere cubilia curae nulla dapibus dolor vel est donec', '13');
insert into comments (reviewId, content, poster) values ('26', 'cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec', '11');
insert into comments (reviewId, content, poster) values ('15', 'sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in', '31');
insert into comments (reviewId, content, poster) values ('49', 'nulla tellus in sagittis dui vel nisl duis ac nibh fusce', '21');
insert into comments (reviewId, content, poster) values ('45', 'erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget', '38');
insert into comments (reviewId, content, poster) values ('39', 'cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at velit vivamus vel nulla eget eros', '3');
insert into comments (reviewId, content, poster) values ('4', 'duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus', '46');
insert into comments (reviewId, content, poster) values ('32', 'aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu', '27');
insert into comments (reviewId, content, poster) values ('35', 'pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu', '42');
insert into comments (reviewId, content, poster) values ('38', 'ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi', '39');
insert into comments (reviewId, content, poster) values ('10', 'ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam tristique tortor', '50');

-- Inserting sample data for system_admins

insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Desdemona', 'Holywell', 'dholywell0@google.cn', '700-712-7353', '$2a$04$TT2lAkzjsvYAuZd6X867peF1k0pSwJLVaZNRzYm8sNNlh7M7ObUam', 'dholywell0');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Evered', 'Birnie', 'ebirnie1@themeforest.net', '718-902-6636', '$2a$04$KAfGORlEei2bAXKpLfi/Ue6Jh.1kjlcRZGrFWuDy7TCqdkQGnylE.', 'ebirnie1');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Berkie', 'Johann', 'bjohann2@theglobeandmail.com', '115-878-5820', '$2a$04$xz8Z5/54.Bh4QDhGfqiVKO//g33IY4riseyyOhcrJ017W9cdnPYEy', 'bjohann2');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Christean', 'Duchant', 'cduchant3@live.com', '905-401-5264', '$2a$04$I9UMxsDaKJE9OElB8OE6s.hbTJgLTD6N05Dw2aK0xPFa8pX9rWIZ2', 'cduchant3');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Benni', 'Kieff', 'bkieff4@yahoo.co.jp', '792-453-6784', '$2a$04$gPzecjXzk3SsDng5qLJp7OClHKOVEF76WiVdIbfGgsnwGolLbgvXC', 'bkieff4');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Richie', 'Andrea', 'randrea5@cyberchimps.com', '586-679-4747', '$2a$04$rTmWiHIPRsd1fdtbEI0SVOCMXpzSlT7SU.WulOR5HTD77W/IunPsK', 'randrea5');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Thomas', 'Virgoe', 'tvirgoe6@rakuten.co.jp', '259-684-5956', '$2a$04$/crBM3tv4V5AswpKZNb2/.ShsjrA/rWdhkFpWI2BuqileZIwpnSZa', 'tvirgoe6');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Ivie', 'Massel', 'imassel7@joomla.org', '160-737-1852', '$2a$04$m2cs.Fbk3UpmVgYj6VmzY.OQ68.OXNV/.qyrXyaxFOvHvfa.375bG', 'imassel7');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Paulie', 'Oloman', 'poloman8@ovh.net', '402-836-3403', '$2a$04$PE8WIpmilx.m5wWAHyCq5.trcAAjt8eITgc8ULd4yLb0FS3S4Vhny', 'poloman8');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Christalle', 'Vicary', 'cvicary9@networkadvertising.org', '517-732-8106', '$2a$04$AsvGFPOTtuzhDf1FMSkUVepRTsrqScY1YiTojaHh7BtJJeMS.JK0G', 'cvicary9');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Alaric', 'Colclough', 'acolclougha@drupal.org', '963-197-5978', '$2a$04$15FROYDcWqQJLdKtC9h4kue1u704F2RKIK3xW15B2jS364ry4JuOW', 'acolclougha');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Jan', 'Laguerre', 'jlaguerreb@boston.com', '984-228-5888', '$2a$04$NK1VuGvlTWFRz2cyGDEVq.DBlycsedPb8nMs2/dqXTBVg7m/peRZi', 'jlaguerreb');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Dionisio', 'Salomon', 'dsalomonc@answers.com', '830-208-1952', '$2a$04$wLcV/jF2IhDwIrFo7MjdiONpCjyBwMxhw9UNypKZ2S69/fh0FZDBa', 'dsalomonc');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Roxana', 'Lohoar', 'rlohoard@altervista.org', '986-990-7214', '$2a$04$YALc2oFRvLxc.qqHRBlGK.t3tPWMYyfFc0DGyGCFxbeLQPWinOXWG', 'rlohoard');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Winifield', 'Mallinson', 'wmallinsone@is.gd', '375-728-5625', '$2a$04$B5lDwc4szHuzT19Ssvhg8uWfAzCkuuJGDS18ArkJ4jcFikiO04A2q', 'wmallinsone');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Dale', 'Burne', 'dburnef@webnode.com', '102-742-3402', '$2a$04$Y8waFfMWawZboc3LQbVDle42GOEr37GbQj9xrG21NI251aeZIYs9a', 'dburnef');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Fabe', 'Draxford', 'fdraxfordg@statcounter.com', '571-553-8936', '$2a$04$dT5lyDtecjc4Df3skLMDs.SljsFthUxmzO56ZAh/IVvKqqsbSnS.y', 'fdraxfordg');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Willey', 'Beltzner', 'wbeltznerh@auda.org.au', '842-292-6442', '$2a$04$74Exo/9N1nz7AING/cNNI.RTOVGhagDddQV4S48ok0Nb7jz4ipYxm', 'wbeltznerh');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Ursula', 'Kett', 'uketti@furl.net', '828-895-5698', '$2a$04$S8E46DlyGUzp.J7pjsySROhhSpHPheXLhBESAaEmg/SHySJZ1/H/6', 'uketti');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Wilmette', 'Pridham', 'wpridhamj@statcounter.com', '865-449-5435', '$2a$04$0rjJy7llkjE0vCXDpsKOzOq1GVkrnu6r94cz7fLwWw/DCTF2/MYZ6', 'wpridhamj');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Elka', 'Keling', 'ekelingk@bloomberg.com', '843-271-8200', '$2a$04$ol1ZeRPDePujF2QYMo5ue.bgfGCS6JXZoSaHpVak8E9TZzT1BBW96', 'ekelingk');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Lissie', 'Glencross', 'lglencrossl@spotify.com', '909-363-8587', '$2a$04$0Kw4eI2UzIVBs/aimZUoZuKr.EQkWj3.iqXFx4usm/wr3sOa8ZP3G', 'lglencrossl');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Lynea', 'Keppe', 'lkeppem@patch.com', '502-944-0015', '$2a$04$IqMAUPW/HbXFvlLpr0g9Qu/G3vX7qAWl2UrzyGq0ZUDHTCVZKGyKO', 'lkeppem');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Tamma', 'Gianni', 'tgiannin@digg.com', '224-829-0392', '$2a$04$gLb3UZ3VHx.iadHFN3rQh.eSrtwfoTZdhSdJm0qrfbUnrg2nWaFYe', 'tgiannin');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Douglass', 'Medlar', 'dmedlaro@fastcompany.com', '957-949-2256', '$2a$04$bJifNBjhtx0ZgkIvEmgVsevzl4Al6XgtXJUBRrEt6nFeygC2kGIXC', 'dmedlaro');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Christalle', 'Summerhayes', 'csummerhayesp@nytimes.com', '171-330-5032', '$2a$04$jND19hB7aFPxgfHt4Cmsluz4XNkEqZmzf7ptbHGtkdNsCoZFEwo6u', 'csummerhayesp');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Natale', 'Peschke', 'npeschkeq@patch.com', '934-956-8107', '$2a$04$cE85v0/pBtxbbvYYegCxfeNCdy1gGA/5997/bKg4m04cOUcOcseru', 'npeschkeq');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Ottilie', 'Dirr', 'odirrr@vkontakte.ru', '531-100-5673', '$2a$04$NYaOwaBU3DqQQ7kFdxG5eu7IUnW4pohjjiyLuKsdTYVT8Wauz.0CK', 'odirrr');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Lena', 'Fine', 'lfines@craigslist.org', '911-896-8166', '$2a$04$fUxN84Ywjx.nhNgK1aUuK.1op.r3O.t9krhyP5xzzfG3jaJIBgzZ2', 'lfines');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Jessika', 'Davidowsky', 'jdavidowskyt@imageshack.us', '461-938-6006', '$2a$04$NuBSp/i3hBIyTL4qFbRxoOyMU3L4ODm1H885LI8uYzJ0dqIIE.KDC', 'jdavidowskyt');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Philomena', 'Hovenden', 'phovendenu@ebay.co.uk', '531-825-2493', '$2a$04$9wVKdXI1Yfy.IaSUyKEWDOFjDSXhSaxcd8NS0D4waf5QPRMGe0pfm', 'phovendenu');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Morey', 'Easey', 'measeyv@ucsd.edu', '983-744-9839', '$2a$04$OWWntUszhnFFzcMr.o9hceuEQoRiUmzmmKrkceJWkU2SvZbATTXjW', 'measeyv');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Susannah', 'Wyeld', 'swyeldw@bloglovin.com', '710-947-5888', '$2a$04$UHgyY/tcaSJo0km9TRs3LOxeYn.zDs/BJHtcle6qHZrMlTpNd8oZ2', 'swyeldw');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Catarina', 'Dominguez', 'cdominguezx@java.com', '622-183-2858', '$2a$04$iM/Je8lwetk.i0XWH4s89OYPEtHyUYXXKDrcMfbRqfoGqZIkFSi0K', 'cdominguezx');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Penn', 'Brangan', 'pbrangany@163.com', '218-210-9086', '$2a$04$qPOPeh/osl74RGOKeP8Wke8RnRiCo.T584XJxE0ZuwNTA2s8jIHLi', 'pbrangany');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Borg', 'Dunan', 'bdunanz@csmonitor.com', '398-301-3432', '$2a$04$PwgGRlpK.M37vbpcRu.ELeUQrZLqjJ5zwVfcAZhd8TySgIiH3QS9S', 'bdunanz');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Bunni', 'Niess', 'bniess10@yahoo.co.jp', '557-717-1749', '$2a$04$lY3WcY8IKelDT5rpxY/AIOTAvOLTRXgjXr3iDD5edjLgjUBeCsqxq', 'bniess10');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Valry', 'Durling', 'vdurling11@imgur.com', '581-478-1600', '$2a$04$m0zmSQS.uK2rexk1r1kyxuEUS58lXqEZkMrVyNCRHB5kIhl.whylK', 'vdurling11');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Allan', 'Aitkin', 'aaitkin12@alibaba.com', '831-570-6734', '$2a$04$LpaZ.bCz0WKti4FtFHppr.pfxQul/3/q8jJdD5LM/084y9IX9SgRW', 'aaitkin12');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Jaquelin', 'Chown', 'jchown13@artisteer.com', '903-596-8101', '$2a$04$cx.mX1nkw0CxXoP2HJ4MvuebF2UWX6oSstmWE4gUliDODcECyqnIu', 'jchown13');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Stefan', 'Burth', 'sburth14@facebook.com', '803-857-8035', '$2a$04$KiBD.mbkAd.L92xOgkIoJu52lWGdAoshXu6moISZyKywzIWQO.iCm', 'sburth14');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Kendrick', 'Soutter', 'ksoutter15@smugmug.com', '860-882-4304', '$2a$04$DAgM429GqdhcPxy4KTUL3udsAs7yEOmHThCu8lxKtm.w5ZM1LZWNi', 'ksoutter15');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Kiel', 'Hammerberger', 'khammerberger16@wired.com', '812-527-0958', '$2a$04$4Wc/Vh0sJfGIapQdnpEs2uqwHf.5i0hTSnZrqMrOGS1gnXz7UzxB.', 'khammerberger16');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Felita', 'Bleythin', 'fbleythin17@ca.gov', '292-656-2749', '$2a$04$3s6vvPnxK6xXSBC9FIRVcuG8l7YJEiLpNDEBNQHTvLERWwxqodGA2', 'fbleythin17');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Elmira', 'de Zamora', 'edezamora18@uiuc.edu', '806-893-0122', '$2a$04$nlkxwzl6LXueckXREK8N8OWQ9FEp2pWJ9J0c/BdqdJWNIbDvM2BUq', 'edezamora18');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Griffy', 'Vondrasek', 'gvondrasek19@home.pl', '385-958-2291', '$2a$04$c93BMBJ1LwOLu8cbAf9iteaBgBx2nBP6UdQxsFDYuyI6bsYVsItDG', 'gvondrasek19');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Esra', 'Falkingham', 'efalkingham1a@photobucket.com', '158-214-4639', '$2a$04$fv88wz3gWFyKZm72C001n.wKopWdYBDLR5YV0lp6OS55xJUYcb8ZK', 'efalkingham1a');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Cleavland', 'Hallewell', 'challewell1b@smugmug.com', '339-145-2748', '$2a$04$zpgvF6A0M4sPSqWS41XlfOqaEG4OZDhX2SKHat7JB3bgemu.Bu/g2', 'challewell1b');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Waylin', 'Emmet', 'wemmet1c@lycos.com', '153-304-1618', '$2a$04$xjEUr0yOn0K1ndQMOkLWo.FzIz7ffgCU9qQsYeZAqiRx7y2iKUExK', 'wemmet1c');
insert into system_admins (firstName, lastName, email, phone, passwordHash, username) values ('Gradeigh', 'Ahlin', 'gahlin1d@cmu.edu', '415-248-8121', '$2a$04$.zwvpb3y.Dv.74TRIwyACONbBWMFH0DyEZ3MG/IZc1caLJc8romb6', 'gahlin1d');

-- Inserting sample data for requests

insert into requests (details, resolveStatus, companyId, studentId) values ('congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam', true, '19', '39');
insert into requests (details, resolveStatus, companyId, studentId) values ('nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum', true, '5', '46');
insert into requests (details, resolveStatus, companyId, studentId) values ('platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien', true, '23', '34');
insert into requests (details, resolveStatus, companyId, studentId) values ('lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl', false, '29', '20');
insert into requests (details, resolveStatus, companyId, studentId) values ('pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus', true, '17', '26');
insert into requests (details, resolveStatus, companyId, studentId) values ('sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac', true, '16', '17');
insert into requests (details, resolveStatus, companyId, studentId) values ('lorem ipsum dolor sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien', true, '11', '6');
insert into requests (details, resolveStatus, companyId, studentId) values ('eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget', false, '31', '50');
insert into requests (details, resolveStatus, companyId, studentId) values ('posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet', false, '22', '27');
insert into requests (details, resolveStatus, companyId, studentId) values ('blandit nam nulla integer pede justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare', true, '45', '35');
insert into requests (details, resolveStatus, companyId, studentId) values ('nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis', false, '26', '5');
insert into requests (details, resolveStatus, companyId, studentId) values ('in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum in hac habitasse', true, '40', '43');
insert into requests (details, resolveStatus, companyId, studentId) values ('nam congue risus semper porta volutpat quam pede lobortis ligula sit amet', true, '21', '1');
insert into requests (details, resolveStatus, companyId, studentId) values ('et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque', false, '18', '49');
insert into requests (details, resolveStatus, companyId, studentId) values ('vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum', true, '41', '28');
insert into requests (details, resolveStatus, companyId, studentId) values ('hac habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla', true, '36', '16');
insert into requests (details, resolveStatus, companyId, studentId) values ('amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at ipsum ac tellus', true, '20', '44');
insert into requests (details, resolveStatus, companyId, studentId) values ('proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in', false, '48', '8');
insert into requests (details, resolveStatus, companyId, studentId) values ('nisl aenean lectus pellentesque eget nunc donec quis orci eget', true, '47', '14');
insert into requests (details, resolveStatus, companyId, studentId) values ('tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat', true, '34', '23');
insert into requests (details, resolveStatus, companyId, studentId) values ('penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque', false, '1', '30');
insert into requests (details, resolveStatus, companyId, studentId) values ('nisl aenean lectus pellentesque eget nunc donec quis orci eget', false, '49', '47');
insert into requests (details, resolveStatus, companyId, studentId) values ('vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus', false, '44', '18');
insert into requests (details, resolveStatus, companyId, studentId) values ('fermentum donec ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh', false, '38', '36');
insert into requests (details, resolveStatus, companyId, studentId) values ('vitae consectetuer eget rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum', false, '8', '10');
insert into requests (details, resolveStatus, companyId, studentId) values ('aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac', true, '37', '37');
insert into requests (details, resolveStatus, companyId, studentId) values ('aliquam erat volutpat in congue etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus', true, '32', '45');
insert into requests (details, resolveStatus, companyId, studentId) values ('in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed', false, '27', '12');
insert into requests (details, resolveStatus, companyId, studentId) values ('justo lacinia eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat', false, '30', '22');
insert into requests (details, resolveStatus, companyId, studentId) values ('mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient montes nascetur', true, '13', '33');
insert into requests (details, resolveStatus, companyId, studentId) values ('nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit', true, '39', '3');
insert into requests (details, resolveStatus, companyId, studentId) values ('at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum', false, '12', '24');
insert into requests (details, resolveStatus, companyId, studentId) values ('eu massa donec dapibus duis at velit eu est congue elementum in', false, '33', '21');
insert into requests (details, resolveStatus, companyId, studentId) values ('morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum', true, '14', '11');
insert into requests (details, resolveStatus, companyId, studentId) values ('mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae', true, '25', '31');
insert into requests (details, resolveStatus, companyId, studentId) values ('sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl', false, '6', '32');
insert into requests (details, resolveStatus, companyId, studentId) values ('in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum', false, '9', '15');
insert into requests (details, resolveStatus, companyId, studentId) values ('ultrices posuere cubilia curae nulla dapibus dolor vel est donec odio justo sollicitudin ut', false, '3', '19');
insert into requests (details, resolveStatus, companyId, studentId) values ('dapibus dolor vel est donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia nisi', true, '28', '2');
insert into requests (details, resolveStatus, companyId, studentId) values ('at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae', true, '43', '25');
insert into requests (details, resolveStatus, companyId, studentId) values ('maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque', false, '10', '41');
insert into requests (details, resolveStatus, companyId, studentId) values ('nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum', true, '46', '40');
insert into requests (details, resolveStatus, companyId, studentId) values ('eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget', true, '50', '48');
insert into requests (details, resolveStatus, companyId, studentId) values ('in felis donec semper sapien a libero nam dui proin', true, '24', '9');
insert into requests (details, resolveStatus, companyId, studentId) values ('nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit', false, '7', '29');
insert into requests (details, resolveStatus, companyId, studentId) values ('consequat in consequat ut nulla sed accumsan felis ut at', false, '2', '7');
insert into requests (details, resolveStatus, companyId, studentId) values ('dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius', true, '15', '13');
insert into requests (details, resolveStatus, companyId, studentId) values ('proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in', true, '4', '4');
insert into requests (details, resolveStatus, companyId, studentId) values ('ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper', false, '35', '42');
insert into requests (details, resolveStatus, companyId, studentId) values ('id massa id nisl venenatis lacinia aenean sit amet justo morbi ut odio cras mi pede', true, '42', '38');


-- Inserting sample data for system_updates
insert into system_updates (details, updatedBy) values ('suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas', '48');
insert into system_updates (details, updatedBy) values ('nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse', '13');
insert into system_updates (details, updatedBy) values ('eros viverra eget congue eget semper rutrum nulla nunc purus', '41');
insert into system_updates (details, updatedBy) values ('leo rhoncus sed vestibulum sit amet cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel', '10');
insert into system_updates (details, updatedBy) values ('ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat', '28');
insert into system_updates (details, updatedBy) values ('sit amet lobortis sapien sapien non mi integer ac neque duis', '40');
insert into system_updates (details, updatedBy) values ('adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum', '43');
insert into system_updates (details, updatedBy) values ('rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet at feugiat', '8');
insert into system_updates (details, updatedBy) values ('accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget', '24');
insert into system_updates (details, updatedBy) values ('diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue', '15');
insert into system_updates (details, updatedBy) values ('etiam justo etiam pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna', '31');
insert into system_updates (details, updatedBy) values ('ante ipsum primis in faucibus orci luctus et ultrices posuere', '39');
insert into system_updates (details, updatedBy) values ('sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc', '49');
insert into system_updates (details, updatedBy) values ('sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus', '2');
insert into system_updates (details, updatedBy) values ('vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue', '14');
insert into system_updates (details, updatedBy) values ('sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim', '37');
insert into system_updates (details, updatedBy) values ('lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui', '34');
insert into system_updates (details, updatedBy) values ('magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis', '5');
insert into system_updates (details, updatedBy) values ('maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros', '30');
insert into system_updates (details, updatedBy) values ('vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt', '20');
insert into system_updates (details, updatedBy) values ('maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus sapien', '46');
insert into system_updates (details, updatedBy) values ('nulla suspendisse potenti cras in purus eu magna vulputate luctus cum', '33');
insert into system_updates (details, updatedBy) values ('ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit', '38');
insert into system_updates (details, updatedBy) values ('est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl', '45');
insert into system_updates (details, updatedBy) values ('hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate', '21');
insert into system_updates (details, updatedBy) values ('viverra diam vitae quam suspendisse potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam', '19');
insert into system_updates (details, updatedBy) values ('habitasse platea dictumst maecenas ut massa quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida', '47');
insert into system_updates (details, updatedBy) values ('justo pellentesque viverra pede ac diam cras pellentesque volutpat dui maecenas tristique est', '9');
insert into system_updates (details, updatedBy) values ('non mi integer ac neque duis bibendum morbi non quam', '3');
insert into system_updates (details, updatedBy) values ('ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy', '27');
insert into system_updates (details, updatedBy) values ('non lectus aliquam sit amet diam in magna bibendum imperdiet nullam', '23');
insert into system_updates (details, updatedBy) values ('lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea', '12');
insert into system_updates (details, updatedBy) values ('bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus', '26');
insert into system_updates (details, updatedBy) values ('maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra', '16');
insert into system_updates (details, updatedBy) values ('eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi', '36');
insert into system_updates (details, updatedBy) values ('pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla suspendisse potenti cras in purus eu', '1');
insert into system_updates (details, updatedBy) values ('parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent', '25');
insert into system_updates (details, updatedBy) values ('vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis', '11');
insert into system_updates (details, updatedBy) values ('erat curabitur gravida nisi at nibh in hac habitasse platea', '29');
insert into system_updates (details, updatedBy) values ('sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis', '50');
insert into system_updates (details, updatedBy) values ('nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget', '35');
insert into system_updates (details, updatedBy) values ('velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis', '44');
insert into system_updates (details, updatedBy) values ('pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut', '4');
insert into system_updates (details, updatedBy) values ('vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean', '32');
insert into system_updates (details, updatedBy) values ('donec odio justo sollicitudin ut suscipit a feugiat et eros vestibulum ac est lacinia', '18');
insert into system_updates (details, updatedBy) values ('ut mauris eget massa tempor convallis nulla neque libero convallis eget eleifend', '7');
insert into system_updates (details, updatedBy) values ('elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in', '6');
insert into system_updates (details, updatedBy) values ('pellentesque volutpat dui maecenas tristique est et tempus semper est quam pharetra magna ac consequat metus', '42');
insert into system_updates (details, updatedBy) values ('id consequat in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat', '17');
insert into system_updates (details, updatedBy) values ('mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui', '22');

insert into recommendations (studentId, advisorId, coopId, feedback) values ('42', '46', '48', 'nulla nisl nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('33', '35', '14', 'odio cras mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('40', '21', '40', 'morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('8', '45', '30', 'in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('7', '43', '32', 'molestie lorem quisque ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('36', '37', '43', 'rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis lacinia aenean');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('6', '31', '9', 'ac neque duis bibendum morbi non quam nec dui luctus rutrum');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('10', '50', '41', 'justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('5', '39', '21', 'in porttitor pede justo eu massa donec dapibus duis at velit eu est');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('1', '11', '29', 'donec semper sapien a libero nam dui proin leo odio porttitor id consequat');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('32', '22', '18', 'natoque penatibus et magnis dis parturient montes nascetur ridiculus mus');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('44', '3', '26', 'pretium quis lectus suspendisse potenti in eleifend quam a odio');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('50', '32', '39', 'lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('23', '16', '1', 'lectus vestibulum quam sapien varius ut blandit non interdum in ante');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('15', '9', '37', 'arcu libero rutrum ac lobortis vel dapibus at diam nam tristique tortor');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('17', '15', '35', 'elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('28', '48', '11', 'phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('20', '1', '5', 'at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('25', '13', '2', 'eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('3', '29', '50', 'pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('2', '7', '33', 'felis eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('41', '36', '15', 'sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero quis');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('49', '20', '45', 'cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('45', '5', '19', 'adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('47', '17', '47', 'lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('4', '40', '49', 'maecenas tincidunt lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('34', '19', '17', 'ut erat curabitur gravida nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('48', '14', '28', 'elementum pellentesque quisque porta volutpat erat quisque erat eros viverra eget congue eget');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('37', '25', '10', 'pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('31', '41', '38', 'montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('35', '28', '27', 'quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('43', '12', '42', 'consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('24', '38', '46', 'et ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('14', '4', '4', 'curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('22', '26', '13', 'nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('27', '10', '24', 'nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('21', '8', '12', 'sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('29', '30', '25', 'nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('11', '23', '44', 'sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('9', '2', '34', 'in libero ut massa volutpat convallis morbi odio odio elementum eu interdum eu tincidunt');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('13', '47', '23', 'quisque erat eros viverra eget congue eget semper rutrum nulla');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('39', '18', '20', 'semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('38', '6', '8', 'platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('26', '42', '3', 'eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam dui');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('16', '34', '22', 'tincidunt eu felis fusce posuere felis sed lacus morbi sem');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('12', '49', '7', 'feugiat et eros vestibulum ac est lacinia nisi venenatis tristique fusce');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('46', '24', '16', 'congue etiam justo etiam pretium iaculis justo in hac habitasse platea');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('19', '27', '36', 'eu sapien cursus vestibulum proin eu mi nulla ac enim');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('18', '33', '31', 'erat curabitur gravida nisi at nibh in hac habitasse platea');
insert into recommendations (studentId, advisorId, coopId, feedback) values ('42', '44', '6', 'pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla');
