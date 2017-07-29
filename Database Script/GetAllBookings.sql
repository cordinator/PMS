-- =============================================              
-- Author:  Sachin Tyagi              
-- Create date: April 29, 2017              
-- Description: This stored procedure shall get the details of booking based on the checkin and checkoutdate              
-- =============================================              
--Exec [GETALLBOOKINGS] 1, '2017-06-03', '2017-06-29'  
        
ALTER PROCEDURE [dbo].[GETALLBOOKINGS]              
 @PROPERTYID INT,              
 @CHECKINTIME DATETIME = NULL,              
 @CHECKOUTDATE DATETIME = NULL              
AS              
BEGIN              
            
IF(CONVERT(TIME,@CHECKOUTDATE)= '00:00:00.0000000')            
 set @CHECKOUTDATE = @CHECKOUTDATE + '23:59:59'     
     
 --IF OBJECT_ID('tempdb.dbo.#TMPBOOKEDROOMS', 'U') IS NOT NULL    
 -- DROP TABLE #TMPBOOKEDROOMS;  
    
  declare @BookedRoomData TABLE(  
  ID  int  null          
 ,PROPERTYID int  null           
 ,CHECKINTIME  datetime null  
 ,CHECKOUTTIME datetime null   
 ,Status nvarchar(max) null             
 ,FIRSTNAME nvarchar(max) null              
 ,LASTNAME nvarchar(max) null            
 ,GUESTID int null  
 ,ROOMBOOKINGID int            
 ,ROOMID int null  
 ,ROOMNUMBER nvarchar(max)
 ,RoomTypeID int
 ,RoomTypeName nvarchar(max))  
                         
   
Insert into @BookedRoomData                           
SELECT               
  distinct BK.ID              
 ,BK.PROPERTYID              
 ,BK.CHECKINTIME              
 ,BK.CHECKOUTTIME    
 ,BK.Status as 'Status'            
 ,GUEST.FIRSTNAME              
 ,GUEST.LASTNAME            
 ,GUEST.ID AS GUESTID            
 ,RB.ID AS ROOMBOOKINGID            
 ,ROOM.ID AS ROOMID            
 ,ROOM.Number AS ROOMNUMBER 
 ,ROOM.RoomTypeID as RoomTypeID
 ,RoomType.NAME as RoomTypeName             
 FROM BOOKING BK INNER JOIN ROOMBOOKING RB               
 ON BK.ID = RB.BOOKINGID              
 INNER JOIN Room            
 ON RB.RoomID = Room.ID
 Inner JOIN RoomType
 On  Room.RoomTypeID = RoomType.ID           
 INNER JOIN GUEST              
 ON RB.GUESTID = GUEST.ID              
 WHERE (BK.CHECKINTIME >= ISNULL(@CHECKINTIME,'1900-01-01')              
 AND BK.CHECKOUTTIME <= ISNULL(stuff(convert(varchar(19), @CHECKOUTDATE, 126),11,1,' '), GETDATE()))       
 OR        
  ((BK.CHECKINTIME <= ISNULL(@CHECKINTIME,'1900-01-01') and BK.CheckoutTime >= ISNULL(stuff(convert(varchar(19), @CHECKOUTDATE, 126),11,1,' '), GETDATE())))        
 OR        
 ((BK.CHECKINTIME <= ISNULL(@CHECKINTIME,'1900-01-01') and ((BK.CheckoutTime <= ISNULL(stuff(convert(varchar(19), @CHECKOUTDATE, 126),11,1,' '), GETDATE())) and BK.CheckoutTime >= ISNULL(@CHECKINTIME,'1900-01-01'))))      
 OR        
 ((BK.CHECKINTIME <= ISNULL(@CHECKOUTDATE,'1900-01-01') and BK.CheckoutTime >= ISNULL(stuff(convert(varchar(19), @CHECKOUTDATE, 126),11,1,' '), GETDATE())))        
         
 AND BK.ISACTIVE=1    
      
 SELECT               
  null as ID              
 ,@PROPERTYID as PropertyID    
 , null as CHECKINTIME              
 ,null as CHECKOUTTIME    
 ,'Available' as 'Status'            
 ,null as FIRSTNAME              
 ,null as LASTNAME            
 ,null AS GUESTID            
 ,null AS ROOMBOOKINGID            
 ,ROOM.ID AS ROOMID            
 ,ROOM.Number AS ROOMNUMBER 
 ,Room.RoomTypeID As RoomTypeID
 ,RoomType.NAME as RoomTypeName
 from Room
  Inner JOIN RoomType
 On  Room.RoomTypeID = RoomType.ID 
  where Room.propertyid= @PROPERTYID and Room.ID not in     
 (select ROOMID from @BookedRoomData)    
     
 union    
     
 select * from  @BookedRoomData    
               
END 