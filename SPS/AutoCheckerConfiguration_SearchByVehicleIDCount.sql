USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[AutoCheckerConfiguration_SearchByVehicleIDCount]    Script Date: 02/08/2017 16:47:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		phongnc
-- Create date: 25/02/2015
-- Description:	Count cấu hình chốt cơ tự động theo id xe
-- =============================================
ALTER PROCEDURE [dbo].[AutoCheckerConfiguration_SearchByVehicleIDCount] --704,0
	@CompanyID INT,
	@VehicleIDs VARCHAR(MAX)
AS
	BEGIN
			SELECT COUNT(1)
			FROM [dbo].[Config.AutoCheckerConfigurations] ac
			LEFT JOIN [Vehicle.VehicleGroups] vg ON ac.FK_VehicleID = vg.FK_VehicleID
			LEFT JOIN [Landmark.Landmarks] lm ON ac.FK_LandmarkID = lm.PK_LandmarkID
			WHERE ac.FK_CompanyID = @CompanyID
			AND ac.[FK_VehicleID] IN ( SELECT tbe.item FROM dbo.fnSplit(@VehicleIDs, ',') tbe )
	END
