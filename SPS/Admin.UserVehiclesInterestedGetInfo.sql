USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin.UserVehiclesInterestedGetInfo]    Script Date: 02/08/2017 16:22:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Stored Procedure

ALTER PROC [dbo].[Admin.UserVehiclesInterestedGetInfo]
    @userID UNIQUEIDENTIFIER ,
    @contents NVARCHAR(500) ,
    @types INT ,
    @fromDate DATETIME ,
    @toDate DATETIME
AS
    BEGIN
        DECLARE @companyIDs NVARCHAR(MAX)
        SET @companyIDs = ''
        SELECT  @CompanyIDs = @CompanyIDs + CAST(PK_CompanyID AS NVARCHAR(5))
                + ','
        FROM    dbo.[Company.Companies]
        WHERE   PK_CompanyID IN ( SELECT    FK_CompanyID
                                  FROM      dbo.[Admin.UserAssignManager]
                                  WHERE     IsDeleted = 0
                                            AND FK_UserID = @userID )
                AND CompanyType = 3
                AND [Company.Companies].IsDeleted = 0

        IF ( @contents = ''
             OR @types = 0
           )
            BEGIN
                SELECT  *
                FROM    ( SELECT    vv.PK_VehicleID ,
                                    vv.XNCode ,
                                    vv.PrivateCode ,
                                    vv.VehiclePlate ,
                                    mt.Name AS MeterType ,
                                    vv.DeviceType ,
                                    sv.PhoneNumber AS SIM ,
                                    tt.FK_AlertTypeID AS AlertTypeID ,
                                    'types'
                                    + CAST(tt.FK_AlertTypeID AS NVARCHAR(5)) AS FK_AlertTypeID ,
                                    COUNT(tt.PK_WarningID) AS Total
                          FROM      dbo.[Vehicle.Vehicles] vv
                                    INNER JOIN dbo.fnGetWarningByCurrentDate(@fromDate,
                                                              @toDate,
                                                              @companyIDs) tt ON vv.PK_VehicleID = tt.FK_VehicleID
                                    LEFT JOIN dbo.[Meter.MeterTypes] mt ON vv.FK_MeterTypeID = mt.PK_MeterTypeID
                                    LEFT JOIN dbo.[Sim.Vehicles] sv ON sv.FK_VehicleID = vv.PK_VehicleID
                          WHERE     vv.FK_CompanyID IN (
                                    SELECT  *
                                    FROM    dbo.fnSplit(@companyIDs, ',') )
                                    AND tt.FK_AlertTypeID NOT IN (
                                    SELECT  FK_AlertTypeID
                                    FROM    dbo.[Admin.ProcessVehiclesNotify]
                                    WHERE   FK_WarningID = tt.PK_WarningID
                                            OR ( FK_AlertTypeID = tt.FK_AlertTypeID
                                                 AND FK_VehicleID = tt.FK_VehicleID
                                                 AND ExpiredDate >= GETDATE()
                                               ) )
                          GROUP BY  vv.PK_VehicleID ,
                                    vv.XNCode ,
                                    vv.PrivateCode ,
                                    vv.VehiclePlate ,
                                    mt.Name ,
                                    vv.DeviceType ,
                                    sv.PhoneNumber ,
                                    tt.FK_AlertTypeID
                          HAVING    COUNT(tt.PK_WarningID) > 0
                        ) AS s PIVOT
		( COUNT(Total) FOR FK_AlertTypeID IN ( types3, types4, types5, types11 ) ) AS tblPivot
                ORDER BY ( types3 + types4 + types5 + types11 ) DESC
            END
        ELSE
            BEGIN
                IF ( @types = 2 )
                    BEGIN
                        SELECT  *
                        FROM    ( SELECT    vv.PK_VehicleID ,
                                            vv.XNCode ,
                                            vv.PrivateCode ,
                                            vv.VehiclePlate ,
                                            mt.Name AS MeterType ,
                                            vv.DeviceType ,
                                            sv.PhoneNumber AS SIM ,
                                            tt.FK_AlertTypeID AS AlertTypeID ,
                                            'types'
                                            + CAST(tt.FK_AlertTypeID AS NVARCHAR(5)) AS FK_AlertTypeID ,
                                            COUNT(tt.PK_WarningID) AS Total
                                  FROM      dbo.[Vehicle.Vehicles] vv
                                            INNER JOIN dbo.fnGetWarningByCurrentDate(@fromDate,
                                                              @toDate,
                                                              @companyIDs) tt ON vv.PK_VehicleID = tt.FK_VehicleID
                                            LEFT JOIN dbo.[Meter.MeterTypes] mt ON vv.FK_MeterTypeID = mt.PK_MeterTypeID
                                            LEFT JOIN dbo.[Sim.Vehicles] sv ON sv.FK_VehicleID = vv.PK_VehicleID
                                  WHERE     vv.VehiclePlate = @contents
                                            AND vv.FK_CompanyID IN (
                                            SELECT  *
                                            FROM    dbo.fnSplit(@companyIDs,
                                                              ',') )
                                            AND tt.FK_AlertTypeID NOT IN (
                                            SELECT  FK_AlertTypeID
                                            FROM    dbo.[Admin.ProcessVehiclesNotify]
                                            WHERE   FK_WarningID = tt.PK_WarningID
                                                    OR ( FK_AlertTypeID = tt.FK_AlertTypeID
                                                         AND FK_VehicleID = tt.FK_VehicleID
                                                         AND ExpiredDate >= GETDATE()
                                                       ) )
                                  GROUP BY  vv.PK_VehicleID ,
                                            vv.XNCode ,
                                            vv.PrivateCode ,
                                            vv.VehiclePlate ,
                                            mt.Name ,
                                            vv.DeviceType ,
                                            sv.PhoneNumber ,
                                            tt.FK_AlertTypeID
                                  HAVING    COUNT(tt.PK_WarningID) > 0
                                ) AS s PIVOT
		( COUNT(Total) FOR FK_AlertTypeID IN ( types3, types4, types5, types11 ) ) AS tblPivot
                        ORDER BY ( types3 + types4 + types5 + types11 ) DESC
                    END
                ELSE
                    IF ( @types = 3 )
                        BEGIN
                            SELECT  *
                            FROM    ( SELECT    vv.PK_VehicleID ,
                                                vv.XNCode ,
                                                vv.PrivateCode ,
                                                vv.VehiclePlate ,
                                                mt.Name AS MeterType ,
                                                vv.DeviceType ,
                                                sv.PhoneNumber AS SIM ,
                                                tt.FK_AlertTypeID AS AlertTypeID ,
                                                'types'
                                                + CAST(tt.FK_AlertTypeID AS NVARCHAR(5)) AS FK_AlertTypeID ,
                                                COUNT(tt.PK_WarningID) AS Total
                                      FROM      dbo.[Vehicle.Vehicles] vv
                                                INNER JOIN dbo.fnGetWarningByCurrentDate(@fromDate,
                                                              @toDate,
                                                              @companyIDs) tt ON vv.PK_VehicleID = tt.FK_VehicleID
                                                LEFT JOIN dbo.[Meter.MeterTypes] mt ON vv.FK_MeterTypeID = mt.PK_MeterTypeID
                                                LEFT JOIN dbo.[Sim.Vehicles] sv ON sv.FK_VehicleID = vv.PK_VehicleID
                                      WHERE     vv.PrivateCode = @contents
                                                AND vv.FK_CompanyID IN (
                                                SELECT  *
                                                FROM    dbo.fnSplit(@companyIDs,
                                                              ',') )
                                                AND tt.FK_AlertTypeID NOT IN (
                                                SELECT  FK_AlertTypeID
                                                FROM    dbo.[Admin.ProcessVehiclesNotify]
                                                WHERE   FK_WarningID = tt.PK_WarningID
                                                        OR ( FK_AlertTypeID = tt.FK_AlertTypeID
                                                             AND FK_VehicleID = tt.FK_VehicleID
                                                             AND ExpiredDate >= GETDATE()
                                                           ) )
                                      GROUP BY  vv.PK_VehicleID ,
                                                vv.XNCode ,
                                                vv.PrivateCode ,
                                                vv.VehiclePlate ,
                                                mt.Name ,
                                                vv.DeviceType ,
                                                sv.PhoneNumber ,
                                                tt.FK_AlertTypeID
                                      HAVING    COUNT(tt.PK_WarningID) > 0
                                    ) AS s PIVOT
		( COUNT(Total) FOR FK_AlertTypeID IN ( types3, types4, types5, types11 ) ) AS tblPivot
                            ORDER BY ( types3 + types4 + types5 + types11 ) DESC
                        END
                    ELSE
                        BEGIN
                            SELECT  *
                            FROM    ( SELECT    vv.PK_VehicleID ,
                                                vv.XNCode ,
                                                vv.PrivateCode ,
                                                vv.VehiclePlate ,
                                                mt.Name AS MeterType ,
                                                vv.DeviceType ,
                                                sv.PhoneNumber AS SIM ,
                                                tt.FK_AlertTypeID AS AlertTypeID ,
                                                'types'
                                                + CAST(tt.FK_AlertTypeID AS NVARCHAR(5)) AS FK_AlertTypeID ,
                                                COUNT(tt.PK_WarningID) AS Total
                                      FROM      dbo.[Vehicle.Vehicles] vv
                                                INNER JOIN dbo.fnGetWarningByCurrentDate(@fromDate,
                                                              @toDate,
                                                              @companyIDs) tt ON vv.PK_VehicleID = tt.FK_VehicleID
                                                LEFT JOIN dbo.[Meter.MeterTypes] mt ON vv.FK_MeterTypeID = mt.PK_MeterTypeID
                                                LEFT JOIN dbo.[Sim.Vehicles] sv ON sv.FK_VehicleID = vv.PK_VehicleID
                                      WHERE     vv.XNCode = @contents
                                                AND vv.FK_CompanyID IN (
                                                SELECT  *
                                                FROM    dbo.fnSplit(@companyIDs,
                                                              ',') )
                                                AND tt.FK_AlertTypeID NOT IN (
                                                SELECT  FK_AlertTypeID
                                                FROM    dbo.[Admin.ProcessVehiclesNotify]
                                                WHERE   FK_WarningID = tt.PK_WarningID
                                                        OR ( FK_AlertTypeID = tt.FK_AlertTypeID
                                                             AND FK_VehicleID = tt.FK_VehicleID
                                                             AND ExpiredDate >= GETDATE()
                                                           ) )
                                      GROUP BY  vv.PK_VehicleID ,
                                                vv.XNCode ,
                                                vv.PrivateCode ,
                                                vv.VehiclePlate ,
                                                mt.Name ,
                                                vv.DeviceType ,
                                                sv.PhoneNumber ,
                                                tt.FK_AlertTypeID
                                      HAVING    COUNT(tt.PK_WarningID) > 0
                                    ) AS s PIVOT
		( COUNT(Total) FOR FK_AlertTypeID IN ( types3, types4, types5, types11 ) ) AS tblPivot
                            ORDER BY ( types3 + types4 + types5 + types11 ) DESC
                        END

            END

    END
