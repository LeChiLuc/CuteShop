USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Appointment_ListAppointment_Paging_Count]    Script Date: 02/08/2017 16:38:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Appointment_ListAppointment_Paging_Count]
    @CompanyID INT,
	@Culture VARCHAR(5),
	@SearchType TINYINT,
	@SearchText NVARCHAR(100),
	@FromDate DATETIME,
	@ToDate DATETIME,
	@FromMoney FLOAT,
	@ToMoney FLOAT,
	@StatusID INT
AS 
    BEGIN
        SELECT  COUNT(1)
        FROM    [Maintain.Appointments] AS  AP
                INNER JOIN [Maintain.AppointmentLogs] AS APL ON AP.AppointmentID = APL.AppointmentID
                LEFT JOIN ( SELECT  PK_ConfigID ,
                                    Name ,
                                    Value
                            FROM    [Host.CategoryConfigurations] HCC
                            WHERE   ParentID = 48
                          ) hcc ON APL.StatusId = HCC.PK_ConfigID
                LEFT JOIN ( SELECT  *
                            FROM    [Host.CategoryConfigurationLocates]
                            WHERE   Culture = @Culture
                          ) HCCL ON HCC.PK_ConfigID = HCCL.FK_ConfigID
        WHERE   AP.IsDeleted = 0
                AND APL.IsDeleted = 0
                AND ( DATEADD(DAY,DATEDIFF(DAY, 0,APL.Date),CONVERT (VARCHAR(10), AP.TimeToCome)) BETWEEN @FromDate AND @ToDate )
                AND ( APL.TotalMoney >= @FromMoney OR @FromMoney = 0)
                AND ( APL.TotalMoney <= @ToMoney OR @ToMoney = 0)
                AND ( APL.StatusId = @StatusID OR @StatusID = 0)
                AND ( AP.FK_CompanyID = @CompanyID )
                AND ( 
						( @SearchType = '0' AND AP.CustomerName LIKE N'%' + @SearchText + '%' )
                        OR ( @SearchType = '1' AND AP.PhoneNumber LIKE N'%' + @SearchText + '%' )
                        OR ( @SearchType = '2' AND AP.Address LIKE N'%' + @SearchText + '%' )
                        OR ( @SearchType = '3' AND AP.Route LIKE N'%' + @SearchText + '%' )
                        OR ( @SearchType = '4' AND (LEN(@SearchText) =0 OR @SearchText IN (SELECT item FROM dbo.fnSplit(APL.PrivateCodes,','))) )
                        OR ( @SearchType = '5' AND AP.RequestVehicles LIKE N'%' + @SearchText + '%' )
                    )
    END
