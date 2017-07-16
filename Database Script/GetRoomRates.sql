

USE [PMS]
GO
/****** Object:  StoredProcedure [dbo].[GetRoomRates]    Script Date: 7/16/2017 11:18:54 AM ******/
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
,RateType.Hours as Hours
from RateType 
left outer join
Rates on
RateType.ID = Rates.RateTypeID
left outer join
RoomType on
Rates.RoomTypeID = RoomType.ID
where (Rates.IsActive = 1 or Rates.IsActive is null) and RateType.PropertyID = @PropertyId
and RateType.IsActive = 1
End
