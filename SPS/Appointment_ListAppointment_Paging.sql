USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Appointment_ListAppointment_Paging]    Script Date: 02/08/2017 16:38:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Appointment_ListAppointment_Paging]
	@CompanyID INT,
	@Culture VARCHAR(5),
	@SearchType TINYINT,
	@SearchText NVARCHAR(100)='',
	@FromDate DATETIME,
	@ToDate DATETIME,
	@FromMoney FLOAT,
	@ToMoney FLOAT,
	@StatusID INT,
    @Order VARCHAR(100) ,
    @StartRow INT ,
    @EndRow INT
AS 
    BEGIN
	
        SELECT  RS.*
        FROM    ( SELECT    RS1.* ,
                            ROW_NUMBER() OVER ( ORDER BY DATEADD(DAY,DATEDIFF(DAY, 0,[Date]),CONVERT (VARCHAR(10), TimeToCome))  ASC ) RowRs
                  FROM      ( SELECT    AP.AppointmentID ,
                                        AP.CustomerName ,
                                        AP.Address ,
                                        AP.PhoneNumber ,
                                        AP.TimeToCome ,
										APL.[Date] ,
                                        AP.Route ,
                                        AP.RequestVehicles ,
										AP.CreatedDate ,
										AP.UpdatedByUser ,
										AP.UpdatedDate ,
										AP.IsDeleted ,
                                        APL.TotalMoney ,
                                        APL.PrivateCodes ,
										APL.ModifiedByUser ,
										APL.ModifiedDate ,
										APL.Description AS  Note ,
                                        ISNULL(HCCL1.DisplayName, HCC1.Value) AS  PaymentTypeName ,
                                        ISNULL(HCCL2.DisplayName, HCC2.Value) AS  CustomerTypeName ,
                                        ISNULL(HCCL.DisplayName, HCC.Value) AS  StatusName ,
                                        ISNULL(OUU.Username, OUC.Username) AS  OperatingUserName ,
                                        OUC.Username AS  CreatedByUserName ,
                                        OUC1.Username AS  UpdatedByUserName ,
                                        OUU.Username AS   ModifiedByUserName ,
                                        ( SELECT TOP 1
                                                    APL1.PK_OperationVehicleID
                                          FROM      [Maintain.AppointmentLogs] APL1
                                          WHERE     APL1.AppointmentID = AP.AppointmentID
                                                    AND APL.[Date] = APL1.[Date]
                                        ) AS PK_OperationVehicleID
                              FROM      [Maintain.Appointments] AP
                                        INNER JOIN [Maintain.AppointmentLogs] APL ON AP.AppointmentID = APL.AppointmentID
                                        LEFT JOIN ( SELECT  PK_ConfigID ,
                                                            Name ,
                                                            Value
                                                    FROM    [Host.CategoryConfigurations] HCC
                                                    WHERE   ParentID = 48
                                                  ) HCC ON APL.StatusId = HCC.PK_ConfigID
                                        LEFT JOIN ( SELECT  *
                                                    FROM    [Host.CategoryConfigurationLocates]
                                                    WHERE   Culture = @Culture
                                                  ) HCCL ON HCC.PK_ConfigID = HCCL.FK_ConfigID
                                        LEFT JOIN [Host.CategoryConfigurations] HCC1 ON AP.PaymentTypeId = HCC1.PK_ConfigID
                                        LEFT JOIN ( SELECT  *
                                                    FROM    [Host.CategoryConfigurationLocates]
                                                    WHERE   Culture = @Culture
                                                  ) HCCL1 ON HCC1.PK_ConfigID = HCCL1.FK_ConfigID
                                        LEFT JOIN [Host.CategoryConfigurations] HCC2 ON ap.CustomerTypeId = HCC2.PK_ConfigID
                                        LEFT JOIN ( SELECT  *
                                                    FROM    [Host.CategoryConfigurationLocates]
                                                    WHERE   Culture = @Culture
                                                  ) HCCL2 ON HCC2.PK_ConfigID = HCCL2.FK_ConfigID
                                        LEFT JOIN [Admin.Users] AS  OUC ON AP.CreatedByUser = OUC.PK_UserID
                                        LEFT JOIN [Admin.Users] AS  OUC1 ON AP.UpdatedByUser = OUC1.PK_UserID
                                        LEFT JOIN [Admin.Users] AS  OUU ON APL.ModifiedByUser = OUU.PK_UserID
                              WHERE     AP.IsDeleted = 0
                                        AND APL.IsDeleted = 0
                                        AND ( DATEADD(DAY,DATEDIFF(DAY, 0,APL.Date),CONVERT (VARCHAR(10), AP.TimeToCome)) BETWEEN @FromDate AND @ToDate )
                                        AND ( APL.TotalMoney >= @FromMoney OR @FromMoney = 0)
                                        AND ( APL.TotalMoney <= @ToMoney OR @ToMoney = 0)
                                        AND ( APL.StatusId = @StatusID OR @StatusID = 0)
                                        AND ( AP.FK_CompanyID = @CompanyID )
                                        AND (( @SearchType = '0' AND AP.CustomerName LIKE N'%' + @SearchText + '%' )
											OR ( @SearchType = '1' AND AP.PhoneNumber LIKE N'%' + @SearchText + '%' )
											OR ( @SearchType = '2' AND AP.Address LIKE N'%' + @SearchText + '%' )
											OR ( @SearchType = '3' AND AP.Route LIKE N'%' + @SearchText + '%' )
											OR ( @SearchType = '4' AND (LEN(@SearchText) =0 OR @SearchText IN (SELECT item FROM dbo.fnSplit(APL.PrivateCodes,','))) )
											OR ( @SearchType = '5' AND AP.RequestVehicles LIKE N'%' + @SearchText + '%' )
										)
                            ) RS1
                ) RS
        WHERE   RS.RowRs BETWEEN @StartRow AND @EndRow

    END
