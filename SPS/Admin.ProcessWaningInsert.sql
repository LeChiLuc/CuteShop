USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin.ProcessWaningInsert]    Script Date: 02/08/2017 16:19:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Stored Procedure

ALTER PROC [dbo].[Admin.ProcessWaningInsert]
    @alertTypeID SMALLINT ,
    @warningID INT ,
    @vehicleID BIGINT ,
    @userID UNIQUEIDENTIFIER ,
    @types SMALLINT ,
    @note NVARCHAR(500) ,
    @expiredDate DATETIME
AS
    BEGIN
        INSERT  INTO dbo.[Admin.ProcessVehiclesNotify]
                ( FK_AlertTypeID ,
                  FK_WarningID ,
                  FK_VehicleID ,
                  Note ,
                  FK_UserID ,
                  Types ,
                  ExpiredDate 
	            )
        VALUES  ( @alertTypeID , -- FK_AlertTypeID - int
                  @warningID ,
                  @vehicleID , -- FK_VehicleID - bigint
                  @note , -- Note - nvarchar(500)
                  @userID , -- FK_UserID - uniqueidentifier
                  @types , -- Types - smallint
                  @expiredDate  -- ExpiredDate - datetime
	            )
    END
