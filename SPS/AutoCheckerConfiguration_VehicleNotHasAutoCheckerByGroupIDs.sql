USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[AutoCheckerConfiguration_VehicleNotHasAutoCheckerByGroupIDs]    Script Date: 02/08/2017 16:47:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		phongnc
-- Create date: 19/11/2014
-- Description:	Search xe không cấu hình chốt cơ tự động
-- =============================================
ALTER PROCEDURE [dbo].[AutoCheckerConfiguration_VehicleNotHasAutoCheckerByGroupIDs] --704,'2597, 2598, 2599, 2600, 2602, 2603, 6541'
	@CompanyID INT,
	@GroupIDs VARCHAR(MAX)
AS
BEGIN
	IF(@GroupIDs != '')
		BEGIN
			SELECT 
				vv.PK_VehicleID,
				vv.VehiclePlate,
				vv.PrivateCode
			FROM [Vehicle.Vehicles] vv
			LEFT JOIN [Vehicle.VehicleGroups] vg ON vv.PK_VehicleID = vg.FK_VehicleID
			LEFT JOIN [Config.AutoCheckerConfigurations] ac ON vv.PK_VehicleID = ac.FK_VehicleID
			WHERE vv.FK_CompanyID = @CompanyID
				AND vg.FK_VehicleGroupID IN (SELECT tb.item FROM [dbo].fnSplit(@GroupIDs,', ') tb)
				AND ac.FK_VehicleID IS NULL
				AND ( vv.IsLocked IS NULL OR vv.IsLocked = 0 )
				AND ( vv.IsDeleted IS NULL OR vv.IsDeleted = 0 )
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
				AND ( vv.IsLocked IS NULL OR vv.IsLocked = 0 )
				AND ( vv.IsDeleted IS NULL OR vv.IsDeleted = 0 )
		END
END
