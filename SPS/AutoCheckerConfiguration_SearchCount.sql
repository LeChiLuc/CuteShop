USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[AutoCheckerConfiguration_SearchCount]    Script Date: 02/08/2017 16:47:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		phongnc
-- Create date: 19/11/2014
-- Description:	Count cấu hình chốt cơ tự động
-- =============================================
ALTER PROCEDURE [dbo].[AutoCheckerConfiguration_SearchCount] --704
	@CompanyID INT,
	@GroupID INT
AS
	BEGIN
	IF(@GroupID > 0)
		BEGIN
			SELECT COUNT(1)
			FROM [dbo].[Config.AutoCheckerConfigurations] ac
			LEFT JOIN [Vehicle.VehicleGroups] vg ON ac.FK_VehicleID = vg.FK_VehicleID
			LEFT JOIN [Landmark.Landmarks] lm ON ac.FK_LandmarkID = lm.PK_LandmarkID
			WHERE ac.FK_CompanyID = @CompanyID
				AND vg.FK_VehicleGroupID = @GroupID
		END
	ELSE
		BEGIN
			SELECT COUNT(1)
			FROM [dbo].[Config.AutoCheckerConfigurations] ac
			LEFT JOIN [Landmark.Landmarks] lm ON ac.FK_LandmarkID = lm.PK_LandmarkID
			WHERE ac.FK_CompanyID = @CompanyID
		END
	END
