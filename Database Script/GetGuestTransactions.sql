USE [PMS]
GO
/****** Object:  StoredProcedure [dbo].[GETGUESTTRANSACTIONS]    Script Date: 7/26/2017 1:12:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Sachin Tyagi    
-- Create date: MAY 13, 2017    
-- Description: This stored procedure shall return the histroy of guest transaction
-- Exec [GETGUESTTRANSACTIONS] 2081
-- =============================================    
ALTER PROCEDURE [dbo].[GETGUESTTRANSACTIONS]
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
PROPERTY.PROPERTYDETAILS,
PROPERTY.PropertyName,
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