USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Appointment_ListAppointment_Paging_Count_New]    Script Date: 02/08/2017 16:38:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Appointment_ListAppointment_Paging_Count_New]
    @CompanyID INT,
	@Culture VARCHAR(5),
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
                AND ( ( AP.CustomerName LIKE N'%' + @SearchText + '%' )
                        OR ( AP.PhoneNumber LIKE N'%' + @SearchText + '%' )
                        OR ( AP.Address LIKE N'%' + @SearchText + '%' )
                        OR ( AP.Route LIKE N'%' + @SearchText + '%' )
                        OR ( AP.PrivateCodes LIKE N'%' + @SearchText + '%' )
                        OR ( AP.RequestVehicles LIKE N'%' + @SearchText + '%' )
                    )
    END
