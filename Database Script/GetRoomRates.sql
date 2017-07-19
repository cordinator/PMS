USE [PMS]
GO
/****** Object:  StoredProcedure [dbo].[GetRoomRates]    Script Date: 7/19/2017 9:24:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[GetRoomRates]
@PropertyId INT
AS BEGIN

Select 
Rates.ID
,Rates.Type
,Rates.PropertyID
,Rates.RateTypeID
,Rates.RoomTypeID
,Rates.RoomId
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
,RateType.IsActive as RateTypeIsActive
,RateType.Units
,Room.Number as RoomNumber
,PropertyFloor.FloorNumber as FloorNumber
,PropertyFloor.ID as FloorId
,RateType.Hours as Hours
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


