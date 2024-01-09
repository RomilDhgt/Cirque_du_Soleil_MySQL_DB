#GROUP MEMBERS
#Nick Nikolov
#Tahmid Kazi
#Andrew (Jinwoo) Lee
#Romil Dhagat

USE Cirque_du_Soleil;

#Query 2 A Basic Retrieval Query
SELECT * FROM SHOWS;

#Query 3 A retrieval query with ordered results
SELECT V.Name, V.Capacity FROM Venue as V
ORDER BY V.Capacity;

# Query 4 - Nested Retrieval Query
SELECT P.FirstName, P.LastName
FROM Performer AS P
WHERE P.PerformerID = (
    SELECT E.PerformerID
    FROM Eme_Contact AS E
    WHERE E.Relationship = 'Sister'
);

#Query 5 - Retrieval Query using joined tables
SELECT P.FirstName, P.LastName, P.DietInformation, M.Instrument
from Performer AS P 
JOIN Musician M ON P.PerformerID = M.PerformerID;

#Query 6 - An update Operation with Necessary triggers
#example that will activate the trigger - cannot set the birthday in the furture
#UPDATE Performer SET Birthdate = '2025-01-01' WHERE PerformerID = 1;
#example that will work correctly - birthday is valid
UPDATE Performer SET Birthdate = '2020-01-01' WHERE PerformerID = 1;


#Query 7 - A deletion operation with necessary triggers
#Example that will cause a trigger because we are cancelling an event that is about to perform (As of the current date December 6, 2023)
#DELETE FROM Hosting WHERE HostingID = 1;
#Example that will work correctly because the hosting is cancelled well in advance
DELETE FROM Hosting WHERE HostingID = 2;


