USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Appointment_GetAppointmentSearchByCondition]    Script Date: 02/08/2017 16:38:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Phongnc 11/04/2015 update
-- =============================================
-- [Vehicle_ListVehicles_Paging] ' AND (cc.FK_ProvinceID = 49 OR 49 = 0 )  AND ((vo.VehicleTime IS NOT NULL AND DATEADD(mi,0, vo.VehicleTime) >= @Now) OR 0 = 0 )  AND	(vv.FK_VehicleTypeID = 0 OR 0 = 0 )  AND	(vv.FK_BusinessModelID = 0 OR 0 = 0 )  AND	(vvg.FK_VehicleGroupID IN ( 0 ) OR 0 = 0 )  AND	(vv.FK_LandmarkID = 0 OR 0 = 0 )  AND	(vv.FK_CompanyID IN ( 0 ) OR 0 = 0 ) ' , 'VehiclePlate','1','50000','vi' , '0'
ALTER PROCEDURE [dbo].[Appointment_GetAppointmentSearchByCondition] --1052,'vi'
	@OperationVehicleId		INT,
	@Culture		VARCHAR(5)
AS
BEGIN
	SELECT ap.[AppointmentID]
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
      ,ap.[IsMultiDays],
	apl.PK_OperationVehicleID,
	apl.Date, 
	apl.Description,
	apl.StatusId,
	apl.FK_VehicleID VehicleID,
	apl.DepositMoney DepositMoneyOp,
	apl.TotalMoney TotalMoneyOp,
	apl.TotalFee TotalFeeOp,
	--vv.VehiclePlate, //phongnc rào
	--vv.PrivateCode, //phongnc rào
	apl.PrivateCodes,
	ISNULL(hccl.DisplayName , hcc.Name)  StatusName ,
	ISNULL(hccl1.DisplayName , hcc1.Name)  PaymentTypeName ,
	ISNULL(hccl2.DisplayName , hcc2.Name)  CustomerTypeName ,
	op.Username OperatingUserName,
	op2.Username UpdatedByUserName, --người sửa lịch hẹn
	op1.Username ModifiedByUserName --người sửa lệnh điều
	
	FROM [Maintain.Appointments] ap
	INNER JOIN [Maintain.AppointmentLogs] apl ON ap.AppointmentID = apl.AppointmentID
	--LEFT JOIN [Vehicle.Vehicles] vv ON vv.PK_VehicleID = apl.FK_VehicleID //phongnc rào
	
	LEFT JOIN [Host.CategoryConfigurations] hcc ON apl.StatusId = hcc.PK_ConfigID
	LEFT JOIN (SELECT * FROM [Host.CategoryConfigurationLocates] WHERE Culture = @Culture) hccl ON hcc.PK_ConfigID = hccl.FK_ConfigID
	
	LEFT JOIN [Host.CategoryConfigurations] hcc1 ON ap.PaymentTypeId = hcc1.PK_ConfigID
	LEFT JOIN (SELECT * FROM [Host.CategoryConfigurationLocates] WHERE Culture = @Culture) hccl1 ON hcc1.PK_ConfigID = hccl1.FK_ConfigID
	
	LEFT JOIN [Host.CategoryConfigurations] hcc2 ON ap.CustomerTypeId = hcc2.PK_ConfigID
	LEFT JOIN (SELECT * FROM [Host.CategoryConfigurationLocates] WHERE Culture = @Culture) hccl2 ON hcc2.PK_ConfigID = hccl2.FK_ConfigID
	
	LEFT JOIN [Admin.Users] op ON apl.CreatedByUser = op.PK_UserID
	LEFT JOIN [Admin.Users] op1 ON apl.ModifiedByUser = op1.PK_UserID
	LEFT JOIN [Admin.Users] op2 ON ap.[UpdatedByUser] = op2.PK_UserID
	
	WHERE apl.PK_OperationVehicleID = @OperationVehicleId
	
	AND ap.IsDeleted = 0 AND apl.IsDeleted = 0
END
