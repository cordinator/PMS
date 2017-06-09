USE [master]
GO
/****** Object:  Database [PMS]    Script Date: 6/9/2017 11:35:35 PM ******/
CREATE DATABASE [PMS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PMS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\PMS.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'PMS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\PMS_log.ldf' , SIZE = 6912KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [PMS] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PMS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PMS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PMS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PMS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PMS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PMS] SET ARITHABORT OFF 
GO
ALTER DATABASE [PMS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PMS] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [PMS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PMS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PMS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PMS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PMS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PMS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PMS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PMS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PMS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [PMS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PMS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PMS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PMS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PMS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PMS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PMS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PMS] SET RECOVERY FULL 
GO
ALTER DATABASE [PMS] SET  MULTI_USER 
GO
ALTER DATABASE [PMS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PMS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PMS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PMS] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [PMS]
GO
/****** Object:  User [pmsadmin]    Script Date: 6/9/2017 11:35:35 PM ******/
CREATE USER [pmsadmin] FOR LOGIN [pmsadmin] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [pmsadmin]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [pmsadmin]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [pmsadmin]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [pmsadmin]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [pmsadmin]
GO
ALTER ROLE [db_datareader] ADD MEMBER [pmsadmin]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [pmsadmin]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [pmsadmin]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [pmsadmin]
GO
/****** Object:  StoredProcedure [dbo].[GETALLBOOKINGS]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Sachin Tyagi  
-- Create date: April 29, 2017  
-- Description: This stored procedure shall get the details of booking based on the checkin and checkoutdate  
-- =============================================  
--Exec GETALLBOOKINGS 1, '2017-06-01', '2017-06-02'  
 
CREATE PROCEDURE [dbo].[GETALLBOOKINGS]  
 @PROPERTYID INT,  
 @CHECKINTIME DATETIME = NULL,  
 @CHECKOUTDATE DATETIME = NULL  
AS  
BEGIN  

IF(CONVERT(TIME,@CHECKOUTDATE)= '00:00:00.0000000')
 set @CHECKOUTDATE = @CHECKOUTDATE + '23:59:59'

SELECT   
  distinct BK.ID  
 ,BK.PROPERTYID  
 ,BK.CHECKINTIME  
 ,BK.CHECKOUTTIME  
 ,GUEST.FIRSTNAME  
 ,GUEST.LASTNAME
 ,GUEST.ID AS GUESTID
 ,RB.ID AS ROOMBOOKINGID
 ,ROOM.ID AS ROOMID
 ,ROOM.Number AS ROOMNUMBER
 
 FROM BOOKING BK INNER JOIN ROOMBOOKING RB   
 ON BK.ID = RB.BOOKINGID  
 INNER JOIN Room
 ON RB.RoomID = Room.ID
 INNER JOIN GUEST  
 ON RB.GUESTID = GUEST.ID  
 WHERE BK.CHECKINTIME >= ISNULL(@CHECKINTIME,'1900-01-01')  
 AND BK.CHECKOUTTIME <= ISNULL(stuff(convert(varchar(19), @CHECKOUTDATE, 126),11,1,' '), GETDATE()) AND BK.ISACTIVE=1  
END
GO
/****** Object:  StoredProcedure [dbo].[GETALLGUESTS]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Sachin Tyagi  
-- Create date: May 26, 2017  
-- Description: This stored procedure shall return all the guest details 
-- =============================================  
--Exec GETALLGUESTS
 
CREATE PROCEDURE [dbo].[GETALLGUESTS] 
AS  
BEGIN  


SELECT   
  ID  
 ,FIRSTNAME
 ,LASTNAME
 ,MOBILENUMBER
 ,EMAILADDRESS  
 ,DOB
 ,GENDER
 ,PHOTOPATH
 FROM GUEST
END
GO
/****** Object:  StoredProcedure [dbo].[GETBOOKINGAMOUNT]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Sachin Tyagi  
-- Create date: June 04, 2017  
-- Description: This stored procedure shall return the amount of booking
-- =============================================  
--Exec GETBOOKINGAMOUNT 1,1,1,3,0,1

CREATE PROC [dbo].[GETBOOKINGAMOUNT]  
@PROPERTYID INT,  
@ROOMTYPEID INT,  
@RATETYPEID INT,  
@NOOFHOURS INT,  
@NOOFDAYS INT,  
@ISHOURLY BIT  
AS BEGIN  
--CREATE TEMP TABLE TO HOLD THE KEY VALUE PAIR TO RETURN THE DETAIL OF THE INVOICE  
  
CREATE TABLE #TMPINVOICEDETAILS(  
ITEM NVARCHAR(100),  
ITEMAMOUNT MONEY)  
  
-- ROOM BOOKING AMOUNT  
INSERT INTO #TMPINVOICEDETAILS(ITEM, ITEMAMOUNT)  
SELECT 'ROOM CHARGES'   
  ,CASE WHEN (@ISHOURLY = 1) THEN  VALUE ELSE VALUE * @NOOFDAYS END    
  FROM RATES WHERE   
  PROPERTYID =@PROPERTYID AND   
  ROOMTYPEID = @ROOMTYPEID AND   
  (INPUTKEYHOURS IS NULL OR INPUTKEYHOURS = @NOOFHOURS)  
    
-- TAX DETAILS  
INSERT INTO #TMPINVOICEDETAILS(ITEM, ITEMAMOUNT)  
SELECT ALLTAXES.TAXSHORTNAME, TAXES.VALUE FROM TAXES INNER JOIN ALLTAXES ON  
TAXES.TAXID = ALLTAXES.ID AND TAXES.PROPERTYID = @PROPERTYID  
  
SELECT ITEM,ITEMAMOUNT FROM #TMPINVOICEDETAILS  
  
END
GO
/****** Object:  StoredProcedure [dbo].[GETGUESTTRANSACTIONS]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Sachin Tyagi    
-- Create date: MAY 13, 2017    
-- Description: This stored procedure shall return the histroy of guest transaction
-- Exec [GETGUESTTRANSACTIONS] 44
-- =============================================    
CREATE PROCEDURE [dbo].[GETGUESTTRANSACTIONS]
	@GUESTID INT    
 AS    
BEGIN    
  
WITH ROOMBOOKING_CTE(ROOMBOOKINGID, BOOKINGID, ROOMID, PropertyID)  
AS  
(  
SELECT   
 ROOMBOOKING.ID,   
 BOOKING.ID,
 ROOMID,
 BOOKING.PROPERTYID
FROM ROOMBOOKING  
  
INNER JOIN   
BOOKING ON  
BOOKING.ID = ROOMBOOKING.BOOKINGID   
WHERE  ROOMBOOKING.GUESTID = @GUESTID 
) 
 
SELECT DISTINCT  
PROPERTY.PROPERTYDETAILS AS PROPERTY,
Booking.CheckinTime,
Booking.CheckoutTime,  
RoomType.Name AS ROOMTYPE,
Room.Number AS ROOMNUMBER
FROM PROPERTY  
Inner join 
ROOMBOOKING_CTE ON  
ROOMBOOKING_CTE.PropertyID = PROPERTY.ID
INNER JOIN
BOOKING ON 
ROOMBOOKING_CTE.BOOKINGID = BOOKING.ID
INNER JOIN
ROOM ON
ROOM.ID = ROOMBOOKING_CTE.ROOMID
INNER JOIN
RoomType ON
ROOM.ROOMTYPEID = RoomType.ID
END  
GO
/****** Object:  StoredProcedure [dbo].[GETROOMSTATUS]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Sachin Tyagi    
-- Create date: MAY 06, 2017    
-- Description: This stored procedure shall get the status of the room based on the checkin and checkout date  
-- =============================================    
--Exec GETROOMSTATUS 1, '2017-05-15 21:24:34.000', '2017-06-18 21:24:34.000','1'  
    
CREATE PROCEDURE [dbo].[GETROOMSTATUS]    
 @PROPERTYID INT,    
 @CHECKINTIME DATETIME = NULL,    
 @CHECKOUTDATE DATETIME = NULL  
AS    
BEGIN    
  
WITH ROOMBOOKING_CTE(ROOMBOOKINGID, ROOMID)  
AS  
(  
SELECT   
 ROOMBOOKING.ID,   
 ROOMID   
FROM ROOMBOOKING  
  
INNER JOIN   
BOOKING ON  
BOOKING.ID = ROOMBOOKING.BOOKINGID   
WHERE BOOKING.CHECKINTIME >=@CHECKINTIME AND BOOKING.CHECKOUTTIME <=@CHECKOUTDATE  
) 
 
SELECT DISTINCT  
ROOM.ID,  
ROOM.ROOMTypeID,  
NUMBER,  
ROOMSTATUS = CASE WHEN ISNULL(ROOMBOOKING_CTE.ROOMID,'') = '' THEN 'AVAILABLE' ELSE 'BOOKED' END  
FROM ROOM  
LEFT OUTER JOIN  
ROOMBOOKING_CTE ON  
ROOMBOOKING_CTE.ROOMID = ROOM.ID   
where ROOM.PROPERTYID=@PROPERTYID 
  
--SELECT DISTINCT  
--ROOM.ID,  
--ROOM.ROOMTypeID,  
--NUMBER,  
--ROOMSTATUS = CASE WHEN ISNULL(ROOMBOOKING.ROOMID,'') = '' THEN 'AVAILABLE' ELSE 'BOOKED' END  
--FROM ROOM   
--LEFT OUTER JOIN   
  
  
--ROOMBOOKING   
--ON ROOM.ID = ROOMBOOKING.ROOMID  
--LEFT OUTER JOIN  
--BOOKING  
--ON BOOKING.ID = ROOMBOOKING.BOOKINGID  
--WHERE ROOM.ROOMTYPEID = @ROOMTYPEID   
----AND BOOKING.CHECKINTIME >=@CHECKINTIME AND BOOKING.CHECKOUTTIME <=@CHECKOUTDATE  
END  
GO
/****** Object:  StoredProcedure [dbo].[InsertBooking]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertBooking]          
 @propertyID INT,          
 @bookingXML XML = NULL          
AS          
BEGIN          
 SET NOCOUNT ON          
 BEGIN TRAN           
 BEGIN TRY          
            
 DECLARE @hDoc INT          
  IF @bookingXML IS NOT NULL          
  BEGIN          
   DECLARE @SavedBookingIDTable Table (OldBookingID INT, NewBookingID INT)          
   DECLARE @SavedGuestIDTable Table (OldGuestID INT, NewGuestID INT)          
   DECLARE @SavedGuestMappingIDTable Table(OldGuestMappingID INT, NewGuestMappingID INT)        
          
   EXEC sp_xml_preparedocument @hDoc OUTPUT,@bookingXML           
          
   -- Start - Merge INTO Booking          
  MERGE INTO           
  [Booking] AS [TargetBooking]          
  USING           
   (          
    SELECT           
      XMLTable.Id,            
      XMLTable.CheckinTime,            
      XMLTable.CheckoutTime,            
      XMLTable.NoOfAdult,            
      XMLTable.NoOfChild,            
      XMLTable.GuestRemarks,            
      XMLTable.TransactionRemarks, 
      XMLTable.ISHOURLYCHECKIN,
      XMLTable.HOURSTOSTAY,           
      XMLTable.IsActive,            
      XMLTable.CreatedBy,            
      XMLTable.CreatedOn,            
      XMLTable.LastUpdatedBy,            
      XMLTable.LastUpdatedOn          
    FROM           
     OPENXML(@hDoc, 'Booking',2)          
     WITH          
     (          
      Id int,            
      CheckinTime DateTime,            
      CheckoutTime DateTime,            
      NoOfAdult int,            
      NoOfChild int,            
      GuestRemarks nvarchar(200),            
      TransactionRemarks nvarchar(200),            
      ISHOURLYCHECKIN bit,
      HOURSTOSTAY int,
      IsActive bit,            
      CreatedBy nvarchar(200),            
      CreatedOn Datetime,            
      LastUpdatedBy nvarchar(200),            
      LastUpdatedOn DateTime          
     ) XMLTable            
   ) AS [SourceBooking]          
  ON [TargetBooking].ID = [SourceBooking].ID          
  WHEN MATCHED THEN          
  UPDATE           
   SET           
       [TargetBooking].CheckinTime = [SourceBooking].CheckinTime          
      ,[TargetBooking].CheckoutTime = [SourceBooking].CheckoutTime            
      ,[TargetBooking].NoOfAdult = [SourceBooking].NoOfAdult            
      ,[TargetBooking].NoOfChild = [SourceBooking].NoOfChild          
      ,[TargetBooking].GuestRemarks = [SourceBooking].GuestRemarks            
      ,[TargetBooking].TransactionRemarks = [SourceBooking].TransactionRemarks          
      ,[TargetBooking].ISHOURLYCHECKIN = [SourceBooking].ISHOURLYCHECKIN          
      ,[TargetBooking].HOURSTOSTAY = [SourceBooking].HOURSTOSTAY          
      ,[TargetBooking].IsActive = [SourceBooking].IsActive            
      ,[TargetBooking].CreatedBy = [SourceBooking].CreatedBy          
      ,[TargetBooking].CreatedOn = [SourceBooking].CreatedOn           
      ,[TargetBooking].LastUpdatedBy = [SourceBooking].LastUpdatedBy           
      ,[TargetBooking].LastUpdatedOn = [SourceBooking].LastUpdatedOn          
  WHEN NOT MATCHED THEN          
  INSERT (  PropertyID,            
      CheckinTime,            
      CheckoutTime,            
      NoOfAdult,            
      NoOfChild,            
      GuestRemarks,            
      TransactionRemarks,
      ISHOURLYCHECKIN,            
      HOURSTOSTAY,
      IsActive,            
      CreatedBy,            
      CreatedOn,            
      LastUpdatedBy,            
      LastUpdatedOn)          
   VALUES           
    (          
     @propertyID,          
     [SourceBooking].CheckinTime,            
     [SourceBooking].CheckoutTime,            
     [SourceBooking].NoOfAdult,            
     [SourceBooking].NoOfChild,            
     [SourceBooking].GuestRemarks,            
     [SourceBooking].TransactionRemarks,            
     [SourceBooking].ISHOURLYCHECKIN,
     [SourceBooking].HOURSTOSTAY,
     [SourceBooking].IsActive,            
     [SourceBooking].CreatedBy,            
     [SourceBooking].CreatedOn,            
     [SourceBooking].LastUpdatedBy,            
     [SourceBooking].LastUpdatedOn          
    )          
          
   OUTPUT [SourceBooking].ID, inserted.ID INTO @SavedBookingIDTable(OldBookingID,NewBookingID);          
             
  MERGE INTO          
  [Guest] AS [TargetGuest]          
  USING           
   (          
    SELECT           
      XMLTable.Id,            
      XMLTable.FirstName,            
      XMLTable.LastName,            
      XMLTable.MobileNumber,            
      XMLTable.EmailAddress,            
      XMLTable.DOB,  
      XMLTable.Gender,            
      XMLTable.PhotoPath,              
      XMLTable.IsActive,            
      XMLTable.CreatedBy,            
      XMLTable.CreatedOn,            
      XMLTable.LastUpdatedBy,            
      XMLTable.LastUpdatedOn          
    FROM           
     OPENXML(@hDoc, 'Booking/Guests/Guest',2)          
     WITH          
     (          
      Id int,            
      FirstName nvarchar(200),            
      LastName nvarchar(200),            
      MobileNumber bigint,            
      EmailAddress nvarchar(500),            
      DOB Date,   
      Gender nvarchar(10),            
      PhotoPath nvarchar(200),            
      IsActive bit,            
      CreatedBy nvarchar(200),            
      CreatedOn Datetime,            
      LastUpdatedBy nvarchar(200),            
      LastUpdatedOn DateTime          
     ) XMLTable            
   ) AS [SourceGuest]          
  ON [TargetGuest].ID = [SourceGuest].ID          
  WHEN MATCHED THEN          
  UPDATE           
   SET           
       [TargetGuest].FirstName = [SourceGuest].FirstName          
      ,[TargetGuest].LastName = [SourceGuest].LastName            
      ,[TargetGuest].MobileNumber = [SourceGuest].MobileNumber            
      ,[TargetGuest].EmailAddress = [SourceGuest].EmailAddress          
      ,[TargetGuest].DOB = [SourceGuest].DOB  
      ,[TargetGuest].Gender = [SourceGuest].Gender            
      ,[TargetGuest].PhotoPath = [SourceGuest].PhotoPath          
      ,[TargetGuest].IsActive = [SourceGuest].IsActive            
      ,[TargetGuest].CreatedBy = [SourceGuest].CreatedBy          
      ,[TargetGuest].CreatedOn = [SourceGuest].CreatedOn           
      ,[TargetGuest].LastUpdatedBy = [SourceGuest].LastUpdatedBy           
      ,[TargetGuest].LastUpdatedOn = [SourceGuest].LastUpdatedOn          
  WHEN NOT MATCHED THEN          
  INSERT (              
      FirstName,            
      LastName,            
      MobileNumber,            
      EmailAddress,            
      DOB,  
      Gender,            
      PhotoPath,              
      IsActive,            
      CreatedBy,            
      CreatedOn,            
      LastUpdatedBy,            
      LastUpdatedOn          
      )          
   VALUES           
    (          
      [SourceGuest].FirstName,            
      [SourceGuest].LastName,            
      [SourceGuest].MobileNumber,            
      [SourceGuest].EmailAddress,            
      [SourceGuest].DOB,  
      [SourceGuest].Gender,            
      [SourceGuest].PhotoPath,              
      [SourceGuest].IsActive,            
      [SourceGuest].CreatedBy,            
      [SourceGuest].CreatedOn,            
      [SourceGuest].LastUpdatedBy,            
      [SourceGuest].LastUpdatedOn          
    )          
   OUTPUT [SourceGuest].ID, inserted.ID INTO @SavedGuestIDTable(OldGuestID,NewGuestID);          
           
              
  MERGE INTO          
  [GuestMapping] AS [TargetGuestMapping]          
  USING           
   (          
    SELECT           
      XMLTable.Id,            
      XMLTable.IDTYPEID,            
      GuestID = case when (XMLTable.GuestID < 0) then  GuestIDTable.NewGuestID else XMLTable.GuestID end,        
      XMLTable.IDDETAILS,        
      XMLTable.IdExpiryDate,        
      XMLTable.IdIssueState,        
      XMLTable.IdIssueCountry,            
      XMLTable.IsActive,            
      XMLTable.CreatedBy,            
      XMLTable.CreatedOn,            
      XMLTable.LastUpdatedBy,            
      XMLTable.LastUpdatedOn          
    FROM           
     OPENXML(@hDoc, 'Booking/GuestMappings/GuestMapping',2)          
     WITH          
     (          
      Id int,            
      IDTYPEID int,            
      GUESTID int,         
      IDDETAILS nvarchar(max),           
      IdExpiryDate DateTime,        
      IdIssueState nvarchar(100),        
      IdIssueCountry nvarchar(100),        
      IsActive bit,            
      CreatedBy nvarchar(200),            
      CreatedOn Datetime,            
      LastUpdatedBy nvarchar(200),            
      LastUpdatedOn DateTime          
     ) XMLTable          
     LEFT OUTER JOIN          
     @SavedGuestIDTable AS GuestIDTable          
     ON GuestIDTable.OldGuestID = XMLTable.GuestID        
   ) AS [SourceGuestMapping]          
  ON [TargetGuestMapping].ID = [SourceGuestMapping].ID          
  WHEN MATCHED THEN          
  UPDATE           
   SET           
       [TargetGuestMapping].IDTYPEID = [SourceGuestMapping].IDTYPEID          
      ,[TargetGuestMapping].GUESTID = [SourceGuestMapping].GUESTID            
      ,[TargetGuestMapping].IDDETAILS = [SourceGuestMapping].IDDETAILS         
      ,[TargetGuestMapping].IdExpiryDate = [SourceGuestMapping].IdExpiryDate         
      ,[TargetGuestMapping].IdIssueState = [SourceGuestMapping].IdIssueState         
      ,[TargetGuestMapping].IdIssueCountry = [SourceGuestMapping].IdIssueCountry            
      ,[TargetGuestMapping].IsActive = [SourceGuestMapping].IsActive            
      ,[TargetGuestMapping].CreatedBy = [SourceGuestMapping].CreatedBy          
      ,[TargetGuestMapping].CreatedOn = [SourceGuestMapping].CreatedOn           
      ,[TargetGuestMapping].LastUpdatedBy = [SourceGuestMapping].LastUpdatedBy           
      ,[TargetGuestMapping].LastUpdatedOn = [SourceGuestMapping].LastUpdatedOn          
  WHEN NOT MATCHED THEN          
  INSERT (              
      IDTYPEID,            
      GUESTID,            
      IDDETAILS,         
      IdExpiryDate,        
      IdIssueState,        
      IdIssueCountry,           
      IsActive,            
      CreatedBy,            
      CreatedOn,            
      LastUpdatedBy,            
      LastUpdatedOn          
      )          
   VALUES           
    (          
      [SourceGuestMapping].IDTYPEID,            
      [SourceGuestMapping].GUESTID,            
      [SourceGuestMapping].IDDETAILS,        
      [SourceGuestMapping].IdExpiryDate,        
      [SourceGuestMapping].IdIssueState,        
      [SourceGuestMapping].IdIssueCountry,            
      [SourceGuestMapping].IsActive,            
      [SourceGuestMapping].CreatedBy,            
      [SourceGuestMapping].CreatedOn,            
      [SourceGuestMapping].LastUpdatedBy,            
      [SourceGuestMapping].LastUpdatedOn          
    )          
   OUTPUT [SourceGuestMapping].ID, inserted.ID INTO @SavedGuestMappingIDTable(OldGuestMappingID,NewGuestMappingID);          
         
   MERGE INTO          
  [AdditionalGuests] AS [TargetAdditionalGuests]          
  USING           
   (          
    SELECT           
      XMLTable.Id,            
      BookingId = case when (XMLTable.BookingId < 0) then  BookingIDTable.NewBookingID else XMLTable.BookingId end,     
      XMLTable.FirstName,        
      XMLTable.LastName,        
      XMLTable.GUESTIDPath,        
      XMLTable.IsActive,            
      XMLTable.CreatedBy,            
      XMLTable.CreatedOn,            
      XMLTable.LastUpdatedBy,            
      XMLTable.LastUpdatedOn          
    FROM           
     OPENXML(@hDoc, 'Booking/AdditionalGuests/AdditionalGuest',2)          
     WITH          
     (          
      Id int,            
      BookingID int,            
      FirstName nvarchar(100),           
      LastName nvarchar(100),        
      GUESTIDPath nvarchar(max),        
      IsActive bit,            
      CreatedBy nvarchar(200),            
      CreatedOn Datetime,            
      LastUpdatedBy nvarchar(200),            
      LastUpdatedOn DateTime          
     ) XMLTable          
     LEFT OUTER JOIN          
     @SavedBookingIDTable AS BookingIDTable          
     ON BookingIDTable.OldBookingID = XMLTable.BookingId     
   ) AS [SourceAdditionalGuests]          
  ON [TargetAdditionalGuests].ID = [SourceAdditionalGuests].ID          
  WHEN MATCHED THEN          
  UPDATE           
   SET           
       [TargetAdditionalGuests].FirstName = [SourceAdditionalGuests].FirstName          
      ,[TargetAdditionalGuests].LastName = [SourceAdditionalGuests].LastName            
      ,[TargetAdditionalGuests].GUESTIDPath = [SourceAdditionalGuests].GUESTIDPath         
      ,[TargetAdditionalGuests].IsActive = [SourceAdditionalGuests].IsActive            
      ,[TargetAdditionalGuests].CreatedBy = [SourceAdditionalGuests].CreatedBy          
      ,[TargetAdditionalGuests].CreatedOn = [SourceAdditionalGuests].CreatedOn           
      ,[TargetAdditionalGuests].LastUpdatedBy = [SourceAdditionalGuests].LastUpdatedBy           
      ,[TargetAdditionalGuests].LastUpdatedOn = [SourceAdditionalGuests].LastUpdatedOn          
  WHEN NOT MATCHED THEN          
  INSERT (              
      BookingID,            
      FirstName,            
      LastName,         
      GUESTIDPath,        
      IsActive,            
      CreatedBy,            
      CreatedOn,            
      LastUpdatedBy,            
      LastUpdatedOn          
      )          
   VALUES           
    (          
      [SourceAdditionalGuests].BookingID,            
      [SourceAdditionalGuests].FirstName,            
      [SourceAdditionalGuests].LastName,        
      [SourceAdditionalGuests].GUESTIDPath,        
      [SourceAdditionalGuests].IsActive,            
      [SourceAdditionalGuests].CreatedBy,            
      [SourceAdditionalGuests].CreatedOn,            
      [SourceAdditionalGuests].LastUpdatedBy,            
      [SourceAdditionalGuests].LastUpdatedOn          
    ) ;        
   --OUTPUT [SourceGuestMapping].ID, inserted.ID INTO @SavedGuestMappingIDTable(OldGuestMappingID,NewGuestMappingID);          
              
   MERGE INTO          
  [Address] AS [TargetAddress]          
  USING           
   (          
    SELECT           
      XMLTable.Id,            
      XMLTable.AddressTypeID,            
      GuestID = case when (XMLTable.GuestID < 0) then  GuestIDTable.NewGuestID else XMLTable.GuestID end,          
      XMLTable.Address1,            
      XMLTable.Address2,            
      XMLTable.City,            
      XMLTable.State,              
      XMLTable.ZipCode,          
      XMLTable.Country,          
      XMLTable.isActive,            
      XMLTable.CreatedBy,            
      XMLTable.CreatedOn,            
      XMLTable.LastUpdatedBy,            
      XMLTable.LastUpdatedOn          
    FROM           
     OPENXML(@hDoc, 'Booking/Addresses/Address',2)          
     WITH          
     (          
      Id int,            
      AddressTypeID int,            
      GuestID int,            
      Address1 nvarchar(200),          
      Address2 nvarchar(200),          
      City nvarchar(200),           
      State nvarchar(200),            
      ZipCode nvarchar(40),            
      Country nvarchar(200),          
      IsActive bit,            
      CreatedBy nvarchar(200),            
      CreatedOn Datetime,            
      LastUpdatedBy nvarchar(200),            
      LastUpdatedOn DateTime          
     ) XMLTable          
     LEFT OUTER JOIN          
     @SavedGuestIDTable AS GuestIDTable          
     ON GuestIDTable.OldGuestID = XMLTable.GuestID            
   ) AS [SourceAddress]          
  ON [TargetAddress].ID = [SourceAddress].ID          
  WHEN MATCHED THEN          
  UPDATE           
   SET           
       [TargetAddress].AddressTypeID =[SourceAddress].AddressTypeID             
      ,[TargetAddress].GuestID = [SourceAddress].GuestID            
      ,[TargetAddress].Address1 = [SourceAddress].Address1           
      ,[TargetAddress].Address2 =  [SourceAddress].Address2          
      ,[TargetAddress].City = [SourceAddress].City           
      ,[TargetAddress].State = [SourceAddress].State              
      ,[TargetAddress].ZipCode = [SourceAddress].ZipCode          
      ,[TargetAddress].Country =[SourceAddress].Country      
      ,[TargetAddress].IsActive = [SourceAddress].IsActive            
      ,[TargetAddress].CreatedBy = [SourceAddress].CreatedBy          
      ,[TargetAddress].CreatedOn = [SourceAddress].CreatedOn           
      ,[TargetAddress].LastUpdatedBy = [SourceAddress].LastUpdatedBy           
      ,[TargetAddress].LastUpdatedOn = [SourceAddress].LastUpdatedOn          
  WHEN NOT MATCHED THEN          
  INSERT (              
      AddressTypeID,            
      GuestID,            
      Address1,          
      Address2,          
      City,           
      State,            
      ZipCode,            
      Country,          
      IsActive,            
      CreatedBy,            
      CreatedOn,            
      LastUpdatedBy,            
      LastUpdatedOn          
      )          
   VALUES           
    (          
      [SourceAddress].AddressTypeID,            
      [SourceAddress].GuestID,            
      [SourceAddress].Address1,          
      [SourceAddress].Address2,          
      [SourceAddress].City,           
      [SourceAddress].State,            
      [SourceAddress].ZipCode,            
      [SourceAddress].Country,          
      [SourceAddress].IsActive,            
      [SourceAddress].CreatedBy,            
      [SourceAddress].CreatedOn,            
      [SourceAddress].LastUpdatedBy,            
      [SourceAddress].LastUpdatedOn          
    );          
             
  MERGE INTO          
  [RoomBooking] AS [TargetRoomBooking]          
  USING           
   (          
    SELECT           
      XMLTable.Id,          
      GuestID = case when (XMLTable.GuestID < 0) then  GuestIDTable.NewGuestID else XMLTable.GuestID end,          
      BookingId = case when (XMLTable.BookingId < 0) then  BookingIDTable.NewBookingID else XMLTable.BookingID end,          
      XMLTable.RoomId,           
      XMLTable.IsExtra,            
      XMLTable.Discount,            
      XMLTable.RoomCharges,            
      XMLTable.IsActive,            
      XMLTable.CreatedBy,            
      XMLTable.CreatedOn,            
      XMLTable.LastUpdatedBy,            
      XMLTable.LastUpdatedOn          
    FROM           
     OPENXML(@hDoc, 'Booking/RoomBookings/RoomBooking',2)          
     WITH          
     (          
      Id int,            
      GuestID int,            
      BookingId int,            
      RoomId int,            
      IsExtra bit,            
      Discount decimal,            
      RoomCharges decimal,            
      IsActive bit,            
      CreatedBy nvarchar,            
      CreatedOn Datetime,            
      LastUpdatedBy nvarchar,            
      LastUpdatedOn DateTime          
     ) XMLTable          
     LEFT Outer JOIN          
     @SavedGuestIDTable AS GuestIDTable          
     ON GuestIDTable.OldGuestID = XMLTable.GuestID          
     Left outer JOIN            
     @SavedBookingIDTable AS BookingIDTable          
     ON BookingIDTable.OldBookingID = XMLTable.BookingId          
   ) AS [SourceRoomBooking]          
  ON [TargetRoomBooking].ID = [SourceRoomBooking].ID          
  WHEN MATCHED THEN          
  UPDATE           
   SET           
             
       [TargetRoomBooking].IsExtra = [SourceRoomBooking].IsExtra          
       ,[TargetRoomBooking].GuestID = [SourceRoomBooking].GuestID            
       ,[TargetRoomBooking].RoomID = [SourceRoomBooking].RoomID            
      ,[TargetRoomBooking].Discount = [SourceRoomBooking].Discount            
      ,[TargetRoomBooking].RoomCharges = [SourceRoomBooking].RoomCharges            
      ,[TargetRoomBooking].IsActive = [SourceRoomBooking].IsActive            
      ,[TargetRoomBooking].CreatedBy = [SourceRoomBooking].CreatedBy          
      ,[TargetRoomBooking].CreatedOn = [SourceRoomBooking].CreatedOn           
      ,[TargetRoomBooking].LastUpdatedBy = [SourceRoomBooking].LastUpdatedBy           
      ,[TargetRoomBooking].LastUpdatedOn = [SourceRoomBooking].LastUpdatedOn          
  WHEN NOT MATCHED THEN          
  INSERT (        
      GuestID ,            
      BookingID ,            
      RoomID ,            
      IsExtra ,            
      Discount ,            
      RoomCharges,              
      IsActive,            
      CreatedBy,            
      CreatedOn,            
      LastUpdatedBy,            
      LastUpdatedOn          
      )          
   VALUES           
    (          
      [SourceRoomBooking].GuestID ,            
      [SourceRoomBooking].BookingID ,            
      [SourceRoomBooking].RoomID ,            
      [SourceRoomBooking].IsExtra ,            
      [SourceRoomBooking].Discount ,            
      [SourceRoomBooking].RoomCharges,              
      [SourceRoomBooking].IsActive,            
      [SourceRoomBooking].CreatedBy,            
      [SourceRoomBooking].CreatedOn,            
      [SourceRoomBooking].LastUpdatedBy,            
      [SourceRoomBooking].LastUpdatedOn          
    );          
              
 END          
 COMMIT TRAN          
 END TRY          
          
    BEGIN CATCH          
  ROLLBACK TRAN;          
 END CATCH          
              
    SET NOCOUNT OFF          
END            
          
          
GO
/****** Object:  StoredProcedure [dbo].[UpdateBooking]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================      
-- Author:  Sachin Tyagi      
-- Create date: MAY 16, 2017      
-- Description: This stored procedure shall update the booking checkin/checkout and room information in case of drag/drop feature.
-- =============================================      
      
CREATE PROCEDURE [dbo].[UpdateBooking]      
 @BOOKINGID INT,      
 @CHECKINTIME DATETIME,      
 @CHECKOUTTIME DATETIME,
 @RoomID INT     
AS      
BEGIN 

--TODO Transaction and Rollback mechanism and other contraints to avoid the updation of record with wrong value
UPDATE BOOKING SET CHECKINTIME=@CHECKINTIME, CHECKOUTTIME = @CHECKOUTTIME WHERE ID=@BOOKINGID
UPDATE ROOMBOOKING SET ROOMID=@ROOMID WHERE BOOKINGID=@BOOKINGID
END 
GO
/****** Object:  Table [dbo].[AdditionalGuests]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AdditionalGuests](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BookingId] [int] NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[GUESTIDPath] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_AdditionalGuests_IsActive]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[Gender] [nvarchar](10) NULL,
 CONSTRAINT [PK_AdditionalGuests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Address]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Address](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AddressTypeID] [int] NOT NULL,
	[GuestID] [int] NOT NULL,
	[Address1] [nvarchar](200) NULL,
	[Address2] [nvarchar](200) NULL,
	[City] [nvarchar](200) NULL,
	[State] [nvarchar](200) NULL,
	[ZipCode] [nvarchar](40) NULL,
	[Country] [nvarchar](200) NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF__Address__IsActiv__797309D9]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__Address__3214EC27EE6E9CCB] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AddressType]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AddressType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_AddressType_IsActive]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK__AddressT__3214EC279E125A55] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AllTaxes]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AllTaxes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TaxShortName] [nvarchar](100) NULL,
	[Description] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_AllTaxes_IsActive]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__AllTaxes__3214EC27AA32B3D3] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Booking]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Booking](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyID] [int] NOT NULL,
	[CheckinTime] [datetime] NULL,
	[CheckoutTime] [datetime] NULL,
	[NoOfAdult] [int] NULL,
	[NoOfChild] [int] NULL,
	[GuestRemarks] [nvarchar](200) NULL,
	[TransactionRemarks] [nvarchar](200) NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF__Booking__IsActiv__7A672E12]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[Status] [nvarchar](50) NULL,
	[ISHOURLYCHECKIN] [bit] NULL,
	[HOURSTOSTAY] [int] NULL,
 CONSTRAINT [PK__Booking__3214EC27D183E29A] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ChargableFacility]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChargableFacility](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FacilityShortName] [nvarchar](100) NULL,
	[Description] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__Chargabl__3214EC27DD965004] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[City]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[City](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[StateID] [int] NULL,
	[CountryID] [int] NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF__City__IsActive__7B5B524B]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__City__3214EC278D337EBF] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Country]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF__Country__IsActiv__7C4F7684]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__Country__3214EC27881DE460] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Currency]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Currency](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](100) NULL,
	[Description] [nvarchar](max) NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ExtraCharges]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExtraCharges](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyID] [int] NULL,
	[FacilityKey] [int] NULL,
	[Value] [money] NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_ExtraCharges] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Guest]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Guest](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](200) NULL,
	[LastName] [nvarchar](200) NULL,
	[MobileNumber] [bigint] NULL,
	[EmailAddress] [nvarchar](500) NULL,
	[DOB] [date] NULL,
	[Gender] [nvarchar](10) NULL,
	[PhotoPath] [nvarchar](200) NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF__Guest__IsActive__7D439ABD]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__Guest__3214EC27B26A2F31] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GuestMapping]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuestMapping](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDTYPEID] [int] NOT NULL,
	[GUESTID] [int] NOT NULL,
	[IDDETAILS] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF__GuestMapp__IsAct__7E37BEF6]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[IdExpiryDate] [datetime] NOT NULL,
	[IdIssueState] [nvarchar](50) NOT NULL,
	[IdIssueCountry] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK__GuestMap__3214EC27EE38DB4B] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GuestReward]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuestReward](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GuestID] [int] NOT NULL,
	[BookingID] [int] NOT NULL,
	[IsCredit] [bit] NULL,
	[ExpirationDate] [datetime] NULL,
	[NoOfPoints] [int] NULL,
	[Decription] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__GuestRew__3214EC27BE9BAFD4] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[IDType]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IDType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF__IDType__IsActive__00200768]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__IDType__3214EC2788EBEA0B] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GuestID] [int] NOT NULL,
	[BookingID] [int] NOT NULL,
	[IsPaid] [bit] NULL,
	[FolioNumber] [nvarchar](200) NULL,
	[ExtraCharges] [decimal](7, 2) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__Invoice__3214EC2766CAD2C9] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[InvoiceTaxDetail]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InvoiceTaxDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceID] [int] NOT NULL,
	[TaxAmount] [decimal](7, 2) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__InvoiceT__3214EC27D12730CC] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Property]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Property](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyDetails] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_Property_IsActive]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[PropertyName] [nvarchar](100) NULL,
	[SecondaryName] [nvarchar](100) NULL,
	[PropertyCode] [nvarchar](50) NULL,
	[FullAddress] [nvarchar](max) NULL,
	[Phone] [nvarchar](100) NULL,
	[Fax] [nvarchar](100) NULL,
	[LogoPath] [nvarchar](max) NULL,
	[WebSiteAddress] [nvarchar](100) NULL,
	[TimeZone] [nvarchar](100) NULL,
	[CurrencyID] [int] NULL,
	[CheckinTime] [time](7) NULL,
	[CheckoutTime] [time](7) NULL,
	[CloseOfDayTime] [time](7) NULL,
 CONSTRAINT [PK__Property__3214EC27AD6BF945] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Rates]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rates](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](20) NULL,
	[PropertyID] [int] NULL,
	[RateTypeID] [int] NULL,
	[RoomTypeID] [int] NULL,
	[InputKeyHours] [int] NULL,
	[Value] [money] NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_Rates_IsActive]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_Rates] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RateType]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RateType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyID] [int] NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_RateType_IsActive]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[NAME] [nvarchar](max) NOT NULL,
	[RoomTypeID] [int] NULL,
	[ShortName] [nvarchar](50) NULL,
 CONSTRAINT [PK__RateType__3214EC2725FEB820] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RewardCategory]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RewardCategory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RewardCategory] [nvarchar](200) NOT NULL,
	[NoOfPoints] [int] NULL,
	[Benefits] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__RewardCa__3214EC27122A8426] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Room]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Room](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyID] [int] NOT NULL,
	[RoomTypeID] [int] NOT NULL,
	[Number] [nvarchar](200) NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_Room_IsActive]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__Room__3214EC278D6C9E74] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RoomBooking]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomBooking](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GuestID] [int] NOT NULL,
	[BookingID] [int] NOT NULL,
	[RoomID] [int] NOT NULL,
	[IsExtra] [bit] NULL,
	[Discount] [decimal](7, 2) NULL,
	[RoomCharges] [decimal](7, 2) NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF__RoomBooki__IsAct__03F0984C]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__RoomBook__3214EC2709EFCFF0] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RoomPricing]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomPricing](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyID] [int] NOT NULL,
	[RoomTypeID] [int] NOT NULL,
	[RateTypeID] [int] NOT NULL,
	[BasePrice] [decimal](8, 2) NOT NULL,
	[ExtraPersonPrice] [decimal](8, 2) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__RoomPric__3214EC271DE61C1F] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RoomType]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyID] [int] NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_RoomType_IsActive]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[NAME] [nvarchar](max) NOT NULL,
	[ShortName] [nvarchar](50) NULL,
 CONSTRAINT [PK__RoomType__3214EC2783760BB1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[State]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[State](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[CountryID] [int] NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF__State__IsActive__05D8E0BE]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__State__3214EC27E166B7A6] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Taxes]    Script Date: 6/9/2017 11:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Taxes](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyID] [int] NULL,
	[TaxId] [int] NULL,
	[Value] [money] NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_Taxes_IsActive]  DEFAULT ((1)),
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[LastUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK__Taxes__3214EC270D4AC0D8] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[AdditionalGuests] ON 

INSERT [dbo].[AdditionalGuests] ([Id], [BookingId], [FirstName], [LastName], [GUESTIDPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Gender]) VALUES (6, NULL, N'additional name', N'additional last', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[AdditionalGuests] ([Id], [BookingId], [FirstName], [LastName], [GUESTIDPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Gender]) VALUES (7, NULL, N'add fname', N'add lname', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-05-18 15:35:27.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[AdditionalGuests] ([Id], [BookingId], [FirstName], [LastName], [GUESTIDPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Gender]) VALUES (8, NULL, N'add 1', N'add last', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-05-23 21:37:12.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[AdditionalGuests] ([Id], [BookingId], [FirstName], [LastName], [GUESTIDPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Gender]) VALUES (9, NULL, N'add1', N'add2', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-05-25 09:33:19.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[AdditionalGuests] ([Id], [BookingId], [FirstName], [LastName], [GUESTIDPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Gender]) VALUES (10, NULL, N'add1', N'add last1', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-05-25 10:05:09.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[AdditionalGuests] ([Id], [BookingId], [FirstName], [LastName], [GUESTIDPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Gender]) VALUES (11, NULL, N'add1', N'add2', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-05-25 11:14:42.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[AdditionalGuests] ([Id], [BookingId], [FirstName], [LastName], [GUESTIDPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Gender]) VALUES (12, NULL, N'add1', N'add2', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-05-25 11:20:02.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[AdditionalGuests] ([Id], [BookingId], [FirstName], [LastName], [GUESTIDPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Gender]) VALUES (1002, NULL, N'f1', N'l1', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-06-06 10:07:09.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[AdditionalGuests] ([Id], [BookingId], [FirstName], [LastName], [GUESTIDPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Gender]) VALUES (1003, NULL, N'ad1', N'ad2', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-06-07 09:33:59.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[AdditionalGuests] ([Id], [BookingId], [FirstName], [LastName], [GUESTIDPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Gender]) VALUES (1004, NULL, N'adf1', N'adf2', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-06-07 09:39:37.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[AdditionalGuests] ([Id], [BookingId], [FirstName], [LastName], [GUESTIDPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Gender]) VALUES (1005, NULL, N'adf1', N'adl1', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-06-07 10:08:41.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[AdditionalGuests] ([Id], [BookingId], [FirstName], [LastName], [GUESTIDPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Gender]) VALUES (1006, NULL, N'adf2', N'adl2', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-06-07 10:52:56.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[AdditionalGuests] ([Id], [BookingId], [FirstName], [LastName], [GUESTIDPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Gender]) VALUES (1007, NULL, N'ad1', N'ad2', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-06-07 23:00:41.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[AdditionalGuests] ([Id], [BookingId], [FirstName], [LastName], [GUESTIDPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Gender]) VALUES (1008, NULL, N'', N'', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-06-08 12:59:45.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[AdditionalGuests] OFF
SET IDENTITY_INSERT [dbo].[Address] ON 

INSERT [dbo].[Address] ([ID], [AddressTypeID], [GuestID], [Address1], [Address2], [City], [State], [ZipCode], [Country], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (45, 1, 49, N'', N'', N'4', N'2', N'201301', N'3', 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Address] ([ID], [AddressTypeID], [GuestID], [Address1], [Address2], [City], [State], [ZipCode], [Country], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (46, 1, 50, N'noida', N'noida', N'3', N'3', N'201301', N'2', 1, N'vipul', CAST(N'2017-05-18 15:35:27.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Address] ([ID], [AddressTypeID], [GuestID], [Address1], [Address2], [City], [State], [ZipCode], [Country], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (47, 1, 51, N'noida', N'noida', N'1', N'1', N'201301', N'3', 1, N'vipul', CAST(N'2017-05-23 21:37:12.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Address] ([ID], [AddressTypeID], [GuestID], [Address1], [Address2], [City], [State], [ZipCode], [Country], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (48, 1, 52, N'test address', N'test address', N'1', N'6', N'201301', N'3', 1, N'vipul', CAST(N'2017-05-25 09:33:19.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Address] ([ID], [AddressTypeID], [GuestID], [Address1], [Address2], [City], [State], [ZipCode], [Country], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (49, 1, 53, N'test address', N'test address', N'1', N'6', N'201301', N'3', 1, N'vipul', CAST(N'2017-05-25 10:05:09.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Address] ([ID], [AddressTypeID], [GuestID], [Address1], [Address2], [City], [State], [ZipCode], [Country], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (50, 1, 54, N'noida', N'noida', N'1', N'6', N'201301', N'3', 1, N'vipul', CAST(N'2017-05-25 11:14:42.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Address] ([ID], [AddressTypeID], [GuestID], [Address1], [Address2], [City], [State], [ZipCode], [Country], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (51, 1, 55, N'jlkjlkjlkjlkjlkjlk', N'jlkjlkjlkjlkjlkjlk', N'1', N'6', N'201301', N'3', 1, N'vipul', CAST(N'2017-05-25 11:20:02.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Address] ([ID], [AddressTypeID], [GuestID], [Address1], [Address2], [City], [State], [ZipCode], [Country], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1041, 1, 48, N'noida', N'noida', N'1', N'6', N'201301', N'3', 1, N'vipul', CAST(N'2017-06-06 10:07:09.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Address] ([ID], [AddressTypeID], [GuestID], [Address1], [Address2], [City], [State], [ZipCode], [Country], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1042, 1, 51, N'noida', N'noida', N'1', N'6', N'201301', N'3', 1, N'vipul', CAST(N'2017-06-07 09:33:59.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Address] ([ID], [AddressTypeID], [GuestID], [Address1], [Address2], [City], [State], [ZipCode], [Country], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1043, 1, 51, N'noida', N'noida', N'1', N'6', N'201301', N'3', 1, N'vipul', CAST(N'2017-06-07 09:39:37.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Address] ([ID], [AddressTypeID], [GuestID], [Address1], [Address2], [City], [State], [ZipCode], [Country], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1044, 1, 51, N'noida', N'noida', N'1', N'6', N'201301', N'3', 1, N'vipul', CAST(N'2017-06-07 10:08:41.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Address] ([ID], [AddressTypeID], [GuestID], [Address1], [Address2], [City], [State], [ZipCode], [Country], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1045, 1, 51, N'', N'', N'1', N'6', N'201301', N'3', 1, N'vipul', CAST(N'2017-06-07 10:52:56.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Address] ([ID], [AddressTypeID], [GuestID], [Address1], [Address2], [City], [State], [ZipCode], [Country], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1046, 1, 1045, N'noida', N'noida', N'1', N'6', N'201301', N'3', 1, N'vipul', CAST(N'2017-06-07 23:00:41.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Address] ([ID], [AddressTypeID], [GuestID], [Address1], [Address2], [City], [State], [ZipCode], [Country], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1047, 1, 48, N'noida', N'noida', N'1', N'6', N'201301', N'3', 1, N'vipul', CAST(N'2017-06-08 12:59:45.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[Address] OFF
SET IDENTITY_INSERT [dbo].[AddressType] ON 

INSERT [dbo].[AddressType] ([ID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Name]) VALUES (1, 1, N'sachin', CAST(N'2017-05-01 11:33:50.973' AS DateTime), N'tyagi', CAST(N'2017-05-01 11:33:50.973' AS DateTime), N'Official Address')
INSERT [dbo].[AddressType] ([ID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Name]) VALUES (2, 1, N'sachin', CAST(N'2017-05-01 11:33:50.973' AS DateTime), N'tyagi', CAST(N'2017-05-01 11:33:50.973' AS DateTime), N'Correspondence Address')
INSERT [dbo].[AddressType] ([ID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Name]) VALUES (3, 1, N'sachin', CAST(N'2017-05-01 11:33:50.997' AS DateTime), N'tyagi', CAST(N'2017-05-01 11:33:50.997' AS DateTime), N'Permanenent Address')
INSERT [dbo].[AddressType] ([ID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Name]) VALUES (4, 1, N'sachin', CAST(N'2017-05-01 11:33:50.997' AS DateTime), N'tyagi', CAST(N'2017-05-01 11:33:50.997' AS DateTime), N'Temporary Address')
SET IDENTITY_INSERT [dbo].[AddressType] OFF
SET IDENTITY_INSERT [dbo].[AllTaxes] ON 

INSERT [dbo].[AllTaxes] ([ID], [TaxShortName], [Description], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1, N'Tax1', N'Tax1', 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[AllTaxes] ([ID], [TaxShortName], [Description], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (2, N'Tax2', N'Tax2', 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[AllTaxes] ([ID], [TaxShortName], [Description], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (3, N'Tax3', N'Tax3', 1, N'vipul', NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[AllTaxes] OFF
SET IDENTITY_INSERT [dbo].[Booking] ON 

INSERT [dbo].[Booking] ([ID], [PropertyID], [CheckinTime], [CheckoutTime], [NoOfAdult], [NoOfChild], [GuestRemarks], [TransactionRemarks], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Status], [ISHOURLYCHECKIN], [HOURSTOSTAY]) VALUES (50, 1, CAST(N'2017-06-07 01:00:00.000' AS DateTime), CAST(N'2017-06-07 03:00:00.000' AS DateTime), 1, 0, N'test comments', N'test remark', 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Booking] ([ID], [PropertyID], [CheckinTime], [CheckoutTime], [NoOfAdult], [NoOfChild], [GuestRemarks], [TransactionRemarks], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Status], [ISHOURLYCHECKIN], [HOURSTOSTAY]) VALUES (51, 1, CAST(N'2017-06-08 00:00:00.000' AS DateTime), CAST(N'2017-06-08 01:00:00.000' AS DateTime), 1, 0, N'comments', N'trans remarks', 1, N'vipul', CAST(N'2017-05-18 15:35:27.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Booking] ([ID], [PropertyID], [CheckinTime], [CheckoutTime], [NoOfAdult], [NoOfChild], [GuestRemarks], [TransactionRemarks], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Status], [ISHOURLYCHECKIN], [HOURSTOSTAY]) VALUES (52, 1, CAST(N'2017-06-08 05:00:00.000' AS DateTime), CAST(N'2017-06-08 06:00:00.000' AS DateTime), 1, 1, N'comments1', N'trans1', 1, N'vipul', CAST(N'2017-05-23 21:37:12.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Booking] ([ID], [PropertyID], [CheckinTime], [CheckoutTime], [NoOfAdult], [NoOfChild], [GuestRemarks], [TransactionRemarks], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Status], [ISHOURLYCHECKIN], [HOURSTOSTAY]) VALUES (53, 1, CAST(N'2017-05-25 09:00:00.000' AS DateTime), CAST(N'2017-05-25 10:00:00.000' AS DateTime), 1, 0, N'guest commnets test', N'trans remarks', 1, N'vipul', CAST(N'2017-05-25 09:33:19.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Booking] ([ID], [PropertyID], [CheckinTime], [CheckoutTime], [NoOfAdult], [NoOfChild], [GuestRemarks], [TransactionRemarks], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Status], [ISHOURLYCHECKIN], [HOURSTOSTAY]) VALUES (54, 1, CAST(N'2017-05-25 15:00:00.000' AS DateTime), CAST(N'2017-05-25 16:00:00.000' AS DateTime), 1, 0, N'guest coments', N'trans remark', 1, N'vipul', CAST(N'2017-05-25 10:05:09.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Booking] ([ID], [PropertyID], [CheckinTime], [CheckoutTime], [NoOfAdult], [NoOfChild], [GuestRemarks], [TransactionRemarks], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Status], [ISHOURLYCHECKIN], [HOURSTOSTAY]) VALUES (55, 1, CAST(N'2017-05-25 17:00:00.000' AS DateTime), CAST(N'2017-05-25 18:00:00.000' AS DateTime), 1, 0, N'guest comments', N'trans  remarks', 1, N'vipul', CAST(N'2017-05-25 11:14:42.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Booking] ([ID], [PropertyID], [CheckinTime], [CheckoutTime], [NoOfAdult], [NoOfChild], [GuestRemarks], [TransactionRemarks], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Status], [ISHOURLYCHECKIN], [HOURSTOSTAY]) VALUES (56, 1, CAST(N'2017-05-26 00:00:00.000' AS DateTime), CAST(N'2017-05-27 00:00:00.000' AS DateTime), 1, 0, N'test comments', N'remarks test', 1, N'vipul', CAST(N'2017-05-25 11:20:02.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Booking] ([ID], [PropertyID], [CheckinTime], [CheckoutTime], [NoOfAdult], [NoOfChild], [GuestRemarks], [TransactionRemarks], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Status], [ISHOURLYCHECKIN], [HOURSTOSTAY]) VALUES (1046, 1, CAST(N'2017-06-09 00:00:00.000' AS DateTime), CAST(N'2017-06-09 06:00:00.000' AS DateTime), 1, 0, N'comments', N'trans remark', 1, N'vipul', CAST(N'2017-06-06 10:07:09.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Booking] ([ID], [PropertyID], [CheckinTime], [CheckoutTime], [NoOfAdult], [NoOfChild], [GuestRemarks], [TransactionRemarks], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Status], [ISHOURLYCHECKIN], [HOURSTOSTAY]) VALUES (1047, 1, CAST(N'2017-06-01 00:00:00.000' AS DateTime), CAST(N'2017-06-01 01:00:00.000' AS DateTime), 1, 0, N'testguestcom', N'testremark', 1, N'vipul', CAST(N'2017-06-07 09:33:59.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Booking] ([ID], [PropertyID], [CheckinTime], [CheckoutTime], [NoOfAdult], [NoOfChild], [GuestRemarks], [TransactionRemarks], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Status], [ISHOURLYCHECKIN], [HOURSTOSTAY]) VALUES (1048, 1, CAST(N'2017-06-10 00:00:00.000' AS DateTime), CAST(N'2017-06-10 02:00:00.000' AS DateTime), 1, 0, N'comment test', N'transtest', 1, N'vipul', CAST(N'2017-06-07 09:39:37.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Booking] ([ID], [PropertyID], [CheckinTime], [CheckoutTime], [NoOfAdult], [NoOfChild], [GuestRemarks], [TransactionRemarks], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Status], [ISHOURLYCHECKIN], [HOURSTOSTAY]) VALUES (1049, 1, CAST(N'2017-06-11 00:00:00.000' AS DateTime), CAST(N'2017-06-11 02:00:00.000' AS DateTime), 1, 0, N'sdfdsfsf', N'fgdgsdfsf', 1, N'vipul', CAST(N'2017-06-07 10:08:41.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Booking] ([ID], [PropertyID], [CheckinTime], [CheckoutTime], [NoOfAdult], [NoOfChild], [GuestRemarks], [TransactionRemarks], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Status], [ISHOURLYCHECKIN], [HOURSTOSTAY]) VALUES (1050, 1, CAST(N'2017-06-12 00:00:00.000' AS DateTime), CAST(N'2017-06-12 02:00:00.000' AS DateTime), 1, 0, N'test comment', N'test remark', 1, N'vipul', CAST(N'2017-06-07 10:52:56.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[Booking] ([ID], [PropertyID], [CheckinTime], [CheckoutTime], [NoOfAdult], [NoOfChild], [GuestRemarks], [TransactionRemarks], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Status], [ISHOURLYCHECKIN], [HOURSTOSTAY]) VALUES (1051, 1, CAST(N'2017-06-30 00:00:00.000' AS DateTime), CAST(N'2017-06-30 02:00:00.000' AS DateTime), 1, 0, N'sdsfsf', N'sfsf', 1, N'vipul', CAST(N'2017-06-07 23:00:41.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, 1, 2)
INSERT [dbo].[Booking] ([ID], [PropertyID], [CheckinTime], [CheckoutTime], [NoOfAdult], [NoOfChild], [GuestRemarks], [TransactionRemarks], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [Status], [ISHOURLYCHECKIN], [HOURSTOSTAY]) VALUES (1052, 1, CAST(N'2017-07-01 00:00:00.000' AS DateTime), CAST(N'2017-07-01 02:00:00.000' AS DateTime), 1, 0, N'dsfsfsafasf', N'sfdsfdsf', 1, N'vipul', CAST(N'2017-06-08 12:59:45.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), NULL, 1, 2)
SET IDENTITY_INSERT [dbo].[Booking] OFF
SET IDENTITY_INSERT [dbo].[City] ON 

INSERT [dbo].[City] ([ID], [Name], [StateID], [CountryID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1, N'Test1', 2, 3, 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[City] ([ID], [Name], [StateID], [CountryID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (2, N'Test2', 2, 3, 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[City] ([ID], [Name], [StateID], [CountryID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (3, N'Test3', 6, 3, 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[City] ([ID], [Name], [StateID], [CountryID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (4, N'Test4', 6, 3, 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[City] ([ID], [Name], [StateID], [CountryID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (5, N'Test11', 5, 3, 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[City] ([ID], [Name], [StateID], [CountryID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (6, N'Test22', 5, 3, 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[City] ([ID], [Name], [StateID], [CountryID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (7, N'Test33', 6, 3, 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[City] ([ID], [Name], [StateID], [CountryID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (8, N'Test44', 4, 3, 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[City] OFF
SET IDENTITY_INSERT [dbo].[Country] ON 

INSERT [dbo].[Country] ([ID], [Name], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1, N'India', 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[Country] ([ID], [Name], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (3, N'U.S.A', 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[Country] OFF
SET IDENTITY_INSERT [dbo].[Guest] ON 

INSERT [dbo].[Guest] ([ID], [FirstName], [LastName], [MobileNumber], [EmailAddress], [DOB], [Gender], [PhotoPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (48, N'qqqqas', N'Test Last', 8098098098, N'v@v.com', CAST(N'2017-06-04' AS Date), N'M', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-06-08 12:59:45.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Guest] ([ID], [FirstName], [LastName], [MobileNumber], [EmailAddress], [DOB], [Gender], [PhotoPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (49, N'Test First', N'test last', 8098098098, N'v@v.com', CAST(N'2017-05-01' AS Date), N'F', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Guest] ([ID], [FirstName], [LastName], [MobileNumber], [EmailAddress], [DOB], [Gender], [PhotoPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (50, N'FNAME', N'lname', 7987987987, N'v@v.com', CAST(N'2017-05-01' AS Date), N'F', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-05-18 15:35:27.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Guest] ([ID], [FirstName], [LastName], [MobileNumber], [EmailAddress], [DOB], [Gender], [PhotoPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (51, N'demo test', N'demo last', 8098098098, N'v@v.com', CAST(N'2017-06-01' AS Date), N'M', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-06-07 10:52:56.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Guest] ([ID], [FirstName], [LastName], [MobileNumber], [EmailAddress], [DOB], [Gender], [PhotoPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (52, N'new demo', N'new name', 201301, N'v@v.com', CAST(N'2017-05-01' AS Date), N'M', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-05-25 09:33:19.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Guest] ([ID], [FirstName], [LastName], [MobileNumber], [EmailAddress], [DOB], [Gender], [PhotoPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (53, N'demo test', N'last name', 8709870987, N'v@v.com', CAST(N'2017-05-01' AS Date), N'F', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-05-25 10:05:09.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Guest] ([ID], [FirstName], [LastName], [MobileNumber], [EmailAddress], [DOB], [Gender], [PhotoPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (54, N'demodemo', N'checkin', 7098099880, N'demo@demo.com', CAST(N'2017-05-09' AS Date), N'F', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-05-25 11:14:42.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Guest] ([ID], [FirstName], [LastName], [MobileNumber], [EmailAddress], [DOB], [Gender], [PhotoPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (55, N'demo checkin', N'last', 7097988089, N'demo@demo.com', CAST(N'2017-05-08' AS Date), N'F', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-05-25 11:20:02.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[Guest] ([ID], [FirstName], [LastName], [MobileNumber], [EmailAddress], [DOB], [Gender], [PhotoPath], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1045, N'fpms', N'lpms', 3284080989, N'v@v.com', CAST(N'2017-06-01' AS Date), N'M', N'D:\PMSHosted\PMSApi\UploadedFiles\Untitled.png', 1, N'vipul', CAST(N'2017-06-07 23:00:41.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[Guest] OFF
SET IDENTITY_INSERT [dbo].[GuestMapping] ON 

INSERT [dbo].[GuestMapping] ([ID], [IDTYPEID], [GUESTID], [IDDETAILS], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [IdExpiryDate], [IdIssueState], [IdIssueCountry]) VALUES (12, 2, 49, N'abctest', 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), CAST(N'2017-05-31 00:00:00.000' AS DateTime), N'Select State', N'Select Country')
INSERT [dbo].[GuestMapping] ([ID], [IDTYPEID], [GUESTID], [IDDETAILS], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [IdExpiryDate], [IdIssueState], [IdIssueCountry]) VALUES (13, 1, 50, N'abc', 1, N'vipul', CAST(N'2017-05-18 15:35:27.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), CAST(N'2017-05-25 00:00:00.000' AS DateTime), N'3', N'1')
INSERT [dbo].[GuestMapping] ([ID], [IDTYPEID], [GUESTID], [IDDETAILS], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [IdExpiryDate], [IdIssueState], [IdIssueCountry]) VALUES (14, 1, 51, N'jlkjlkjlkjlkjlkjl', 1, N'vipul', CAST(N'2017-05-23 21:37:12.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), CAST(N'2017-05-31 00:00:00.000' AS DateTime), N'1', N'3')
INSERT [dbo].[GuestMapping] ([ID], [IDTYPEID], [GUESTID], [IDDETAILS], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [IdExpiryDate], [IdIssueState], [IdIssueCountry]) VALUES (15, 1, 52, N'abc', 1, N'vipul', CAST(N'2017-05-25 09:33:19.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), CAST(N'2017-05-31 00:00:00.000' AS DateTime), N'1', N'3')
INSERT [dbo].[GuestMapping] ([ID], [IDTYPEID], [GUESTID], [IDDETAILS], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [IdExpiryDate], [IdIssueState], [IdIssueCountry]) VALUES (16, 1, 53, N'abc', 1, N'vipul', CAST(N'2017-05-25 10:05:09.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), CAST(N'2017-05-30 00:00:00.000' AS DateTime), N'1', N'3')
INSERT [dbo].[GuestMapping] ([ID], [IDTYPEID], [GUESTID], [IDDETAILS], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [IdExpiryDate], [IdIssueState], [IdIssueCountry]) VALUES (17, 1, 54, N'abccccc', 1, N'vipul', CAST(N'2017-05-25 11:14:42.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), CAST(N'2017-05-31 00:00:00.000' AS DateTime), N'1', N'3')
INSERT [dbo].[GuestMapping] ([ID], [IDTYPEID], [GUESTID], [IDDETAILS], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [IdExpiryDate], [IdIssueState], [IdIssueCountry]) VALUES (18, 1, 55, N'esdfsdf', 1, N'vipul', CAST(N'2017-05-25 11:20:02.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), CAST(N'2017-05-31 00:00:00.000' AS DateTime), N'1', N'3')
INSERT [dbo].[GuestMapping] ([ID], [IDTYPEID], [GUESTID], [IDDETAILS], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [IdExpiryDate], [IdIssueState], [IdIssueCountry]) VALUES (1008, 1, 48, N'xyx', 1, N'vipul', CAST(N'2017-06-06 10:07:09.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), CAST(N'2017-06-30 00:00:00.000' AS DateTime), N'7', N'1')
INSERT [dbo].[GuestMapping] ([ID], [IDTYPEID], [GUESTID], [IDDETAILS], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [IdExpiryDate], [IdIssueState], [IdIssueCountry]) VALUES (1009, 1, 51, N'abc', 1, N'vipul', CAST(N'2017-06-07 09:33:59.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), CAST(N'2017-06-01 00:00:00.000' AS DateTime), N'6', N'3')
INSERT [dbo].[GuestMapping] ([ID], [IDTYPEID], [GUESTID], [IDDETAILS], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [IdExpiryDate], [IdIssueState], [IdIssueCountry]) VALUES (1010, 2, 51, N'axbbb', 1, N'vipul', CAST(N'2017-06-07 09:39:37.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), CAST(N'2017-06-30 00:00:00.000' AS DateTime), N'6', N'3')
INSERT [dbo].[GuestMapping] ([ID], [IDTYPEID], [GUESTID], [IDDETAILS], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [IdExpiryDate], [IdIssueState], [IdIssueCountry]) VALUES (1011, 1, 51, N'bcdf', 1, N'vipul', CAST(N'2017-06-07 10:08:41.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), CAST(N'2017-06-30 00:00:00.000' AS DateTime), N'6', N'3')
INSERT [dbo].[GuestMapping] ([ID], [IDTYPEID], [GUESTID], [IDDETAILS], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [IdExpiryDate], [IdIssueState], [IdIssueCountry]) VALUES (1012, 1, 51, N'fdgfdg', 1, N'vipul', CAST(N'2017-06-07 10:52:56.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), CAST(N'2017-06-30 00:00:00.000' AS DateTime), N'6', N'3')
INSERT [dbo].[GuestMapping] ([ID], [IDTYPEID], [GUESTID], [IDDETAILS], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [IdExpiryDate], [IdIssueState], [IdIssueCountry]) VALUES (1013, 1, 1045, N'qqqqq', 1, N'vipul', CAST(N'2017-06-07 23:00:41.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), CAST(N'2017-06-30 00:00:00.000' AS DateTime), N'6', N'3')
INSERT [dbo].[GuestMapping] ([ID], [IDTYPEID], [GUESTID], [IDDETAILS], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [IdExpiryDate], [IdIssueState], [IdIssueCountry]) VALUES (1014, 1, 48, N'xyx', 1, N'vipul', CAST(N'2017-06-08 12:59:45.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime), CAST(N'2017-06-18 00:00:00.000' AS DateTime), N'6', N'3')
SET IDENTITY_INSERT [dbo].[GuestMapping] OFF
SET IDENTITY_INSERT [dbo].[IDType] ON 

INSERT [dbo].[IDType] ([ID], [Name], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1, N'Passport', 1, N'admin', NULL, NULL, NULL)
INSERT [dbo].[IDType] ([ID], [Name], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (2, N'SSN', 1, N'admin', NULL, NULL, NULL)
INSERT [dbo].[IDType] ([ID], [Name], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (3, N'PAN', 1, N'admin', NULL, NULL, NULL)
INSERT [dbo].[IDType] ([ID], [Name], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (4, N'Driving License', 1, N'admin', NULL, NULL, NULL)
INSERT [dbo].[IDType] ([ID], [Name], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (5, N'Govt Id Prood', 1, N'admin', NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[IDType] OFF
SET IDENTITY_INSERT [dbo].[Property] ON 

INSERT [dbo].[Property] ([ID], [PropertyDetails], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [PropertyName], [SecondaryName], [PropertyCode], [FullAddress], [Phone], [Fax], [LogoPath], [WebSiteAddress], [TimeZone], [CurrencyID], [CheckinTime], [CheckoutTime], [CloseOfDayTime]) VALUES (1, N'Sachin Hotel', 1, N'sachin', CAST(N'2017-05-01 11:20:30.000' AS DateTime), N'sachin', CAST(N'2017-05-01 11:20:30.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Property] ([ID], [PropertyDetails], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [PropertyName], [SecondaryName], [PropertyCode], [FullAddress], [Phone], [Fax], [LogoPath], [WebSiteAddress], [TimeZone], [CurrencyID], [CheckinTime], [CheckoutTime], [CloseOfDayTime]) VALUES (2, N'Hotel2', 1, N'sachin', CAST(N'2017-05-01 11:24:34.977' AS DateTime), N'sachin', CAST(N'2017-05-01 11:24:34.977' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Property] ([ID], [PropertyDetails], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [PropertyName], [SecondaryName], [PropertyCode], [FullAddress], [Phone], [Fax], [LogoPath], [WebSiteAddress], [TimeZone], [CurrencyID], [CheckinTime], [CheckoutTime], [CloseOfDayTime]) VALUES (3, N'PMS Hotel', 1, N'sachin', CAST(N'2017-05-01 11:25:02.610' AS DateTime), N'sachin', CAST(N'2017-05-01 11:25:02.610' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Property] OFF
SET IDENTITY_INSERT [dbo].[Rates] ON 

INSERT [dbo].[Rates] ([ID], [Type], [PropertyID], [RateTypeID], [RoomTypeID], [InputKeyHours], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1, N'TestType', 1, 1, 1, 2, 35.0000, 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[Rates] ([ID], [Type], [PropertyID], [RateTypeID], [RoomTypeID], [InputKeyHours], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (2, N'TestType', 1, 1, 1, 1, 15.0000, 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[Rates] ([ID], [Type], [PropertyID], [RateTypeID], [RoomTypeID], [InputKeyHours], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (3, N'TestType', 1, 1, 1, 4, 45.0000, 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[Rates] ([ID], [Type], [PropertyID], [RateTypeID], [RoomTypeID], [InputKeyHours], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (4, N'TestType', 1, 1, 1, 6, 65.0000, 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[Rates] ([ID], [Type], [PropertyID], [RateTypeID], [RoomTypeID], [InputKeyHours], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (5, N'TestType', 2, 1, 1, 2, 35.0000, 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[Rates] ([ID], [Type], [PropertyID], [RateTypeID], [RoomTypeID], [InputKeyHours], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (6, N'TestType', 2, 1, 1, 1, 15.0000, 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[Rates] ([ID], [Type], [PropertyID], [RateTypeID], [RoomTypeID], [InputKeyHours], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (7, N'TestType', 2, 1, 1, 4, 45.0000, 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[Rates] ([ID], [Type], [PropertyID], [RateTypeID], [RoomTypeID], [InputKeyHours], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (8, N'TestType', 2, 1, 1, 6, 65.0000, 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[Rates] ([ID], [Type], [PropertyID], [RateTypeID], [RoomTypeID], [InputKeyHours], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (9, N'TestType', 1, 2, 1, 2, 15.0000, 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[Rates] ([ID], [Type], [PropertyID], [RateTypeID], [RoomTypeID], [InputKeyHours], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (10, N'TestType', 1, 2, 1, 1, 5.0000, 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[Rates] ([ID], [Type], [PropertyID], [RateTypeID], [RoomTypeID], [InputKeyHours], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (11, N'TestType', 1, 2, 1, 4, 25.0000, 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[Rates] ([ID], [Type], [PropertyID], [RateTypeID], [RoomTypeID], [InputKeyHours], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (12, N'TestType', 1, 2, 1, 6, 45.0000, 1, N'vipul', NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Rates] OFF
SET IDENTITY_INSERT [dbo].[RateType] ON 

INSERT [dbo].[RateType] ([ID], [PropertyID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [NAME], [RoomTypeID], [ShortName]) VALUES (1, 1, 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'Apartment Standard Test', NULL, NULL)
INSERT [dbo].[RateType] ([ID], [PropertyID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [NAME], [RoomTypeID], [ShortName]) VALUES (2, 1, 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'Apartment Standard', NULL, NULL)
INSERT [dbo].[RateType] ([ID], [PropertyID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [NAME], [RoomTypeID], [ShortName]) VALUES (3, 1, 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'Queen Standard', NULL, NULL)
INSERT [dbo].[RateType] ([ID], [PropertyID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [NAME], [RoomTypeID], [ShortName]) VALUES (4, 1, 1, N'sachin', CAST(N'2017-05-01 11:31:06.573' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.573' AS DateTime), N'Holiday Standard', NULL, NULL)
INSERT [dbo].[RateType] ([ID], [PropertyID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [NAME], [RoomTypeID], [ShortName]) VALUES (5, 1, 1, N'sachin', CAST(N'2017-05-01 11:31:06.573' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.573' AS DateTime), N'My Weekend Standard', NULL, NULL)
INSERT [dbo].[RateType] ([ID], [PropertyID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [NAME], [RoomTypeID], [ShortName]) VALUES (6, 2, 1, N'sachin', CAST(N'2017-05-01 11:31:06.573' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.573' AS DateTime), N'2Apartment Standard Test', NULL, NULL)
INSERT [dbo].[RateType] ([ID], [PropertyID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [NAME], [RoomTypeID], [ShortName]) VALUES (7, 2, 1, N'sachin', CAST(N'2017-05-01 11:31:06.573' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.573' AS DateTime), N'2Apartment Standard', NULL, NULL)
INSERT [dbo].[RateType] ([ID], [PropertyID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [NAME], [RoomTypeID], [ShortName]) VALUES (8, 2, 1, N'sachin', CAST(N'2017-05-01 11:31:06.573' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.573' AS DateTime), N'2Queen Standard', NULL, NULL)
SET IDENTITY_INSERT [dbo].[RateType] OFF
SET IDENTITY_INSERT [dbo].[Room] ON 

INSERT [dbo].[Room] ([ID], [PropertyID], [RoomTypeID], [Number], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1, 1, 1, N'R1-101', 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime))
INSERT [dbo].[Room] ([ID], [PropertyID], [RoomTypeID], [Number], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (2, 1, 1, N'R1-102', 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime))
INSERT [dbo].[Room] ([ID], [PropertyID], [RoomTypeID], [Number], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (3, 1, 1, N'R1-103', 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime))
INSERT [dbo].[Room] ([ID], [PropertyID], [RoomTypeID], [Number], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (4, 1, 1, N'R1-104', 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime))
INSERT [dbo].[Room] ([ID], [PropertyID], [RoomTypeID], [Number], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (5, 1, 2, N'R1-105', 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime))
INSERT [dbo].[Room] ([ID], [PropertyID], [RoomTypeID], [Number], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (6, 1, 2, N'R1-106', 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime))
INSERT [dbo].[Room] ([ID], [PropertyID], [RoomTypeID], [Number], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (7, 1, 2, N'R1-107', 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime))
INSERT [dbo].[Room] ([ID], [PropertyID], [RoomTypeID], [Number], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (8, 1, 3, N'R1-108', 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime))
INSERT [dbo].[Room] ([ID], [PropertyID], [RoomTypeID], [Number], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (9, 2, 1, N'R2-101', 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime))
INSERT [dbo].[Room] ([ID], [PropertyID], [RoomTypeID], [Number], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (10, 2, 1, N'R2-102', 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime))
INSERT [dbo].[Room] ([ID], [PropertyID], [RoomTypeID], [Number], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (11, 2, 1, N'R2-103', 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime))
INSERT [dbo].[Room] ([ID], [PropertyID], [RoomTypeID], [Number], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (12, 2, 1, N'R2-104', 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime))
INSERT [dbo].[Room] ([ID], [PropertyID], [RoomTypeID], [Number], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (13, 2, 2, N'R2-105', 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime))
INSERT [dbo].[Room] ([ID], [PropertyID], [RoomTypeID], [Number], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (14, 2, 2, N'R2-106', 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime))
INSERT [dbo].[Room] ([ID], [PropertyID], [RoomTypeID], [Number], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (15, 2, 2, N'R2-107', 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime))
INSERT [dbo].[Room] ([ID], [PropertyID], [RoomTypeID], [Number], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (16, 2, 3, N'R2-108', 1, N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime), N'sachin', CAST(N'2017-05-01 11:31:06.570' AS DateTime))
SET IDENTITY_INSERT [dbo].[Room] OFF
SET IDENTITY_INSERT [dbo].[RoomBooking] ON 

INSERT [dbo].[RoomBooking] ([ID], [GuestID], [BookingID], [RoomID], [IsExtra], [Discount], [RoomCharges], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (24, 49, 50, 6, 0, CAST(2.00 AS Decimal(7, 2)), CAST(12.00 AS Decimal(7, 2)), 1, N'v', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[RoomBooking] ([ID], [GuestID], [BookingID], [RoomID], [IsExtra], [Discount], [RoomCharges], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (25, 50, 51, 1, 0, CAST(2.00 AS Decimal(7, 2)), CAST(12.00 AS Decimal(7, 2)), 1, N'v', CAST(N'2017-05-18 15:35:27.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[RoomBooking] ([ID], [GuestID], [BookingID], [RoomID], [IsExtra], [Discount], [RoomCharges], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (26, 51, 52, 3, 0, CAST(2.00 AS Decimal(7, 2)), CAST(12.00 AS Decimal(7, 2)), 1, N'v', CAST(N'2017-05-23 21:37:12.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[RoomBooking] ([ID], [GuestID], [BookingID], [RoomID], [IsExtra], [Discount], [RoomCharges], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (27, 52, 53, 1, 0, CAST(2.00 AS Decimal(7, 2)), CAST(12.00 AS Decimal(7, 2)), 1, N'v', CAST(N'2017-05-25 09:33:19.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[RoomBooking] ([ID], [GuestID], [BookingID], [RoomID], [IsExtra], [Discount], [RoomCharges], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (28, 53, 54, 2, 0, CAST(2.00 AS Decimal(7, 2)), CAST(12.00 AS Decimal(7, 2)), 1, N'v', CAST(N'2017-05-25 10:05:09.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[RoomBooking] ([ID], [GuestID], [BookingID], [RoomID], [IsExtra], [Discount], [RoomCharges], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (29, 54, 55, 4, 0, CAST(2.00 AS Decimal(7, 2)), CAST(12.00 AS Decimal(7, 2)), 1, N'v', CAST(N'2017-05-25 11:14:42.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[RoomBooking] ([ID], [GuestID], [BookingID], [RoomID], [IsExtra], [Discount], [RoomCharges], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (30, 55, 56, 4, 0, CAST(2.00 AS Decimal(7, 2)), CAST(12.00 AS Decimal(7, 2)), 1, N'v', CAST(N'2017-05-25 11:20:02.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[RoomBooking] ([ID], [GuestID], [BookingID], [RoomID], [IsExtra], [Discount], [RoomCharges], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1020, 48, 1046, 5, 0, CAST(2.00 AS Decimal(7, 2)), CAST(12.00 AS Decimal(7, 2)), 1, N'v', CAST(N'2017-06-06 10:07:09.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[RoomBooking] ([ID], [GuestID], [BookingID], [RoomID], [IsExtra], [Discount], [RoomCharges], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1021, 51, 1047, 1, 0, CAST(2.00 AS Decimal(7, 2)), CAST(12.00 AS Decimal(7, 2)), 1, N'v', CAST(N'2017-06-07 09:33:59.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[RoomBooking] ([ID], [GuestID], [BookingID], [RoomID], [IsExtra], [Discount], [RoomCharges], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1022, 51, 1048, 1, 0, CAST(2.00 AS Decimal(7, 2)), CAST(12.00 AS Decimal(7, 2)), 1, N'v', CAST(N'2017-06-07 09:39:37.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[RoomBooking] ([ID], [GuestID], [BookingID], [RoomID], [IsExtra], [Discount], [RoomCharges], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1023, 51, 1049, 2, 0, CAST(2.00 AS Decimal(7, 2)), CAST(12.00 AS Decimal(7, 2)), 1, N'v', CAST(N'2017-06-07 10:08:41.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[RoomBooking] ([ID], [GuestID], [BookingID], [RoomID], [IsExtra], [Discount], [RoomCharges], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1024, 51, 1050, 1, 0, CAST(2.00 AS Decimal(7, 2)), CAST(12.00 AS Decimal(7, 2)), 1, N'v', CAST(N'2017-06-07 10:52:56.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[RoomBooking] ([ID], [GuestID], [BookingID], [RoomID], [IsExtra], [Discount], [RoomCharges], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1025, 1045, 1051, 1, 0, CAST(2.00 AS Decimal(7, 2)), CAST(12.00 AS Decimal(7, 2)), 1, N'v', CAST(N'2017-06-07 23:00:41.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
INSERT [dbo].[RoomBooking] ([ID], [GuestID], [BookingID], [RoomID], [IsExtra], [Discount], [RoomCharges], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1026, 48, 1052, 1, 0, CAST(2.00 AS Decimal(7, 2)), CAST(12.00 AS Decimal(7, 2)), 1, N'v', CAST(N'2017-06-08 12:59:45.000' AS DateTime), NULL, CAST(N'1900-01-01 00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[RoomBooking] OFF
SET IDENTITY_INSERT [dbo].[RoomType] ON 

INSERT [dbo].[RoomType] ([ID], [PropertyID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [NAME], [ShortName]) VALUES (1, 1, 1, N'sachin', CAST(N'2017-05-01 11:24:05.553' AS DateTime), N'sachin', CAST(N'2017-05-01 11:24:05.553' AS DateTime), N'King-Smoking', NULL)
INSERT [dbo].[RoomType] ([ID], [PropertyID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [NAME], [ShortName]) VALUES (2, 1, 1, N'sachin', CAST(N'2017-05-01 11:26:47.573' AS DateTime), N'sachin', CAST(N'2017-05-01 11:26:47.573' AS DateTime), N'King-NonSmoking', NULL)
INSERT [dbo].[RoomType] ([ID], [PropertyID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [NAME], [ShortName]) VALUES (3, 1, 1, N'sachin', CAST(N'2017-05-01 11:26:47.573' AS DateTime), N'sachin', CAST(N'2017-05-01 11:26:47.573' AS DateTime), N'Queen-Smoking', NULL)
INSERT [dbo].[RoomType] ([ID], [PropertyID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [NAME], [ShortName]) VALUES (4, 1, 1, N'sachin', CAST(N'2017-05-01 11:26:47.593' AS DateTime), N'sachin', CAST(N'2017-05-01 11:26:47.593' AS DateTime), N'Test King-Smoking', NULL)
INSERT [dbo].[RoomType] ([ID], [PropertyID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [NAME], [ShortName]) VALUES (5, 2, 1, N'sachin', CAST(N'2017-05-01 11:27:30.580' AS DateTime), N'sachin', CAST(N'2017-05-01 11:27:30.580' AS DateTime), N'2King-Smoking', NULL)
INSERT [dbo].[RoomType] ([ID], [PropertyID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [NAME], [ShortName]) VALUES (6, 2, 1, N'sachin', CAST(N'2017-05-01 11:27:30.580' AS DateTime), N'sachin', CAST(N'2017-05-01 11:27:30.580' AS DateTime), N'2King-NonSmoking', NULL)
INSERT [dbo].[RoomType] ([ID], [PropertyID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [NAME], [ShortName]) VALUES (7, 2, 1, N'sachin', CAST(N'2017-05-01 11:27:30.583' AS DateTime), N'sachin', CAST(N'2017-05-01 11:27:30.583' AS DateTime), N'2Queen-Smoking', NULL)
INSERT [dbo].[RoomType] ([ID], [PropertyID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn], [NAME], [ShortName]) VALUES (8, 2, 1, N'sachin', CAST(N'2017-05-01 11:27:30.603' AS DateTime), N'sachin', CAST(N'2017-05-01 11:27:30.603' AS DateTime), N'2Test King-Smoking', NULL)
SET IDENTITY_INSERT [dbo].[RoomType] OFF
SET IDENTITY_INSERT [dbo].[State] ON 

INSERT [dbo].[State] ([ID], [Name], [CountryID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (2, N'Alabama ', 3, 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[State] ([ID], [Name], [CountryID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (3, N'Alaska', 3, 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[State] ([ID], [Name], [CountryID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (4, N'Arizona', 3, 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[State] ([ID], [Name], [CountryID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (5, N'Arkansas', 3, 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[State] ([ID], [Name], [CountryID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (6, N'California', 3, 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[State] ([ID], [Name], [CountryID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (7, N'UP', 1, 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[State] ([ID], [Name], [CountryID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (8, N'Punjab', 1, 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
INSERT [dbo].[State] ([ID], [Name], [CountryID], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (9, N'Gujarat', NULL, 1, N'vipul', CAST(N'2017-05-17 16:01:08.000' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[State] OFF
SET IDENTITY_INSERT [dbo].[Taxes] ON 

INSERT [dbo].[Taxes] ([ID], [PropertyID], [TaxId], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (1, 1, 1, 5.0000, 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[Taxes] ([ID], [PropertyID], [TaxId], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (2, 1, 2, 7.0000, 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[Taxes] ([ID], [PropertyID], [TaxId], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (3, 1, 3, 3.0000, 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[Taxes] ([ID], [PropertyID], [TaxId], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (4, 2, 2, 5.0000, 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[Taxes] ([ID], [PropertyID], [TaxId], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (5, 2, 3, 7.0000, 1, N'vipul', NULL, NULL, NULL)
INSERT [dbo].[Taxes] ([ID], [PropertyID], [TaxId], [Value], [IsActive], [CreatedBy], [CreatedOn], [LastUpdatedBy], [LastUpdatedOn]) VALUES (6, 2, 1, 3.0000, 1, N'vipul', NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Taxes] OFF
ALTER TABLE [dbo].[ChargableFacility] ADD  CONSTRAINT [DF_ChargableFacility_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ExtraCharges] ADD  CONSTRAINT [DF_ExtraCharges_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[GuestReward] ADD  CONSTRAINT [DF__GuestRewa__IsAct__7F2BE32F]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Invoice] ADD  CONSTRAINT [DF__Invoice__IsActiv__01142BA1]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[InvoiceTaxDetail] ADD  CONSTRAINT [DF__InvoiceTa__IsAct__02084FDA]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[RewardCategory] ADD  CONSTRAINT [DF__RewardCat__IsAct__02FC7413]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[RoomPricing] ADD  CONSTRAINT [DF__RoomPrici__IsAct__04E4BC85]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[AdditionalGuests]  WITH CHECK ADD  CONSTRAINT [FK__Additiona__Booki__6442E2C9] FOREIGN KEY([BookingId])
REFERENCES [dbo].[Booking] ([ID])
GO
ALTER TABLE [dbo].[AdditionalGuests] CHECK CONSTRAINT [FK__Additiona__Booki__6442E2C9]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK__Address__Address__1920BF5C] FOREIGN KEY([AddressTypeID])
REFERENCES [dbo].[AddressType] ([ID])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK__Address__Address__1920BF5C]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK__Address__GuestID__1A14E395] FOREIGN KEY([GuestID])
REFERENCES [dbo].[Guest] ([ID])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK__Address__GuestID__1A14E395]
GO
ALTER TABLE [dbo].[Booking]  WITH CHECK ADD  CONSTRAINT [FK__Booking__Propert__1273C1CD] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([ID])
GO
ALTER TABLE [dbo].[Booking] CHECK CONSTRAINT [FK__Booking__Propert__1273C1CD]
GO
ALTER TABLE [dbo].[City]  WITH CHECK ADD  CONSTRAINT [FK__City__CountryID__48CFD27E] FOREIGN KEY([CountryID])
REFERENCES [dbo].[Country] ([ID])
GO
ALTER TABLE [dbo].[City] CHECK CONSTRAINT [FK__City__CountryID__48CFD27E]
GO
ALTER TABLE [dbo].[City]  WITH CHECK ADD  CONSTRAINT [FK__City__StateID__47DBAE45] FOREIGN KEY([StateID])
REFERENCES [dbo].[State] ([ID])
GO
ALTER TABLE [dbo].[City] CHECK CONSTRAINT [FK__City__StateID__47DBAE45]
GO
ALTER TABLE [dbo].[ExtraCharges]  WITH CHECK ADD  CONSTRAINT [FK__ExtraChar__Facil__2057CCD0] FOREIGN KEY([FacilityKey])
REFERENCES [dbo].[ChargableFacility] ([ID])
GO
ALTER TABLE [dbo].[ExtraCharges] CHECK CONSTRAINT [FK__ExtraChar__Facil__2057CCD0]
GO
ALTER TABLE [dbo].[ExtraCharges]  WITH CHECK ADD  CONSTRAINT [FK__ExtraChar__Prope__214BF109] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([ID])
GO
ALTER TABLE [dbo].[ExtraCharges] CHECK CONSTRAINT [FK__ExtraChar__Prope__214BF109]
GO
ALTER TABLE [dbo].[GuestMapping]  WITH CHECK ADD  CONSTRAINT [FK__GuestMapp__GUEST__1FCDBCEB] FOREIGN KEY([GUESTID])
REFERENCES [dbo].[Guest] ([ID])
GO
ALTER TABLE [dbo].[GuestMapping] CHECK CONSTRAINT [FK__GuestMapp__GUEST__1FCDBCEB]
GO
ALTER TABLE [dbo].[GuestMapping]  WITH CHECK ADD  CONSTRAINT [FK__GuestMapp__IDTYP__1ED998B2] FOREIGN KEY([IDTYPEID])
REFERENCES [dbo].[IDType] ([ID])
GO
ALTER TABLE [dbo].[GuestMapping] CHECK CONSTRAINT [FK__GuestMapp__IDTYP__1ED998B2]
GO
ALTER TABLE [dbo].[GuestReward]  WITH CHECK ADD  CONSTRAINT [FK__GuestRewa__Booki__38996AB5] FOREIGN KEY([BookingID])
REFERENCES [dbo].[Booking] ([ID])
GO
ALTER TABLE [dbo].[GuestReward] CHECK CONSTRAINT [FK__GuestRewa__Booki__38996AB5]
GO
ALTER TABLE [dbo].[GuestReward]  WITH CHECK ADD  CONSTRAINT [FK__GuestRewa__Guest__398D8EEE] FOREIGN KEY([GuestID])
REFERENCES [dbo].[Guest] ([ID])
GO
ALTER TABLE [dbo].[GuestReward] CHECK CONSTRAINT [FK__GuestRewa__Guest__398D8EEE]
GO
ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD  CONSTRAINT [FK__Invoice__Booking__3C69FB99] FOREIGN KEY([BookingID])
REFERENCES [dbo].[Booking] ([ID])
GO
ALTER TABLE [dbo].[Invoice] CHECK CONSTRAINT [FK__Invoice__Booking__3C69FB99]
GO
ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD  CONSTRAINT [FK__Invoice__GuestID__3D5E1FD2] FOREIGN KEY([GuestID])
REFERENCES [dbo].[Guest] ([ID])
GO
ALTER TABLE [dbo].[Invoice] CHECK CONSTRAINT [FK__Invoice__GuestID__3D5E1FD2]
GO
ALTER TABLE [dbo].[InvoiceTaxDetail]  WITH CHECK ADD  CONSTRAINT [FK__InvoiceTa__Invoi__403A8C7D] FOREIGN KEY([InvoiceID])
REFERENCES [dbo].[Invoice] ([ID])
GO
ALTER TABLE [dbo].[InvoiceTaxDetail] CHECK CONSTRAINT [FK__InvoiceTa__Invoi__403A8C7D]
GO
ALTER TABLE [dbo].[Rates]  WITH CHECK ADD  CONSTRAINT [FK__Rates__PropertyI__24285DB4] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([ID])
GO
ALTER TABLE [dbo].[Rates] CHECK CONSTRAINT [FK__Rates__PropertyI__24285DB4]
GO
ALTER TABLE [dbo].[Rates]  WITH CHECK ADD  CONSTRAINT [FK__Rates__RateTypeI__251C81ED] FOREIGN KEY([RateTypeID])
REFERENCES [dbo].[RateType] ([ID])
GO
ALTER TABLE [dbo].[Rates] CHECK CONSTRAINT [FK__Rates__RateTypeI__251C81ED]
GO
ALTER TABLE [dbo].[Rates]  WITH CHECK ADD  CONSTRAINT [FK__Rates__RoomTypeI__2610A626] FOREIGN KEY([RoomTypeID])
REFERENCES [dbo].[RoomType] ([ID])
GO
ALTER TABLE [dbo].[Rates] CHECK CONSTRAINT [FK__Rates__RoomTypeI__2610A626]
GO
ALTER TABLE [dbo].[RateType]  WITH CHECK ADD  CONSTRAINT [FK__RateType__Proper__267ABA7A] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([ID])
GO
ALTER TABLE [dbo].[RateType] CHECK CONSTRAINT [FK__RateType__Proper__267ABA7A]
GO
ALTER TABLE [dbo].[RateType]  WITH CHECK ADD  CONSTRAINT [FK__RateType__Proper__27F8EE98] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([ID])
GO
ALTER TABLE [dbo].[RateType] CHECK CONSTRAINT [FK__RateType__Proper__27F8EE98]
GO
ALTER TABLE [dbo].[Room]  WITH CHECK ADD  CONSTRAINT [FK__Room__PropertyID__2F10007B] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([ID])
GO
ALTER TABLE [dbo].[Room] CHECK CONSTRAINT [FK__Room__PropertyID__2F10007B]
GO
ALTER TABLE [dbo].[Room]  WITH CHECK ADD  CONSTRAINT [FK__Room__RoomTypeID__2E1BDC42] FOREIGN KEY([RoomTypeID])
REFERENCES [dbo].[RoomType] ([ID])
GO
ALTER TABLE [dbo].[Room] CHECK CONSTRAINT [FK__Room__RoomTypeID__2E1BDC42]
GO
ALTER TABLE [dbo].[RoomBooking]  WITH CHECK ADD  CONSTRAINT [FK__RoomBooki__Booki__33D4B598] FOREIGN KEY([BookingID])
REFERENCES [dbo].[Booking] ([ID])
GO
ALTER TABLE [dbo].[RoomBooking] CHECK CONSTRAINT [FK__RoomBooki__Booki__33D4B598]
GO
ALTER TABLE [dbo].[RoomBooking]  WITH CHECK ADD  CONSTRAINT [FK__RoomBooki__Guest__32E0915F] FOREIGN KEY([GuestID])
REFERENCES [dbo].[Guest] ([ID])
GO
ALTER TABLE [dbo].[RoomBooking] CHECK CONSTRAINT [FK__RoomBooki__Guest__32E0915F]
GO
ALTER TABLE [dbo].[RoomPricing]  WITH CHECK ADD  CONSTRAINT [FK__RoomPrici__Prope__2A4B4B5E] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([ID])
GO
ALTER TABLE [dbo].[RoomPricing] CHECK CONSTRAINT [FK__RoomPrici__Prope__2A4B4B5E]
GO
ALTER TABLE [dbo].[RoomPricing]  WITH CHECK ADD  CONSTRAINT [FK__RoomPrici__RateT__2B3F6F97] FOREIGN KEY([RateTypeID])
REFERENCES [dbo].[RateType] ([ID])
GO
ALTER TABLE [dbo].[RoomPricing] CHECK CONSTRAINT [FK__RoomPrici__RateT__2B3F6F97]
GO
ALTER TABLE [dbo].[RoomPricing]  WITH CHECK ADD  CONSTRAINT [FK__RoomPrici__RoomT__29572725] FOREIGN KEY([RoomTypeID])
REFERENCES [dbo].[RoomType] ([ID])
GO
ALTER TABLE [dbo].[RoomPricing] CHECK CONSTRAINT [FK__RoomPrici__RoomT__29572725]
GO
ALTER TABLE [dbo].[RoomType]  WITH CHECK ADD  CONSTRAINT [FK__RoomType__Proper__22AA2996] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([ID])
GO
ALTER TABLE [dbo].[RoomType] CHECK CONSTRAINT [FK__RoomType__Proper__22AA2996]
GO
ALTER TABLE [dbo].[State]  WITH CHECK ADD  CONSTRAINT [FK__State__CountryID__44FF419A] FOREIGN KEY([CountryID])
REFERENCES [dbo].[Country] ([ID])
GO
ALTER TABLE [dbo].[State] CHECK CONSTRAINT [FK__State__CountryID__44FF419A]
GO
ALTER TABLE [dbo].[Taxes]  WITH CHECK ADD  CONSTRAINT [FK__Taxes__PropertyI__382F5661] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([ID])
GO
ALTER TABLE [dbo].[Taxes] CHECK CONSTRAINT [FK__Taxes__PropertyI__382F5661]
GO
ALTER TABLE [dbo].[Taxes]  WITH CHECK ADD  CONSTRAINT [FK__Taxes__TaxId__39237A9A] FOREIGN KEY([TaxId])
REFERENCES [dbo].[AllTaxes] ([ID])
GO
ALTER TABLE [dbo].[Taxes] CHECK CONSTRAINT [FK__Taxes__TaxId__39237A9A]
GO
USE [master]
GO
ALTER DATABASE [PMS] SET  READ_WRITE 
GO
