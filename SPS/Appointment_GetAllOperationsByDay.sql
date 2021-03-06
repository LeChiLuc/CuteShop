USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Appointment_GetAllOperationsByDay]    Script Date: 02/08/2017 16:36:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- [Vehicle_ListVehicles_Paging] ' AND (cc.FK_ProvinceID = 49 OR 49 = 0 )  AND ((vo.VehicleTime IS NOT NULL AND DATEADD(mi,0, vo.VehicleTime) >= @Now) OR 0 = 0 )  AND	(vv.FK_VehicleTypeID = 0 OR 0 = 0 )  AND	(vv.FK_BusinessModelID = 0 OR 0 = 0 )  AND	(vvg.FK_VehicleGroupID IN ( 0 ) OR 0 = 0 )  AND	(vv.FK_LandmarkID = 0 OR 0 = 0 )  AND	(vv.FK_CompanyID IN ( 0 ) OR 0 = 0 ) ' , 'VehiclePlate','1','50000','vi' , '0'
ALTER PROCEDURE [dbo].[Appointment_GetAllOperationsByDay] --'dda5c64d-ce8d-4350-bd02-f1d0e518a0f3'
	@ConditionOnline	NVARCHAR(MAX),
	@Culture			VARCHAR(5)
AS
BEGIN
	DECLARE @sql NVARCHAR(MAX)
	
	SET @sql = '
		SELECT rs.* FROM 
		(
		SELECT 
		ap.[AppointmentID]
      ,ap.[CustomerName]
      ,ap.[PhoneNumber]
      ,ap.[Address]
      ,ap.[TimeToCome]
      ,ap.[MinutesWarning]
      ,ap.[StartDate]
      ,ap.[EndDate]
      ,ap.[DaysOfWeek]
      ,ap.[Route]
      ,ap.[Note]
      ,ap.[RequestVehicles]
      ,ap.[FK_CompanyID]
      ,ap.[PaymentTypeId]
      ,ap.[CustomerTypeId]
      ,ap.[DepositMoney]
      ,ap.[TotalMoney]
      ,ap.[TotalFee]
      ,ap.[CreatedByUser]
      ,ap.[CreatedDate]
      ,ap.[UpdatedByUser]
      ,ap.[UpdatedDate]
      ,ap.[IsDeleted]
      ,ap.[IsMultiDays]
		, apl.Date
		, apl.Description ,
		apl.StatusId,
		apl.PK_OperationVehicleID,
		apl.FK_VehicleID VehicleID,
		apl.PrivateCodes,
		vv.VehiclePlate,
		vv.PrivateCode,
		vt.Name VehicleTypeName,
		  ISNULL(vt.Seat,0) VehicleSeat,
		
		ISNULL(hccl.DisplayName , hcc.Name)  StatusName, 
		ISNULL(hccl1.DisplayName , hcc1.Name)  PaymentTypeName, 
		ISNULL(hccl2.DisplayName , hcc2.Name)  CustomerTypeName, 
		ROW_NUMBER() OVER (ORDER BY ap.CustomerName ) RowRs FROM
		[Maintain.Appointments] ap
		INNER JOIN [Maintain.AppointmentLogs] apl ON ap.AppointmentID = apl.AppointmentID
		LEFT JOIN (
			SELECT PK_ConfigID , Name , Value FROM [Host.CategoryConfigurations] hcc  
			WHERE ParentID = 48
		) hcc ON apl.StatusId = hcc.PK_ConfigID

		LEFT JOIN (SELECT * FROM [Host.CategoryConfigurationLocates] WHERE Culture = ''' + @Culture + ''') hccl ON hcc.PK_ConfigID = hccl.FK_ConfigID
		
		LEFT JOIN [Host.CategoryConfigurations] hcc1 ON ap.PaymentTypeId = hcc1.PK_ConfigID
		LEFT JOIN (SELECT * FROM [Host.CategoryConfigurationLocates] WHERE Culture = ''' + @Culture + ''') hccl1 ON hcc1.PK_ConfigID = hccl1.FK_ConfigID
		
		LEFT JOIN [Host.CategoryConfigurations] hcc2 ON ap.CustomerTypeId = hcc2.PK_ConfigID
		LEFT JOIN (SELECT * FROM [Host.CategoryConfigurationLocates] WHERE Culture = ''' + @Culture + ''') hccl2 ON hcc2.PK_ConfigID = hccl2.FK_ConfigID


		LEFT JOIN [Vehicle.Vehicles] vv
		ON apl.FK_VehicleID = vv.PK_VehicleID
		
		LEFT JOIN [Vehicle.VehicleGroups] vvg
		ON vv.PK_VehicleID = vvg.FK_VehicleID
		
		LEFT JOIN [Vehicle.VehicleTypes] vt
		ON vv.FK_VehicleTypeID = vt.PK_VehicleTypeID

		WHERE ap.IsDeleted = 0 AND apl.IsDeleted = 0 ' +  @ConditionOnline  + ' 
		)rs
		'
	EXEC(@sql)
END
