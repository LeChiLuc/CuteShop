USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[AutoCheckerConfiguration_VehicleNotHasAutoChecker]    Script Date: 02/08/2017 16:47:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		phongnc
-- Create date: 19/11/2014
-- Description:	Search xe không cấu hình chốt cơ tự động
-- =============================================
ALTER PROCEDURE [dbo].[AutoCheckerConfiguration_VehicleNotHasAutoChecker] --704,0
	@CompanyID INT,
	@GroupID INT
AS
BEGIN
	IF(@GroupID > 0)
		BEGIN
			SELECT 
				vv.PK_VehicleID,
				vv.VehiclePlate,
				vv.PrivateCode
			FROM [Vehicle.Vehicles] vv
			LEFT JOIN [Vehicle.VehicleGroups] vg ON vv.PK_VehicleID = vg.FK_VehicleID
			LEFT JOIN [Config.AutoCheckerConfigurations] ac ON vv.PK_VehicleID = ac.FK_VehicleID
			WHERE vv.FK_CompanyID = @CompanyID
				AND vg.FK_VehicleGroupID = @GroupID
				AND ac.FK_VehicleID IS NULL
		END
	ELSE
		BEGIN
			SELECT 
				vv.PK_VehicleID,
				vv.VehiclePlate,
				vv.PrivateCode
			FROM [Vehicle.Vehicles] vv
			LEFT JOIN [Config.AutoCheckerConfigurations] ac ON vv.PK_VehicleID = ac.FK_VehicleID
			WHERE vv.FK_CompanyID = @CompanyID
				AND ac.FK_VehicleID IS NULL
		END
END
