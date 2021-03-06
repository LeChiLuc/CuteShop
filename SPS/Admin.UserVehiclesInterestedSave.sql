USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin.UserVehiclesInterestedSave]    Script Date: 02/08/2017 16:22:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<hanhth>
-- =============================================
ALTER PROCEDURE [dbo].[Admin.UserVehiclesInterestedSave]
    @UserID UNIQUEIDENTIFIER ,
    @VehicleID BIGINT ,
    @CreatedBy UNIQUEIDENTIFIER ,
    @LevelID INT ,
    @Content NVARCHAR(MAX)
AS
    BEGIN
        IF NOT EXISTS ( SELECT  1
                        FROM    dbo.[Admin.UserVehiclesInterested]
                        WHERE   FK_UserID = @UserID
                                AND FK_VehicleID = @VehicleID )
            BEGIN
                INSERT  INTO dbo.[Admin.UserVehiclesInterested]
                        ( FK_UserID ,
                          FK_VehicleID ,
                          LevelID ,
                          Content ,
                          CreatedBy 
	                    )
                VALUES  ( @UserID ,
                          @VehicleID ,
                          @LevelID ,
                          @Content ,
                          @CreatedBy
	                    )
            END
    END

