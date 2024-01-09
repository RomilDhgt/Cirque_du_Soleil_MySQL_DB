#GROUP MEMBERS
#Nick Nikolov
#Tahmid Kazi
#Andrew (Jinwoo) Lee
#Romil Dhagat

DROP DATABASE IF EXISTS Cirque_du_Soleil;
CREATE DATABASE Cirque_du_Soleil;
USE Cirque_du_Soleil;

CREATE TABLE Shows (
    ShowName 	VARCHAR(255) 	NOT NULL,
    ShowYear 	INT 			NOT NULL,
    Sponsor 	VARCHAR(255)	NOT NULL,
    Producer 	VARCHAR(255) 	NOT NULL,
    PRIMARY KEY (ShowName, ShowYear)
);

INSERT INTO Shows (ShowName, ShowYear, Sponsor, Producer) VALUES
('Alegria', 2023, 'Cirque Partners', 'Creative Productions Inc.'),
('Kooza', 2025, 'Entertainment Enterprises', 'Artistic Visionaries Ltd.'),
('Corteo', 2010, 'Showcase Sponsorship', 'Global Productions'),
('Alegria', 1993, 'Mystical Entertainment', 'Innovative Productions'),
('Kooza', 1998, 'Aquatic Arts Group', 'Theatrical Wonders Inc.'),
('Corteo', 2001, 'Boom Partners', 'Global Productions');

CREATE TABLE Performer (
    PerformerID 	INT 										 NOT NULL	PRIMARY KEY AUTO_INCREMENT,
    FirstName 		VARCHAR(255) 								 NOT NULL,
    LastName 		VARCHAR(255) 								 NOT NULL,
    Citizenship 	VARCHAR(255)								 NOT NULL,
    Birthdate 		DATE 										 NOT NULL,
    DietInformation VARCHAR(255),
    UnderstudyID  	INT,
    PerformerType 	ENUM('Musician', 'Aerialist', 'Entertainer') NOT NULL,
    ShowName 		VARCHAR(255)								 NOT NULL,
    ShowYear 		INT											 NOT NULL,
    FOREIGN KEY (ShowName, ShowYear) REFERENCES Shows(ShowName, ShowYear) ON DELETE CASCADE
);

DELIMITER $$
CREATE TRIGGER VALID_BIRTHDATE
BEFORE UPDATE ON Performer
FOR EACH ROW 
BEGIN
	IF NEW.Birthdate > CURDATE() THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Performer must be born before the current date!';
	END IF;
END $$
DELIMITER ;

INSERT INTO Performer (FirstName, LastName, Citizenship, Birthdate, DietInformation, UnderstudyID, PerformerType, ShowName, ShowYear) VALUES
('John', 'Doe', 'USA', '1990-01-01', 'Vegan', 5, 'Musician', 'Alegria', 2023),
('Jane', 'Smith', 'Canada', '1991-02-02', 'Vegetarian', 6, 'Entertainer', 'Kooza', 2025),
('Alice', 'Johnson', 'UK', '1992-03-03', 'None', NULL, 'Aerialist',  'Corteo', 2010),
('Mike', 'Brown', 'Australia', '1985-05-15', 'Vegetarian', NULL, 'Musician',  'Alegria', 1993),
('Emily', 'Davis', 'USA', '1988-08-20', 'None', NULL, 'Entertainer',  'Kooza', 1998),
('Mark', 'Taylor', 'Canada', '1990-10-10', 'Vegan', 3, 'Aerialist',  'Corteo', 2001);

CREATE TABLE Musician (
    PerformerID 	INT				NOT NULL,
    Instrument 		VARCHAR(255) 	NOT NULL,
    PRIMARY KEY (PerformerID, Instrument),
    FOREIGN KEY (PerformerID) REFERENCES Performer(PerformerID) ON DELETE CASCADE
);

INSERT INTO Musician (PerformerID, Instrument) VALUES
(1, 'Guitar'),
(4, 'Piano');

CREATE TABLE Aerialist (
    PerformerID 	INT				NOT NULL,
    Sport 			VARCHAR(255) 	NOT NULL,
    Equipment 		VARCHAR(255) 	NOT NULL,
    PRIMARY KEY (PerformerID, Sport, Equipment),
    FOREIGN KEY (PerformerID) REFERENCES Performer(PerformerID)
);

INSERT INTO Aerialist (PerformerID, Sport, Equipment) VALUES
(3, 'Aerial Hoop', 'Safety Belt'),
(6, 'Aerial Dance', 'Helmet');

CREATE TABLE Entertainer (
    PerformerID 		INT				NOT NULL,
    MainAct 			VARCHAR(255) 	NOT NULL,
    PRIMARY KEY (PerformerID, MainAct),
    FOREIGN KEY (PerformerID) REFERENCES Performer(PerformerID) ON DELETE CASCADE
);

INSERT INTO Entertainer (PerformerID, MainAct) VALUES
(2, 'Fire Juggling'),
(5, 'Fire Eater');

CREATE TABLE Medications (
    PerformerID 		INT				NOT NULL,
    MedicationName 		VARCHAR(255) 	NOT NULL,
    PRIMARY KEY (PerformerID, MedicationName),
    FOREIGN KEY (PerformerID) REFERENCES Performer(PerformerID) ON DELETE CASCADE
);

INSERT INTO Medications (PerformerID, MedicationName) VALUES
(1, 'Aspirin'),
(2, 'Ibuprofen'),
(4, 'Naproxen'),
(5, 'Acetaminophen');

CREATE TABLE Venue (
    VenueID 			INT 			PRIMARY KEY AUTO_INCREMENT,
    Name 				VARCHAR(255) 	NOT NULL,
    Capacity 			INT 			NOT NULL,
    StreetAddress 		VARCHAR(255) 	NOT NULL,
    City				VARCHAR(255)	NOT NULL,
    ProvinceState		VARCHAR(255)	NOT NULL,
    TransitAccessible 	BOOLEAN			NOT NULL
);

INSERT INTO Venue (Name, Capacity, StreetAddress, City, ProvinceState, TransitAccessible) VALUES
('Grand Theater', 2000, '123 Maple Avenue', 'Toronto', 'Ontario', true),
('City Arena', 1500, '101 Pine Street', 'New York City', 'New York', false),
('Sky Pavilion', 1800, '456 Oak Street', 'Vancouver', 'British Columbia', true),
('Ocean Theater', 2200, '234 Cedar Lane', 'Los Angeles', 'California', true),
('Mountain Hall', 1800, '789 Elm Road', 'Montreal', 'Quebec', false),
('Garden Arena', 2000, '345 Birch Drive', 'Chicago', 'Illinois', true);

CREATE TABLE Hosting (
    HostingID 		INT 			NOT NULL PRIMARY KEY AUTO_INCREMENT,
    ShowName 		VARCHAR(255)	NOT NULL,
    ShowYear 		INT				NOT NULL,
    VenueID 		INT				NOT NULL,
    HostDate 		DATE			NOT NULL,
    FOREIGN KEY (ShowName, ShowYear) REFERENCES Shows(ShowName, ShowYear) ON DELETE CASCADE,
    FOREIGN KEY (VenueID) REFERENCES Venue(VenueID) ON DELETE CASCADE
);

#This will not allow the host to cancel the show within 3 days of the performance, 
DELIMITER $$
CREATE TRIGGER LAST_MINUTE_DELETE
BEFORE DELETE ON Hosting
FOR EACH ROW 
BEGIN
	IF DATEDIFF(OLD.HostDate, CURDATE()) < 3 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'You cannot cancel the show within 3 days of the showing date! You will suffer a fine for last minute cancellation';
	END IF;
END $$
DELIMITER ;

INSERT INTO Hosting (ShowName, ShowYear, VenueID, HostDate) VALUES
('Alegria', 2023, 1, '2023-12-07'),
('Kooza', 2025, 2, '2025-02-02'),
('Corteo', 2010, 3, '2010-03-03'),
('Alegria', 1993, 4, '1993-05-15'),
('Kooza', 1998, 5, '1998-08-20'),
('Corteo', 2001, 6, '2001-10-10');

CREATE TABLE Eme_Contact (
    PerformerID 			INT				NOT NULL,
    FirstName 				VARCHAR(255) 	NOT NULL,
    LastName 				VARCHAR(255) 	NOT NULL,
    PhoneNumber 			VARCHAR(20) 	NOT NULL,
    Relationship 			VARCHAR(255) 	NOT NULL,
    PRIMARY KEY (PerformerID, FirstName),
    FOREIGN KEY (PerformerID) REFERENCES Performer(PerformerID) ON DELETE CASCADE
);

INSERT INTO Eme_Contact (PerformerID, FirstName, LastName, PhoneNumber, Relationship) VALUES
(1, 'Jen', 'Lee', '111-222-3333', 'Friend'),
(2, 'Nick', 'King', '222-333-4444', 'Brother'),
(3, 'Yajur', 'Patel', '333-444-5555', 'Spouse'),
(4, 'Tahmid', 'Person', '444-555-6666', 'Friend'),
(5, 'Sarah', 'Shah', '555-666-7777', 'Sister'),
(6, 'Andrew', 'Lee', '666-777-8888', 'Spouse');
