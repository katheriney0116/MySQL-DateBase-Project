-- CS4400: Introduction to Database Systems (Fall 2021)
-- Phase II: Create Table & Insert Statements [v0] Thursday, October 14, 2021 @ 2:00pm EDT

-- Team 97 
-- Xiao Yang (xyang427)
-- Tiankai Yan (tyan41)
-- Zhouyi Xue (zxue60)
-- Qihang Hu（qhu81)

-- Directions:
-- Please follow all instructions for Phase II as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.

-- ------------------------------------------------------
-- CREATE TABLE STATEMENTS AND INSERT STATEMENTS BELOW
-- ------------------------------------------------------


DROP DATABASE IF EXISTS vacation;
CREATE DATABASE IF NOT EXISTS vacation;
USE vacation;


DROP TABLE IF EXISTS vacation_account; 
CREATE TABLE vacation_account (
	email char(50) NOT NULL,
    fname char(100) NOT NULL,
    lname char(100) NOT NULL,
    passwords varchar(20) NOT NULL,
    PRIMARY KEY (email)
) ENGINE=InnoDB;

INSERT INTO vacation_account VALUES
('mmoss1@travelagency.com','Mark','Moss','password1'),
('asmith@travelagency.com','Aviva','Smith','password2'),
('mscott22@gmail.com','Michael','Scott','password3'),
('arthurread@gmail.com','Arthur','Read','password4'),
('jwayne@gmail.com','John','Wayne','password5'),
('gburdell3@gmail.com','George','Burdell','password6'),
('mj23@gmail.com','Michael','Jordan','password7'),
('lebron6@gmail.com','Lebron','James','password8'),
('msmith5@gmail.com','Michael','Smith','password9'),
('ellie2@gmail.com','Ellie','Johnson','password10'),
('scooper3@gmail.com','Sheldon','Cooper','password11'),
('mgeller5@gmail.com','Monica','Geller','password12'),
('cbing10@gmail.com','Chandler','Bing','password13'),
('hwmit@gmail.com','Howard','Wolowitz','password14'),
('swilson@gmail.com','Samantha','Wilson','password16'),
('aray@tiktok.com','Addison','Ray','password17'),
('cdemilio@tiktok.com','Charlie','Demilio','password18'),
('bshelton@gmail.com','Blake','Shelton','password19'),
('lbryan@gmail.com','Luke','Bryan','password20'),
('tswift@gmail.com','Taylor','Swift','password21'),
('jseinfeld@gmail.com','Jerry','Seinfeld','password22'),
('maddiesmith@gmail.com','Madison','Smith','password23'),
('johnthomas@gmail.com','John','Thomas','password24'),
('boblee15@gmail.com','Bob','Lee','password25');

DROP TABLE IF EXISTS admin_acc; 
CREATE TABLE admin_acc (
	Account_email char(50) NOT NULL,
    PRIMARY KEY (Account_email),
    CONSTRAINT admin_acc_ibfk_1 FOREIGN KEY (Account_email) REFERENCES vacation_account (email)
) ENGINE=InnoDB;

INSERT INTO admin_acc VALUES
('mmoss1@travelagency.com'),
('asmith@travelagency.com');


DROP TABLE IF EXISTS client_acc; 
CREATE TABLE client_acc ( 
	Phone_number char(12) NOT NULL,
    Account_email char(30) NOT NULL,
    PRIMARY KEY (Account_email), 
    UNIQUE KEY (Phone_number),
    CONSTRAINT client_acc_ibfk_1 FOREIGN KEY (Account_email) REFERENCES vacation_account (email)
) ENGINE=InnoDB;

INSERT INTO client_acc VALUES
('555-123-4567','mscott22@gmail.com'),
('555-234-5678','arthurread@gmail.com'),
('555-345-6789','jwayne@gmail.com'),
('555-456-7890','gburdell3@gmail.com'),
('555-567-8901','mj23@gmail.com'),
('555-678-9012','lebron6@gmail.com'),
('555-789-0123','msmith5@gmail.com'),
('555-890-1234','ellie2@gmail.com'),
('678-123-4567','scooper3@gmail.com'),
('678-234-5678','mgeller5@gmail.com'),
('678-345-6789','cbing10@gmail.com'),
('678-456-7890','hwmit@gmail.com'),
('770-123-4567','swilson@gmail.com'),
('770-234-5678','aray@tiktok.com'),
('770-345-6789','cdemilio@tiktok.com'),
('770-456-7890','bshelton@gmail.com'),
('770-567-8901','lbryan@gmail.com'),
('770-678-9012','tswift@gmail.com'),
('770-789-0123','jseinfeld@gmail.com'),
('770-890-1234','maddiesmith@gmail.com'),
('404-770-5555','johnthomas@gmail.com'),
('404-678-5555','boblee15@gmail.com');

DROP TABLE IF EXISTS owner_acc;
CREATE TABLE owner_acc (
	owner_email char(50) NOT NULL,
	cell_number char(12) NOT NULL, 
    PRIMARY KEY (owner_email),
    unique KEY (cell_number),
    CONSTRAINT owner_acc_ibfk_1 FOREIGN KEY (owner_email) REFERENCES vacation_account(email),
    CONSTRAINT owner_acc_ibfk_2 FOREIGN KEY (cell_number) REFERENCES client_acc(Phone_number)
)ENGINE=InnoDB;

INSERT INTO owner_acc VALUES 
('mscott22@gmail.com','555-123-4567'),
('arthurread@gmail.com','555-234-5678'),
('jwayne@gmail.com','555-345-6789'),
('gburdell3@gmail.com','555-456-7890'),
('mj23@gmail.com','555-567-8901'),
('lebron6@gmail.com','555-678-9012'),
('msmith5@gmail.com','555-789-0123'),
('ellie2@gmail.com','555-890-1234'),
('scooper3@gmail.com','678-123-4567'),
('mgeller5@gmail.com','678-234-5678'),
('cbing10@gmail.com','678-345-6789'),
('hwmit@gmail.com','678-456-7890');

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
	email_addy char(50) NOT NULL,
    phone_num char(12)  NOT NULL,
	credit_card_num char(19) NOT Null,   
    cvv decimal(3,0) NOT NULL,
	exp_date char(12) NOT NULL,
    current_location char(60) default NULL,
    PRIMARY KEY (email_addy),
    UNIQUE KEY (phone_num,credit_card_num), 
    CONSTRAINT customers_ibfk_1 FOREIGN KEY (email_addy) REFERENCES  vacation_account (email),
    CONSTRAINT customers_ibfk_2 FOREIGN KEY (phone_num) REFERENCES client_acc (Phone_number)
) ENGINE=InnoDB;

INSERT INTO customers VALUES
('swilson@gmail.com','770-123-4567','9383 3212 4198 1836',455,'Aug 2022',NULL),
('aray@tiktok.com','770-234-5678','3110 2669 7949 5605',744,'Aug 2022',NULL),
('cdemilio@tiktok.com','770-345-6789','2272 3555 4078 4744',606,'Feb 2025',NULL),
('bshelton@gmail.com','770-456-7890','9276 7639 7883 4273',862,'Sept 2023',NULL),
('lbryan@gmail.com','770-567-8901','4652 3726 8864 3798',258,'May 2023',NULL),
('tswift@gmail.com','770-678-9012','5478 8420 4436 7471',857,'Dec 2024',NULL),
('jseinfeld@gmail.com','770-789-0123','3616 8977 1296 3372',295,'June 2022',NULL),
('maddiesmith@gmail.com','770-890-1234','9954 5698 6355 6952',794,'July 2022',NULL),
('johnthomas@gmail.com','404-770-5555','7580 3274 3724 5356',269,'Oct 2025',NULL),
('boblee15@gmail.com','404-678-5555','7907 3513 7161 4248',858,'Nov 2025',NULL);



DROP TABLE IF EXISTS IsRateBy;
CREATE TABLE IsRateBy (
	owner_email char(50) NOT NULL,
    customer_email char(50) NOT NULL,
    cscore int NOT NULL,
    primary key (owner_email,customer_email), 
    CONSTRAINT IsRateBy_ibfk_1 FOREIGN KEY (owner_email) REFERENCES vacation_account(email),
    CONSTRAINT IsRateBy_ibfk_2 FOREIGN KEY (customer_email) REFERENCES vacation_account(email)
)ENGINE=InnoDB;

INSERT INTO IsRateBy VALUES
('gburdell3@gmail.com','swilson@gmail.com',5),
('cbing10@gmail.com','aray@tiktok.com',5),
('mgeller5@gmail.com','bshelton@gmail.com',3),
('arthurread@gmail.com','lbryan@gmail.com',4),
('arthurread@gmail.com','tswift@gmail.com',4),
('lebron6@gmail.com','jseinfeld@gmail.com',1),
('hwmit@gmail.com','maddiesmith@gmail.com',2);

DROP TABLE IF EXISTS Rate;
CREATE TABLE Rate (
	Owner_email char(50) NOT NULL,
    Customer_email char(50) NOT NULL,
    oscore int NOT NULL,
    primary key (owner_email,Customer_email),
    CONSTRAINT Rate_ibfk_1 FOREIGN KEY (owner_email) REFERENCES vacation_account (email),
    CONSTRAINT Rate_ibfk_2 FOREIGN KEY (customer_email) REFERENCES vacation_account (email)
)ENGINE=InnoDB;

INSERT INTO Rate VALUES
('gburdell3@gmail.com','swilson@gmail.com',5),
('cbing10@gmail.com','aray@tiktok.com',5),
('mgeller5@gmail.com','bshelton@gmail.com',4),
('arthurread@gmail.com','lbryan@gmail.com',4),
('arthurread@gmail.com','tswift@gmail.com',3),
('lebron6@gmail.com','jseinfeld@gmail.com',2),
('hwmit@gmail.com','maddiesmith@gmail.com',5);


DROP TABLE IF EXISTS property;
CREATE TABLE property (
	property_name char(100) NOT NULL,
    owners char(50) NOT NULL,
    descrip varchar(300) default NULL,
    capacity int NOT NULL, 
    cost_per_night_person decimal(6,0) NOT NULL,
    street char(30) NOT NULL,
    city char(20) NOT NULL,
    state char(2) NOT NULL,
	zip decimal(5,0) NOT NULL,
	PRIMARY KEY (property_name,owners), 
	UNIQUE KEY (street, city, state, zip),
    CONSTRAINT property_ibfk_1 FOREIGN KEY (owners) REFERENCES vacation_account(email)
)ENGINE = InnoDB;


insert into property values 
('Atlanta Great Property','scooper3@gmail.com','This is right in the middle of Atlanta near many attractions!',4,600 ,'2nd St','ATL','GA',30008),
('House near Georgia Tech', 'gburdell3@gmail.com', 'Super close to bobby dodde stadium!', 3, 275, 'North Ave', 'ATL', 'GA', 30008),
('New York City Property', 'cbing10@gmail.com', 'A view of the whole city. Great property!', 2, 750, '123 Main St', 'NYC', 'NY', 10008),
('Statue of Libery Property', 'mgeller5@gmail.com', 'You can see the statue of liberty from the porch', 5, 1000, '1st St', 'NYC', 'NY', 10009),
('Los Angeles Property', 'arthurread@gmail.com',NULL, 3, 700, '10th St', 'LA', 'CA', 90008),
('LA Kings House', 'arthurread@gmail.com', 'This house is super close to the LA kinds stadium!', 4, 750, 'Kings St', 'La', 'CA', 90011),
('Beautiful San Jose Mansion', 'arthurread@gmail.com', 'Huge house that can sleep 12 people. Totally worth it!', 12, 900, 'Golden Bridge Pkwt', 'San Jose', 'CA', 90001),
('LA Lakers Property', 'lebron6@gmail.com', 'This house is right near the LA lakers stadium. You might even meet Lebron James!', 4, 850, 'Lebron Ave', 'LA', 'CA', 90011),
('Chicago Blackhawks House', 'hwmit@gmail.com', 'This is a great property!', 3, 775, 'Blackhawks St', 'Chicago', 'IL', 60176),
('Chicago Romantic Getaway', 'mj23@gmail.com', 'This is a great property!', 2, 1050, '23rd Main St', 'Chicago', 'IL', 60176),
('Beautiful Beach Property', 'msmith5@gmail.com', 'You can walk out of the house and be on the beach!', 2, 975, '456 Beach Ave', 'Miami', 'FL', 33101),
('Family Beach House', 'ellie2@gmail.com', 'You can literally walk onto the beach and see it from the patio!',6, 850, '1132 Beach Ave', 'Miami', 'FL', 33101),
('Texas Roadhouse', 'mscott22@gmail.com', 'This property is right in the center of Dallas, Texas!', 3, 450, '17th Street', 'Dallas', 'TX', 75043),
('Texas Longhorns House', 'mscott22@gmail.com', 'You can walk to the longhorns stadium from here!', 10, 600, '1125 Longhorns Way', 'Dallas', 'TX', 75001);

drop table if exists amenities;
create table amenities (
	p_name char(100) NOT NULL,
    owners char(50) NOT NULL,
    amenities_name char(100) NOT NULL,
    primary key (p_name,owners,amenities_name), 
    constraint amenities_ibfk_1 foreign key (owners,p_name) references property(owners,property_name)
) engine = InnoDB;


insert into amenities values
('Atlanta Great Property','scooper3@gmail.com','A/C & Heating'),
('Atlanta Great Property','scooper3@gmail.com','Pets allowed'),
('Atlanta Great Property','scooper3@gmail.com','Wifi & TV'),
('Atlanta Great Property','scooper3@gmail.com','Washer and Dryer'),
('House near Georgia Tech','gburdell3@gmail.com','Wifi & TV'),
('House near Georgia Tech','gburdell3@gmail.com','Washer and Dryer'),
('House near Georgia Tech','gburdell3@gmail.com','Full Kitchen'),
('New York City Property','cbing10@gmail.com','A/C & Heating'),
('New York City Property','cbing10@gmail.com','Wifi & TV'),
('Statue of Libery Property','mgeller5@gmail.com','A/C & Heating'),
('Statue of Libery Property','mgeller5@gmail.com','Wifi & TV'),
('Los Angeles Property','arthurread@gmail.com','A/C & Heating'),
('Los Angeles Property','arthurread@gmail.com','Pets allowed'),
('Los Angeles Property','arthurread@gmail.com','Wifi & TV'),
('LA Kings House','arthurread@gmail.com','A/C & Heating'),
('LA Kings House','arthurread@gmail.com','Wifi & TV'),
('LA Kings House','arthurread@gmail.com','Washer and Dryer'),
('LA Kings House','arthurread@gmail.com','Full Kitchen'),
('Beautiful San Jose Mansion','arthurread@gmail.com','A/C & Heating'),
('Beautiful San Jose Mansion','arthurread@gmail.com','Pets allowed'),
('Beautiful San Jose Mansion','arthurread@gmail.com','Wifi & TV'),
('Beautiful San Jose Mansion','arthurread@gmail.com','Washer and Dryer'),
('Beautiful San Jose Mansion','arthurread@gmail.com','Full Kitchen'),
('LA Lakers Property','lebron6@gmail.com','A/C & Heating'),
('LA Lakers Property','lebron6@gmail.com','Wifi & TV'),
('LA Lakers Property','lebron6@gmail.com','Washer and Dryer'),
('LA Lakers Property','lebron6@gmail.com','Full Kitchen'),
('Chicago Blackhawks House','hwmit@gmail.com','A/C & Heating'),
('Chicago Blackhawks House','hwmit@gmail.com','Wifi & TV'),
('Chicago Blackhawks House','hwmit@gmail.com','Washer and Dryer'),
('Chicago Blackhawks House','hwmit@gmail.com','Full Kitchen'),
('Chicago Romantic Getaway','mj23@gmail.com','A/C & Heating'),
('Chicago Romantic Getaway','mj23@gmail.com','Wifi & TV'),
('Beautiful Beach Property','msmith5@gmail.com','A/C & Heating'),
('Beautiful Beach Property','msmith5@gmail.com','Wifi & TV'),
('Beautiful Beach Property','msmith5@gmail.com','Washer and Dryer'),
('Family Beach House','ellie2@gmail.com','A/C & Heating'),
('Family Beach House','ellie2@gmail.com','Pets allowed'),
('Family Beach House','ellie2@gmail.com','Wifi & TV'),
('Family Beach House','ellie2@gmail.com','Washer and Dryer'),
('Family Beach House','ellie2@gmail.com','Full Kitchen'),
('Texas Roadhouse','mscott22@gmail.com','A/C & Heating'),
('Texas Roadhouse','mscott22@gmail.com','Pets allowed'),
('Texas Roadhouse','mscott22@gmail.com','Wifi & TV'),
('Texas Roadhouse','mscott22@gmail.com','Washer and Dryer'),
('Texas Longhorns House','mscott22@gmail.com','A/C & Heating'),
('Texas Longhorns House','mscott22@gmail.com','Pets allowed'),
('Texas Longhorns House','mscott22@gmail.com','Wifi & TV'),
('Texas Longhorns House','mscott22@gmail.com','Washer and Dryer'),
('Texas Longhorns House','mscott22@gmail.com','Full Kitchen');


DROP TABLE IF EXISTS review;
CREATE TABLE review (
    property_ID char(100) NOT NULL,
    owners char(50) NOT NULL,
    customer char(50) NOT NULL,
    content varchar(300) NOT NULL, 
    score int NOT NULL,
    primary key (customer,owners,property_ID),
    constraint review_ibfk_1 foreign key (customer) References vacation_account (email),
    constraint review_ibfk_2 foreign key (owners,property_ID) references property(owners,property_name)
)	ENGINE=InnoDB;
    
    
INSERT INTO review values
('House near Georgia Tech','gburdell3@gmail.com','swilson@gmail.com','This was so much fun. I went and saw the coke factory, the falcons play, GT play, and the Georgia aquarium. Great time! Would highly recommend!',5),
('New York City Property','cbing10@gmail.com','aray@tiktok.com','This was the best 5 days ever! I saw so much of NYC!',5),
('Statue of Libery Property','mgeller5@gmail.com','bshelton@gmail.com','This was truly an excellent experience. I really could see the Statue of Liberty from the property!',4),
('Los Angeles Property','arthurread@gmail.com','lbryan@gmail.com','I had an excellent time!',4),
('Beautiful San Jose Mansion','arthurread@gmail.com','tswift@gmail.com',"We had a great time, but the house wasn't fully cleaned when we arrived",3),
('LA Lakers Property','lebron6@gmail.com','jseinfeld@gmail.com','I was disappointed that I did not meet lebron james',2),
('Chicago Blackhawks House','hwmit@gmail.com','maddiesmith@gmail.com','This was awesome! I met one player on the chicago blackhawks!',5);


drop table if exists reserve;
create table reserve (
	property_ID char(100) NOT NULL,
    owners char(50) NOT NULL,
    customer char(50) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    num_guests int NOT NULL,
    primary key (property_ID,owners,customer),
    constraint reserve_ibfk_1 foreign key (customer) References vacation_account (email),
    constraint reserve_ibfk_2 foreign key (owners,property_ID) references property(owners,property_name)
)engine = InnoDB;


INSERT INTO reserve values
('House near Georgia Tech','gburdell3@gmail.com','swilson@gmail.com','2021-10-19','2021-10-25',3),
('New York City Property','cbing10@gmail.com','aray@tiktok.com','2021-10-18','2021-10-23',2),
('New York City Property','cbing10@gmail.com','cdemilio@tiktok.com','2021-10-24','2021-10-30',2),
('Statue of Libery Property','mgeller5@gmail.com','bshelton@gmail.com','2021-10-18','2021-10-22',4),
('Los Angeles Property','arthurread@gmail.com','lbryan@gmail.com','2021-10-19','2021-10-25',2),
('Beautiful San Jose Mansion','arthurread@gmail.com','tswift@gmail.com','2021-10-19','2021-10-22',10),
('LA Lakers Property','lebron6@gmail.com','jseinfeld@gmail.com','2021-10-19','2021-10-24',4),
('Chicago Blackhawks House','hwmit@gmail.com','maddiesmith@gmail.com','2021-10-19','2021-10-23',2),
('Chicago Romantic Getaway','mj23@gmail.com','aray@tiktok.com','2021-11-01','2021-11-07',2),
('Beautiful Beach Property','msmith5@gmail.com','cbing10@gmail.com','2021-10-18','2021-10-25',2),
('Family Beach House','ellie2@gmail.com','hwmit@gmail.com','2021-10-18','2021-10-28',5);

DROP TABLE IF EXISTS airline;
CREATE TABLE airline (
    airline_name char(100) NOT NULL,
    rating decimal (2,1) NOT NULL,
    PRIMARY KEY (airline_name)
) ENGINE=InnoDB;

INSERT INTO airline VALUES
('Delta Airlines',4.7),
('Southwest Airlines',4.4),
('American Airlines',4.6),
('United Airlines',4.2),
('JetBlue Airways',3.6),
('Spirit Airlines',3.3),
('WestJet',3.9),
('Interjet',3.7);


DROP TABLE IF EXISTS airport;
CREATE TABLE airport (
	street char(30) NOT NULL,
    city char(20) NOT NULL,
    state char(2) NOT NULL,
	zip decimal(5,0) NOT NULL,
    airport_ID char(3) NOT NULL,
    airport_name char(100) NOT NULL,
    timezone char(3) NOT NULL,
    PRIMARY KEY (airport_ID),
	UNIQUE KEY (street, city, state, zip, airport_name)
) ENGINE=InnoDB;

INSERT INTO airport VALUES
('6000 N Terminal Pkwy','Atlanta','GA',30320,'ATL','Atlanta Hartsfield Jackson Airport','EST'),
('455 Airport Ave','Queens','NY',11430,'JFK','John F Kennedy International Airport','EST'),
('790 Airport St','Queens','NY',11370,'LGA','Laguardia Airport','EST'),
('1 World Way','Los Angeles','CA',90045,'LAX','Lost Angeles International Airport','PST'),
('1702 Airport Blvd','San Jose','CA',95110,'SJC','Norman Y. Mineta San Jose International Airport','PST'),
("10000 W O'Hare Ave",'Chicago','IL',60666,'ORD',"O'Hare International Airport",'CST'),
('2100 NW 42nd Ave','Miami','FL',33126,'MIA','Miami International Airport','EST'),
('2400 Aviation DR','Dallas','TX',75261,'DFW','Dallas International Airport','CST');

DROP TABLE IF EXISTS flight;
CREATE TABLE flight (
	flight_num decimal(3,0) Not Null,
	air_name char(100) NOT NULL,
    from_airportID char(3) NOT NULL,
    to_airportID char(3) NOT NULL,
	deparature_time char(10) Not Null,
    arrival_time char(10) Not Null,
    date_flight date Not NUll,
    cost decimal(6,0) Not Null,
    capacity int Not Null,
    PRIMARY KEY (air_name,flight_num),
    CONSTRAINT flight_ibfk_1 FOREIGN KEY (air_name) REFERENCES airline (airline_name),
    CONSTRAINT flight_ibfk_2 FOREIGN KEY (from_airportID) REFERENCES airport (airport_ID),
    CONSTRAINT flight_ibfk_3 FOREIGN KEY (to_airportID) REFERENCES airport (airport_ID)
) ENGINE=InnoDB;

INSERT INTO flight VALUES
(1,'Delta Airlines','ATL','JFK','10:00 AM','12:00 PM','2021-10-18',400,150),
(2,'Southwest Airlines','ORD','MIA','10:30 AM','2:30 PM','2021-10-18',350,125),
(3,'American Airlines','MIA','DFW','1:00 PM','4:00 PM',	'2021-10-18',350,125),
(4,'United Airlines','ATL','LGA','4:30 PM','6:30 PM','2021-10-18',400,100),
(5,'JetBlue Airways','LGA','ATL','11:00 AM','1:00 PM','2021-10-19',400,130),
(6,'Spirit Airlines','SJC','ATL','12:30 PM','9:30 PM','2021-10-19',650,140),
(7,'WestJet','LGA','SJC','1:00 PM','4:00 PM','2021-10-19',700, 100),
(8,'Interjet','MIA','ORD','7:30 PM','9:30 PM','2021-10-19',350, 125),
(9,'Delta Airlines','JFK','ATL','8:00 AM','10:00 AM','2021-10-20',375,150),
(10,'Delta Airlines','LAX','ATL','9:15 AM','6:15 PM','2021-10-20',700,110),
(11,'Southwest Airlines','LAX','ORD','12:07 PM','7:07 PM','2021-10-20',600,95),
(12,'United Airlines','MIA','ATL','3:35 PM','5:35 PM','2021-10-20',275,115);

DROP TABLE IF EXISTS book;
CREATE TABLE book (
	customer char(50) NOT NULL,
    f_num decimal(3,0) NOT NULL,
    a_name char(100) NOT NULL,
    num_seats int NOT NULL,
    PRIMARY KEY (customer,a_name,f_num), 
    CONSTRAINT book_ibfk_4 FOREIGN KEY (customer) REFERENCES vacation_account (email),
    CONSTRAINT book_ibfk_5 FOREIGN KEY (a_name,f_num) REFERENCES flight (air_name,flight_num) 
) ENGINE=InnoDB;

INSERT INTO book VALUES
('swilson@gmail.com',5,'JetBlue Airways',3),
('aray@tiktok.com',1,'Delta Airlines',2),
('bshelton@gmail.com',4,'United Airlines',4),
('lbryan@gmail.com',7,'WestJet',2),
('tswift@gmail.com',7,'WestJet',2),
('jseinfeld@gmail.com',7,'WestJet',4),
('maddiesmith@gmail.com',8,'Interjet',2),
('cbing10@gmail.com',2,'Southwest Airlines',2),
('hwmit@gmail.com',	2,'Southwest Airlines',5);



DROP TABLE IF EXISTS airportattractions;
CREATE TABLE airportattractions(
	airport_ID char(3) NOT NULL,
    attractions_name char(100) NOT NULL,
    PRIMARY KEY (airport_ID, attractions_name),
    CONSTRAINT airportattractions_on_ibfk_1 FOREIGN KEY (airport_ID) REFERENCES airport (airport_ID)
) ENGINE=InnoDB;

INSERT INTO airportattractions VALUES
('ATL','The Coke Factory'),
('ATL','The Georgia Aquarium'),
('JFK','The Statue of Liberty'),
('JFK','The Empire State Building'),
('LGA','The Statue of Liberty'),
('LGA','The Empire State Building'),
('LAX','Lost Angeles Lakers Stadium'),
('LAX','Los Angeles Kings Stadium'),
('SJC','Winchester Mystery House'),
('SJC','San Jose Earthquakes Soccer Team'),
('ORD','Chicago Blackhawks Stadium'),
('ORD','Chicago Bulls Stadium'),
('MIA','Crandon Park Beach'),
('MIA','Miami Heat Basketball Stadium'),
('DFW','Texas Longhorns Stadium'),
('DFW','The Original Texas Roadhouse');

DROP TABLE IF EXISTS is_close;
CREATE TABLE is_close(
	propertyname char(100) NOT NULL,
	owneremail char(50) NOT NULL,
    airport_ID char(3) NOT NULL,
	distance decimal(2,0) NOT NULL,
    PRIMARY KEY (propertyname, owneremail, airport_ID),
    CONSTRAINT is_close_on_ibfk_1 FOREIGN KEY (owneremail,propertyname) REFERENCES property (owners,property_name),
    CONSTRAINT is_close_on_ibfk_2 FOREIGN KEY (airport_ID) REFERENCES airport (airport_ID)
) ENGINE=InnoDB;

INSERT INTO is_close VALUES
('Atlanta Great Property','scooper3@gmail.com','ATL',12),
('House near Georgia Tech','gburdell3@gmail.com','ATL',7),
('New York City Property','cbing10@gmail.com','JFK',10),
('Statue of Libery Property','mgeller5@gmail.com','JFK',8),
('New York City Property','cbing10@gmail.com','LGA',25),
('Statue of Libery Property','mgeller5@gmail.com','LGA',19),
('Los Angeles Property','arthurread@gmail.com','LAX',9),
('LA Kings House','arthurread@gmail.com','LAX',12),
('Beautiful San Jose Mansion','arthurread@gmail.com','SJC',8),
('Beautiful San Jose Mansion','arthurread@gmail.com','LAX',30),
('LA Lakers Property','lebron6@gmail.com','LAX',6),
('Chicago Blackhawks House','hwmit@gmail.com','ORD',11),
('Chicago Romantic Getaway','mj23@gmail.com','ORD',13),
('Beautiful Beach Property','msmith5@gmail.com','MIA',21),
('Family Beach House','ellie2@gmail.com','MIA',19),
('Texas Roadhouse','mscott22@gmail.com','DFW',8),
('Texas Longhorns House','mscott22@gmail.com','DFW',17);


































    
    