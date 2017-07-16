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
,RateType.Hours as Hours
from Rates 
inner join
RoomType on
Rates.RoomTypeID  = RoomType.ID
inner join
RateType on
Rates.RateTypeID = RateType.ID
where Rates.IsActive = 1 and Rates.PropertyID = @PropertyId
End
