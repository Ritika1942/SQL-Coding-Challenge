--tasks
--1.creating database Petpals
CREATE DATABASE PetPal

--2.table creation
--Creating pets tbl
CREATE TABLE Pets (
PetID INT PRIMARY KEY IDENTITY(1,1),  
Name VARCHAR(100),                    
Age INT,                             
Breed VARCHAR(100),                
Type VARCHAR(50),                     
AvailableForAdoption BIT             
)

--creating shelters tbl
CREATE TABLE Shelters (
ShelterID INT PRIMARY KEY IDENTITY(1,1),  
Name VARCHAR(100),                        
Location VARCHAR(200)                     
)

--creating donations tbl
CREATE TABLE Donations(
DonationID INT PRIMARY KEY IDENTITY(1,1), 
DonorName VARCHAR(100),                   
DonationType VARCHAR(50),               
DonationAmount DECIMAL(10, 2),            
DonationItem VARCHAR(100),              
DonationDate DATETIME                     
)

--creating adoption events tbl
CREATE TABLE AdoptionEvents (
EventID INT PRIMARY KEY IDENTITY(1,1),    
EventName VARCHAR(100),                  
EventDate DATETIME,                    
Location VARCHAR(200)                    
)

--creating participants tbl
CREATE TABLE Participants(
ParticipantID INT PRIMARY KEY IDENTITY(1,1),
ParticipantName VARCHAR(100),
ParticipantType VARCHAR(50),
EventID INT,
FOREIGN KEY (EventID) REFERENCES AdoptionEvents(EventID)
)

--inseritn values into the table
INSERT INTO Pets (Name, Age, Breed, Type, AvailableForAdoption) VALUES
('Jimmy', 3, 'Golden Retriever', 'Dog', 1),
('Jammy', 2, 'Labrador', 'Cat', 0),
('Rosy', 5, 'PitBull', 'Dog', 1),
('Charlie', 1, 'Husky', 'Cat', 1),
('Tiger', 4, 'Beagle', 'Dog', 0)

--inserting into shelter table
INSERT INTO Shelters (Name, Location) VALUES
('Happy Paws Shelter', '123 Abc St, Chennai'),
('Furry Friends Haven', '456 rdc St, Coimbatore'),
('Animal Rescue Center', '789 hap St, Trivandrum'),
('Paws and Claws', '101 zxc St, Chennai'),
('Safe Heaven for Pets', '202 Bhy St, Madurai')

--inserting -donations table
INSERT INTO Donations (DonorName, DonationType, DonationAmount, DonationItem, DonationDate) VALUES
('Anisha', 'Cash', 150.00, NULL, '2024-10-15 10:30:00'),
('Amulya', 'Item', NULL, 'Dog Food', '2024-10-18 14:45:00'),
('Caroline', 'Cash', 200.00, NULL, '2024-10-20 09:00:00'),
('Kavinayan', 'Item', NULL, 'Cat Litter', '2024-10-22 11:15:00'),
('Velu', 'Cash', 75.00, NULL, '2024-10-25 16:30:00')

--inserting-adoption events
INSERT INTO AdoptionEvents (EventName, EventDate, Location) VALUES
('Pet Adoption Fair', '2024-11-01 10:00:00', 'semmozhi Park, Chennai'),
('Holiday Pet Rescue', '2024-12-15 09:30:00', 'Gandhi Square, Coimbatore'),
('Summer Paws Adoption Day', '2025-06-20 12:00:00', 'Town Hall, Trivandrum'),
('National Pet Day Celebration', '2025-04-11 10:00:00', 'Pet Expo Center, Chennai'),
('Adopt for you Weekend', '2025-09-05 14:00:00', 'Animal Shelter, Madurai')

--insertion- participants table

INSERT INTO Participants (ParticipantName, ParticipantType, EventID) VALUES
('Happy Paws Shelter', 'Shelter', 1),
('Furry Friends Haven', 'Shelter', 2),
('Anisha', 'Adopter', 1),
('Amulya', 'Adopter', 3),
('Animal Rescue Center', 'Shelter', 4)

--5.SQL query that retrieves a list of pets available for adoption
SELECT Name, Age,Breed,Type
FROM Pets
WHERE AvailableForAdoption=1

/*6.Write an SQL query that retrieves the names of participants (shelters and adopters) registered 
for a specific adoption event. Use a parameter to specify the event ID. Ensure that the query 
joins the necessary tables to retrieve the participant names and types.*/
DECLARE @EventID INT
SET @EventID=1

SELECT P.ParticipantName, P.ParticipantType
FROM Participants AS P
JOIN AdoptionEvents AS AE ON P.EventID = AE.EventID
WHERE AE.EventID = @EventID

-- Inserting two new participants for adoption events
INSERT INTO Participants (ParticipantName, ParticipantType, EventID) VALUES
('Sri', 'Adopter', 1),  
('Avantika', 'Adopter', 2)  

--7.SP
/*8.Write an SQL query that calculates and retrieves the total donation amount for each shelter (by 
shelter name) from the "Donations" table. The result should include the shelter name and the 
total donation amount. Ensure that the query handles cases where a shelter has received no 
donations.*/
SELECT S.Name AS ShelterName, 
COALESCE(SUM(D.DonationAmount), 0) AS TotalDonationAmount
FROM Shelters S
LEFT JOIN Donations D ON S.Name = D.DonorName  
GROUP BY S.Name

/*9.Write an SQL query that retrieves the names of pets from the "Pets" table that do not have an 
owner (i.e., where "OwnerID" is null). Include the pet's name, age, breed, and type in the result 
set*/
ALTER TABLE Pets
ADD ParticipantID INT

ALTER TABLE Pets
ADD CONSTRAINT FK_Pet_Participant
FOREIGN KEY (ParticipantID) REFERENCES Participants(ParticipantID)

UPDATE Pets
SET ParticipantID = 1
WHERE PetID=1


SELECT Name, Age, Breed, Type
FROM Pets
WHERE ParticipantID IS NULL

/*10.Write an SQL query that retrieves the total donation amount for each month and year (e.g., 
January 2023) from the "Donations" table. The result should include the month-year and the 
corresponding total donation amount. Ensure that the query handles cases where no donations 
were made in a specific month-year.*/
SELECT YEAR(DonationDate) as Year,MONTH(DonationDate) as Month,                   
SUM(DonationAmount) as TotalDonationAmount     
FROM Donations
GROUP BY YEAR(DonationDate),MONTH(DonationDate)                             
ORDER BY YEAR(DonationDate),MONTH(DonationDate)  

--11.Retrieve a list of distinct breeds for all pets that are either aged between 1 and 3 years or older than 5 years.
SELECT DISTINCT Breed
FROM Pets
WHERE(Age BETWEEN 1 AND 3) or Age>5

--12.Retrieve a list of pets and their respective shelters where the pets are currently available for adoption.
SELECT p.Name as PetName, s.Name as ShelterName
FROM Pets p
JOIN Shelters s on p.AvailableForAdoption=1

--13.Find the total number of participants in events organized by shelters located in specific city.
--Example: City=Chennai
SELECT COUNT(*) AS TotalParticipants
FROM Participants p
JOIN AdoptionEvents ae ON p.EventID = ae.EventID
JOIN Shelters s ON ae.Location = s.Location
WHERE s.Location = 'Chennai'

--14.Retrieve a list of unique breeds for pets with ages between 1 and 5 years.
SELECT DISTINCT Breed
FROM Pets
WHERE Age BETWEEN 1 AND 5

--15.Find the pets that have not been adopted by selecting their information from the 'Pet' table
SELECT Name, Age, Breed, Type
FROM Pets
WHERE AvailableForAdoption = 0  

--16.Retrieve the names of all adopted pets along with the adopter's name from the 'Adoption' and 'User' tables.
SELECT p.Name as PetName, pt.ParticipantName as AdopterName
FROM Pets p
JOIN Participants pt on p.ParticipantID = pt.ParticipantID
WHERE pt.ParticipantType = 'Adopter'


--17.Retrieve a list of all shelters along with the count of pets currently available for adoption in each shelter
ALTER TABLE Pets
ADD ShelterID INT
--FK constraint to link pets table to shelters
ALTER TABLE Pets
ADD CONSTRAINT FK_Pet_Shelter
FOREIGN KEY (ShelterID) REFERENCES Shelters(ShelterID)

UPDATE Pets
SET ShelterID = 1
WHERE PetID = 1

SELECT s.Name as ShelterName, 
COUNT(p.PetID) as AvailablePetsCount
FROM Shelters s
LEFT JOIN Pets p on s.ShelterID = p.ShelterID
WHERE p.AvailableForAdoption = 1
GROUP BY s.Name
--18.Find pairs of pets from the same shelter that have the same breed.
SELECT p1.Name AS Pet1_Name, p2.Name AS Pet2_Name, p1.Breed
FROM Pets p1
JOIN Pets p2 ON p1.ShelterID = p2.ShelterID AND p1.Breed = p2.Breed
WHERE p1.PetID < p2.PetID

INSERT INTO Pets (Name, Age, Breed, Type, AvailableForAdoption, ShelterID)VALUES
('Buddy', 2, 'Golden Retriever', 'Dog', 1, 1),  
('Bella', 3, 'Golden Retriever', 'Dog', 1, 1)

--19.List all possible combinations of shelters and adoption events.
SELECT s.Name as ShelterName,ae.EventName as EventName,ae.EventDate,ae.Location as EventLocation
FROM Shelters s
CROSS JOIN AdoptionEvents ae
ORDER BY ShelterName,EventName

--20.Determine the shelter that has the highest number of adopted pet
SELECT TOP 1 s.Name as ShelterName, 
COUNT(p.PetID) as AdoptedPetsCount
FROM Pets p
JOIN Shelters s on p.ShelterID = s.ShelterID
WHERE p.AvailableForAdoption = 0  
GROUP BY s.Name
ORDER BY AdoptedPetsCount DESC

INSERT INTO Pets (Name, Age, Breed, Type, AvailableForAdoption, ShelterID) 
VALUES
('Bella', 2, 'Golden Retriever', 'Dog', 0, 1),  
('Max', 3, 'Labrador', 'Dog', 0, 2)






























