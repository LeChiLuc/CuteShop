USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin.UserVehiclesInterestedDelete]    Script Date: 02/08/2017 16:22:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<hanhth>
-- =============================================
ALTER PROCEDURE [dbo].[Admin.UserVehiclesInterestedDelete]
    @UserID UNIQUEIDENTIFIER ,
    @VehicleID BIGINT 
AS
    BEGIN
        DELETE FROM dbo.[Admin.UserVehiclesInterested] WHERE FK_UserID=@UserID AND FK_VehicleID=@VehicleID 
    END

