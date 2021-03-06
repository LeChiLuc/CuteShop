USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Appointment_SearchAppointment]    Script Date: 02/08/2017 16:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		trungtq
-- Create date: 22/06/2015
-- Description:	Lấy danh sách lịch hẹn
-- =============================================
ALTER PROCEDURE [dbo].[Appointment_SearchAppointment]
    @CompanyID INT ,
    @StartDate DATETIME ,
    @EndDate DATETIME ,
    @Culture VARCHAR(5) ,
    @StatusId INT ,
    @IsAll BIT
AS 
    BEGIN
        IF ( @IsAll = 1 ) 
            BEGIN
                SELECT  RS.[AppointmentID] ,
                        RS.[CustomerName] ,
                        RS.[PhoneNumber] ,
                        RS.[Address] ,
                        RS.[TimeToCome] ,
                        RS.[MinutesWarning] ,
                        RS.[StartDate] ,
                        RS.[EndDate] ,
                        RS.[DaysOfWeek] ,
                        RS.[Route] ,
                        RS.[Note] ,
                        RS.[RequestVehicles] ,
                        RS.[FK_CompanyID] ,
                        RS.[PaymentTypeId] ,
                        RS.[CustomerTypeId] ,
                        RS.[DepositMoney] ,
                        RS.[TotalMoney] ,
                        RS.[TotalFee] ,
                        RS.[CreatedByUser] ,
                        RS.[CreatedDate] ,
                        RS.[UpdatedByUser] ,
                        RS.[UpdatedDate] ,
                        RS.[IsDeleted] ,
                        RS.[IsMultiDays] ,
                        RS.Date ,
                        RS.Description ,
                        RS.StatusId ,
                        RS.PK_OperationVehicleID ,
                        RS.VehicleID ,
                        RS.PrivateCodes ,
                        RS.VehiclePlate ,
                        RS.PrivateCode ,
                        RS.VehicleTypeName ,
                        RS.VehicleSeat ,
                        RS.StatusName ,
                        RS.PaymentTypeName ,
                        RS.CustomerTypeName ,
                        RS.RowRs
                FROM    ( SELECT    AP.[AppointmentID] ,
                                    AP.[CustomerName] ,
                                    AP.[PhoneNumber] ,
                                    AP.[Address] ,
                                    AP.[TimeToCome] ,
                                    AP.[MinutesWarning] ,
                                    AP.[StartDate] ,
                                    AP.[EndDate] ,
                                    AP.[DaysOfWeek] ,
                                    AP.[Route] ,
                                    AP.[Note] ,
                                    AP.[RequestVehicles] ,
                                    AP.[FK_CompanyID] ,
                                    AP.[PaymentTypeId] ,
                                    AP.[CustomerTypeId] ,
                                    AP.[DepositMoney] ,
                                    AP.[TotalMoney] ,
                                    AP.[TotalFee] ,
                                    AP.[CreatedByUser] ,
                                    ap.[CreatedDate] ,
                                    AP.[UpdatedByUser] ,
                                    AP.[UpdatedDate] ,
                                    AP.[IsDeleted] ,
                                    AP.[IsMultiDays] ,
                                    APL.Date ,
                                    APL.Description ,
                                    APL.StatusId ,
                                    APL.PK_OperationVehicleID ,
                                    APL.FK_VehicleID VehicleID ,
                                    APL.PrivateCodes ,
                                    VV.VehiclePlate ,
                                    VV.PrivateCode ,
                                    VT.Name VehicleTypeName ,
                                    CAST(ISNULL(VT.Seat, 0) AS INT) AS VehicleSeat ,
                                    ISNULL(HCCL.DisplayName, HCC.Name) StatusName ,
                                    ISNULL(HCCL1.DisplayName, HCC1.Name) PaymentTypeName ,
                                    ISNULL(HCCL2.DisplayName, HCC2.Name) CustomerTypeName ,
                                    ROW_NUMBER() OVER ( ORDER BY ap.CustomerName ) RowRs
                          FROM      [Maintain.Appointments] AS AP
                                    INNER JOIN [Maintain.AppointmentLogs] AS APL ON ap.AppointmentID = apl.AppointmentID
                                                              AND APL.FK_CompanyID = @CompanyID
                                    LEFT JOIN ( SELECT  PK_ConfigID ,
                                                        Name ,
                                                        Value
                                                FROM    [Host.CategoryConfigurations]
                                                        AS HCC
                                                WHERE   ParentID = 48
                                              ) HCC ON APL.StatusId = HCC.PK_ConfigID
                                    LEFT JOIN ( SELECT  FK_ConfigID ,
                                                        Culture ,
                                                        DisplayName ,
                                                        Description ,
                                                        CreatedDate ,
                                                        CreatedByUser ,
                                                        UpdatedByUser ,
                                                        UpdatedDate
                                                FROM    [Host.CategoryConfigurationLocates]
                                                WHERE   Culture = @Culture
                                              ) HCCL ON HCC.PK_ConfigID = HCCL.FK_ConfigID
                                    LEFT JOIN [Host.CategoryConfigurations] HCC1 ON AP.PaymentTypeId = HCC1.PK_ConfigID
                                    LEFT JOIN ( SELECT  FK_ConfigID ,
                                                        Culture ,
                                                        DisplayName ,
                                                        Description ,
                                                        CreatedDate ,
                                                        CreatedByUser ,
                                                        UpdatedByUser ,
                                                        UpdatedDate
                                                FROM    [Host.CategoryConfigurationLocates]
                                                WHERE   Culture = @Culture
                                              ) HCCL1 ON HCC1.PK_ConfigID = HCCL1.FK_ConfigID
                                    LEFT JOIN [Host.CategoryConfigurations] HCC2 ON AP.CustomerTypeId = HCC2.PK_ConfigID
                                    LEFT JOIN ( SELECT  FK_ConfigID ,
                                                        Culture ,
                                                        DisplayName ,
                                                        Description ,
                                                        CreatedDate ,
                                                        CreatedByUser ,
                                                        UpdatedByUser ,
                                                        UpdatedDate
                                                FROM    [Host.CategoryConfigurationLocates]
                                                WHERE   Culture = @Culture
                                              ) HCCL2 ON HCC2.PK_ConfigID = HCCL2.FK_ConfigID
                                    LEFT JOIN [Vehicle.Vehicles] VV ON APL.FK_VehicleID = VV.PK_VehicleID
                                                              AND VV.FK_CompanyID = @CompanyID
                                    LEFT JOIN [Vehicle.VehicleGroups] VVG ON VV.PK_VehicleID = VVG.FK_VehicleID
                                    LEFT JOIN [Vehicle.VehicleTypes] VT ON VV.FK_VehicleTypeID = VT.PK_VehicleTypeID
                          WHERE     AP.FK_CompanyID = @CompanyID
                                    AND APL.FK_CompanyID = @CompanyID
                                    AND AP.IsDeleted = 0
                                    AND APL.IsDeleted = 0
                                    AND DATEADD(day,
                                                DATEDIFF(day, 0, APL.Date),
                                                CONVERT (VARCHAR(10), AP.TimeToCome)) BETWEEN @StartDate
                                                              AND
                                                              @EndDate
                                    AND APL.StatusId = @StatusId
                        ) RS
                ORDER BY RS.TimeToCome ASC 
            END 
        ELSE 
            BEGIN
                SELECT  RS.[AppointmentID] ,
                        RS.[CustomerName] ,
                        RS.[PhoneNumber] ,
                        RS.[Address] ,
                        RS.[TimeToCome] ,
                        RS.[MinutesWarning] ,
                        RS.[StartDate] ,
                        RS.[EndDate] ,
                        RS.[DaysOfWeek] ,
                        RS.[Route] ,
                        RS.[Note] ,
                        RS.[RequestVehicles] ,
                        RS.[FK_CompanyID] ,
                        RS.[PaymentTypeId] ,
                        RS.[CustomerTypeId] ,
                        RS.[DepositMoney] ,
                        RS.[TotalMoney] ,
                        RS.[TotalFee] ,
                        RS.[CreatedByUser] ,
                        RS.[CreatedDate] ,
                        RS.[UpdatedByUser] ,
                        RS.[UpdatedDate] ,
                        RS.[IsDeleted] ,
                        RS.[IsMultiDays] ,
                        RS.Date ,
                        RS.Description ,
                        RS.StatusId ,
                        RS.PK_OperationVehicleID ,
                        RS.VehicleID ,
                        RS.PrivateCodes ,
                        RS.VehiclePlate ,
                        RS.PrivateCode ,
                        RS.VehicleTypeName ,
                        RS.VehicleSeat ,
                        RS.StatusName ,
                        RS.PaymentTypeName ,
                        RS.CustomerTypeName ,
                        RS.RowRs
                FROM    ( SELECT    AP.[AppointmentID] ,
                                    AP.[CustomerName] ,
                                    AP.[PhoneNumber] ,
                                    AP.[Address] ,
                                    AP.[TimeToCome] ,
                                    AP.[MinutesWarning] ,
                                    AP.[StartDate] ,
                                    AP.[EndDate] ,
                                    AP.[DaysOfWeek] ,
                                    AP.[Route] ,
                                    AP.[Note] ,
                                    AP.[RequestVehicles] ,
                                    AP.[FK_CompanyID] ,
                                    AP.[PaymentTypeId] ,
                                    AP.[CustomerTypeId] ,
                                    AP.[DepositMoney] ,
                                    AP.[TotalMoney] ,
                                    AP.[TotalFee] ,
                                    AP.[CreatedByUser] ,
                                    ap.[CreatedDate] ,
                                    AP.[UpdatedByUser] ,
                                    AP.[UpdatedDate] ,
                                    AP.[IsDeleted] ,
                                    AP.[IsMultiDays] ,
                                    APL.Date ,
                                    APL.Description ,
                                    APL.StatusId ,
                                    APL.PK_OperationVehicleID ,
                                    APL.FK_VehicleID VehicleID ,
                                    APL.PrivateCodes ,
                                    VV.VehiclePlate ,
                                    VV.PrivateCode ,
                                    VT.Name VehicleTypeName ,
                                    CAST(ISNULL(VT.Seat, 0) AS INT) AS VehicleSeat ,
                                    ISNULL(HCCL.DisplayName, HCC.Name) StatusName ,
                                    ISNULL(HCCL1.DisplayName, HCC1.Name) PaymentTypeName ,
                                    ISNULL(HCCL2.DisplayName, HCC2.Name) CustomerTypeName ,
                                    ROW_NUMBER() OVER ( ORDER BY ap.CustomerName ) RowRs
                          FROM      [Maintain.Appointments] AS AP
                                    INNER JOIN [Maintain.AppointmentLogs] AS APL ON ap.AppointmentID = apl.AppointmentID
                                                              AND APL.FK_CompanyID = @CompanyID
                                    LEFT JOIN ( SELECT  PK_ConfigID ,
                                                        Name ,
                                                        Value
                                                FROM    [Host.CategoryConfigurations]
                                                        AS HCC
                                                WHERE   ParentID = 48
                                              ) HCC ON APL.StatusId = HCC.PK_ConfigID
                                    LEFT JOIN ( SELECT  FK_ConfigID ,
                                                        Culture ,
                                                        DisplayName ,
                                                        Description ,
                                                        CreatedDate ,
                                                        CreatedByUser ,
                                                        UpdatedByUser ,
                                                        UpdatedDate
                                                FROM    [Host.CategoryConfigurationLocates]
                                                WHERE   Culture = @Culture
                                              ) HCCL ON HCC.PK_ConfigID = HCCL.FK_ConfigID
                                    LEFT JOIN [Host.CategoryConfigurations] HCC1 ON AP.PaymentTypeId = HCC1.PK_ConfigID
                                    LEFT JOIN ( SELECT  FK_ConfigID ,
                                                        Culture ,
                                                        DisplayName ,
                                                        Description ,
                                                        CreatedDate ,
                                                        CreatedByUser ,
                                                        UpdatedByUser ,
                                                        UpdatedDate
                                                FROM    [Host.CategoryConfigurationLocates]
                                                WHERE   Culture = @Culture
                                              ) HCCL1 ON HCC1.PK_ConfigID = HCCL1.FK_ConfigID
                                    LEFT JOIN [Host.CategoryConfigurations] HCC2 ON AP.CustomerTypeId = HCC2.PK_ConfigID
                                    LEFT JOIN ( SELECT  FK_ConfigID ,
                                                        Culture ,
                                                        DisplayName ,
                                                        Description ,
                                                        CreatedDate ,
                                                        CreatedByUser ,
                                                        UpdatedByUser ,
                                                        UpdatedDate
                                                FROM    [Host.CategoryConfigurationLocates]
                                                WHERE   Culture = @Culture
                                              ) HCCL2 ON HCC2.PK_ConfigID = HCCL2.FK_ConfigID
                                    LEFT JOIN [Vehicle.Vehicles] VV ON APL.FK_VehicleID = VV.PK_VehicleID
                                                              AND VV.FK_CompanyID = @CompanyID
                                    LEFT JOIN [Vehicle.VehicleGroups] VVG ON VV.PK_VehicleID = VVG.FK_VehicleID
                                    LEFT JOIN [Vehicle.VehicleTypes] VT ON VV.FK_VehicleTypeID = VT.PK_VehicleTypeID
                          WHERE     AP.FK_CompanyID = @CompanyID
                                    AND APL.FK_CompanyID = @CompanyID
                                    AND AP.IsDeleted = 0
                                    AND APL.IsDeleted = 0
                                    AND DATEADD(day,
                                                DATEDIFF(day, 0, APL.Date),
                                                CONVERT (VARCHAR(10), AP.TimeToCome)) BETWEEN @StartDate
                                                              AND
                                                              @EndDate
                                    AND DATEADD(day,
                                                DATEDIFF(day, 0, APL.Date),
                                                CONVERT (VARCHAR(10), AP.TimeToCome)) <= DATEADD(minute,
                                                              AP.MinutesWarning,
                                                              GETDATE())
                                    AND APL.StatusId = @StatusId
                        ) RS
                ORDER BY RS.TimeToCome ASC 
            END	    
    END
-----------------------------------------------------------------------------------------------------------
