-- =============================================      
-- Author:  Sachin Tyagi      
-- Create date: MAY 13, 2017      
-- Description: This stored procedure shall return the histroy of guest transaction  
-- Exec [GETGUESTTRANSACTIONS] 2081  
-- =============================================      
Alter PROCEDURE [dbo].[GETGUESTTRANSACTIONS]  
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
Room.Number AS ROOMNUMBER,  
InvoiceItems.ItemValue AS ROOMCHARGE,
Invoice.TotalAmount AS InvoiceAmount 
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
INNER JOIN
Invoice ON
Invoice.BookingID = Booking.ID
INNER JOIN
InvoiceItems ON
InvoiceItems.InvoiceID = Invoice.ID and InvoiceItems.ItemName = 'ROOM CHARGES'
 
END 