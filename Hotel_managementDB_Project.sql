-- Create database
CREATE DATABASE HospitalityHotelDb;

-- Use database
--USE HospitalityHotelDb;

-- Create GuestMaster table
CREATE TABLE GuestMaster (
    GuestID NVARCHAR(5) PRIMARY KEY,
    GuestName NVARCHAR(50) NOT NULL,
    RoomID NVARCHAR(5) NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    StateID NVARCHAR(5) NOT NULL
);

-- Insert data into GuestMaster table
INSERT INTO GuestMaster (GuestID, GuestName, RoomID, CheckInDate, CheckOutDate, StateID)
VALUES 
('G01', 'John Doe', 'R01', '2024-08-01', '2024-08-05', '101'),
('G02', 'Jane Smith', 'R02', '2024-08-02', '2024-08-07', '102'),
('G03', 'Mike Johnson', 'R03', '2024-08-03', '2024-08-08', '103'),
('G04', 'Sara Williams', 'R04', '2024-08-04', '2024-08-09', '104'),
('G05', 'David Brown', 'R05', '2024-08-05', '2024-08-10', '105'),
('G06', 'Emma Davis', 'R06', '2024-08-06', '2024-08-11', '106'),
('G07', 'Frank Miller', 'R07', '2024-08-07', '2024-08-12', '107'),
('G08', 'Grace Wilson', 'R08', '2024-08-08', '2024-08-13', '108'),
('G09', 'Henry Moore', 'R09', '2024-08-09', '2024-08-14', '109'),
('G10', 'Linda Taylor', 'R10', '2024-08-10', '2024-08-15', '110');
SELECT * FROM GuestMaster


-- Create Room table
CREATE TABLE Room (
    RoomID NVARCHAR(5) PRIMARY KEY,
    RoomType NVARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Status NVARCHAR(50) NOT NULL
);

-- Insert data into Room table
INSERT INTO Room (RoomID, RoomType, Price, Status)
VALUES 
('R01', 'Single', 100.00, 'Booked'),
('R02', 'Double', 200.00, 'Booked'),
('R03', 'Suite', 500.00, 'Booked'),
('R04', 'Deluxe', 300.00, 'Booked'),
('R05', 'Single', 100.00, 'Booked'),
('R06', 'Double', 200.00, 'Booked'),
('R07', 'Suite', 500.00, 'Booked'),
('R08', 'Deluxe', 300.00, 'Booked'),
('R09', 'Single', 100.00, 'Booked'),
('R10', 'Suite', 500.00, 'Booked');
SELECT * FROM Room


-- Create Booking table
CREATE TABLE Booking (
    BookingID NVARCHAR(5) PRIMARY KEY,
    GuestID NVARCHAR(5) NOT NULL,
    RoomID NVARCHAR(5) NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL
);

-- Insert data into Booking table
INSERT INTO Booking (BookingID, GuestID, RoomID, CheckInDate, CheckOutDate, TotalAmount)
VALUES 
('B01', 'G01', 'R01', '2024-08-01', '2024-08-05', 400.00),
('B02', 'G02', 'R02', '2024-08-02', '2024-08-07', 1000.00),
('B03', 'G03', 'R03', '2024-08-03', '2024-08-08', 2500.00),
('B04', 'G04', 'R04', '2024-08-04', '2024-08-09', 1500.00),
('B05', 'G05', 'R05', '2024-08-05', '2024-08-10', 500.00),
('B06', 'G06', 'R06', '2024-08-06', '2024-08-11', 1000.00),
('B07', 'G07', 'R07', '2024-08-07', '2024-08-12', 2500.00),
('B08', 'G08', 'R08', '2024-08-08', '2024-08-13', 1500.00),
('B09', 'G09', 'R09', '2024-08-09', '2024-08-14', 500.00),
('B10', 'G10', 'R10', '2024-08-10', '2024-08-15', 2500.00)
SELECT * FROM Booking


	   --CREATING STATEMASTER TABLE
CREATE TABLE Statemaster_h( StateID NVARCHAR(5)
PRIMARY KEY, StateName nvarchar(50) not null)
INSERT INTO Statemaster_h(StateID, StateName)
VALUES ( '101', 'Lagos'),
        ( '102', 'Abuja'),
		( '103', 'Kano'),
		( '104', 'Delta'),
		( '105', 'Ido'),
		( '106', 'Ibada'),
		( '107', 'Enugu'),
		( '108', 'Kaduna'),
		( '109', 'Ogun'),
		( '110', 'Anambra')
		SELECT * FROM Statemaster_h



-- Fetch guests who stayed for the same number of days:

SELECT *
FROM GuestMaster
WHERE CAST(CheckOutDate AS datetime) - CAST(CheckInDate AS datetime) IN (
  SELECT Duration
  FROM (
    SELECT 
      CAST(CheckOutDate AS datetime) - CAST(CheckInDate AS datetime) AS Duration,
      COUNT(*) AS Count
    FROM GuestMaster
    GROUP BY 
      CAST(CheckOutDate AS datetime) - CAST(CheckInDate AS datetime)
  ) AS DerivedTable
  WHERE Count > 1
)



-- Find the second most expensive booking and the guest associated with it:

WITH RankedBooking AS (
  SELECT 
    B.BookingID, 
    B.GuestID, 
    B.TotalAmount, 
    ROW_NUMBER() OVER (ORDER BY B.TotalAmount DESC) AS rowNum
  FROM 
    Booking B
)
SELECT 
  BookingID, 
  GuestID, 
  TotalAmount
FROM 
  RankedBooking
WHERE 
  rowNum = 2


--Get the maximum room price per room type and the guest name:

WITH RankedRoom AS (
  SELECT 
    R.RoomType, 
    R.Price, 
    G.GuestName, 
    ROW_NUMBER() OVER (PARTITION BY R.RoomType ORDER BY R.Price DESC) AS rowNum
  FROM 
    Room R
  INNER JOIN 
    GuestMaster G ON R.RoomID = G.RoomID
)
SELECT 
  RoomType, 
  Price, 
  GuestName
FROM 
  RankedRoom
WHERE 
  rowNum = 1


--Room type-wise count of guests sorted by count in descending order:

SELECT 
  R.RoomType, 
  COUNT(G.GuestID) AS CountOfGuests
FROM 
  Room R
INNER JOIN 
  GuestMaster G ON R.RoomID = G.RoomID
GROUP BY 
  R.RoomType
ORDER BY 
  CountOfGuests DESC


-- Fetch only the first name from the GuestName and append the total amount spent:

SELECT 
  CONCAT(LEFT(G.GuestName, CHARINDEX(' ', G.GuestName) - 1),
  '_', B.TotalAmount) AS FirstName_TotalAmount
FROM 
  GuestMaster G
INNER JOIN 
  Booking B ON G.GuestID = B.GuestID


-- Fetch bookings with odd total amounts:

SELECT * 
FROM Booking 
WHERE TotalAmount % 2 <> 0


--Create a view to fetch bookings with a total amount greater than $1000:

CREATE VIEW VW_BookingDetails AS 
SELECT * 
FROM Booking 
WHERE TotalAmount > 1000


-- Create a procedure to update the room prices by 10% where the room type is 'Suite' and the state is not 'Lagos':

CREATE PROCEDURE SP_UpdateRoomPrice 
AS
BEGIN
  UPDATE R
  SET R.Price = R.Price * 1.10
  FROM Room R
  INNER JOIN GuestMaster G ON R.RoomID = G.RoomID
  INNER JOIN Statemaster_h S ON G.StateID = S.StateID
  WHERE R.RoomType = 'Suite' AND S.StateName <> 'Lagos'
END
GO
EXEC SP_UpdateRoomPrice


--Create a stored procedure to fetch booking details along with the guest,
--room, and state, including error handling:

CREATE PROCEDURE SP_GetBookingDetails 
AS
BEGIN
  BEGIN TRY
    SELECT 
      B.BookingID, 
      G.GuestName, 
      R.RoomType, 
      S.StateName, 
      B.TotalAmount
    FROM 
      Booking B
    INNER JOIN 
      GuestMaster G ON B.GuestID = G.GuestID
    INNER JOIN 
      Room R ON G.RoomID = R.RoomID
    INNER JOIN 
      Statemaster_h S ON G.StateID = S.StateID
  END TRY
  BEGIN CATCH
    DECLARE @ErrorMessage nvarchar(4000)
    SET @ErrorMessage = ERROR_MESSAGE()
    RAISERROR (@ErrorMessage, 16, 1)
  END CATCH
END
GO
EXEC SP_GetBookingDetails
