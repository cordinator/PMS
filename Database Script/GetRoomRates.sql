--exec [GetRoomRates] 1
ALTER PROC [dbo].[GetRoomRates]  
@PropertyId INT  
AS BEGIN  
  
Select   
Rates.ID  
,Rates.Type  
,Rates.PropertyID  
,Rates.RateTypeID  
,Rates.RoomTypeID  
,Rates.InputKeyHours  
,Rates.Value  
,Rates.IsActive  
,Rates.CreatedBy  
,Rates.CreatedOn  
,Rates.LastUpdatedBy  
,Rates.LastUpdatedOn  
,RoomType.NAME as RoomTypeName  
,RateType.NAME as RateTypeName  
,RateType.ID as MasterRateTypeID  
,RateType.Hours
,RateType.IsActive as RateTypeIsActive
,RateType.Units
,Room.ID as RoomId 
,Room.Number as RoomNumber 
,Room.IsActive as RoomStatus 
,PropertyFloor.FloorNumber as FloorNumber  
,PropertyFloor.ID as FloorId  
--,RateType.Hours as Hours  
from RateType   
left outer join  
Rates on  
RateType.ID = Rates.RateTypeID  
left outer join  
RoomType on  
Rates.RoomTypeID = RoomType.ID  
left outer join  
Room on  
Room.ID = Rates.RoomId  
left outer join  
PropertyFloor on  
Room.FloorId = PropertyFloor.ID  
where RateType.PropertyID = @PropertyId  
and (RateType.IsActive = 1 or RateType.IsActive is null)
End  


  
  