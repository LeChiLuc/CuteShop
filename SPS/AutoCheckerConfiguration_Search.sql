USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[AutoCheckerConfiguration_Search]    Script Date: 02/08/2017 16:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		phongnc
-- Create date: 19/11/2014
-- Description:	Search cấu hình chốt cơ tự động
-- =============================================
ALTER PROCEDURE [dbo].[AutoCheckerConfiguration_Search] --704,0
	@CompanyID INT,
	@GroupID INT
AS
	BEGIN
	IF(@GroupID > 0)
		BEGIN
			SELECT 
				ac.[FK_VehicleID] AS VehicleID
				,vv.VehiclePlate AS Plate
			  ,ac.[FK_CompanyID] AS CompanyID
			  ,[TimeRange]
			  ,[IsAutoCheckByTime]
			  ,ac.[FK_LandmarkID] AS LandmarkID
			  ,[IsAutoCheckerByPosition]
			  ,[IsActive]
			  ,[MinutesTryAgain]
			  ,[NumbersTryAgain]
			  ,ac.[CreatedDate]
			  ,ac.[CreatedByUser]
			  ,au.Username As CreatedByUserName
			  ,ac.[UpdatedByUser]
			  ,au1.Username AS UpdatedByUserName
			  ,ac.[UpdatedDate]
			  ,[LastTimeChecker]
			  ,lm.Name AS LanmarkName
			FROM [dbo].[Config.AutoCheckerConfigurations] ac
			LEFT JOIN [Vehicle.VehicleGroups] vg ON ac.FK_VehicleID = vg.FK_VehicleID
			LEFT JOIN [Vehicle.Vehicles] vv ON ac.FK_VehicleID = vv.PK_VehicleID
			LEFT JOIN [Landmark.Landmarks] lm ON ac.FK_LandmarkID = lm.PK_LandmarkID
			LEFT JOIN [Admin.Users] au ON ac.CreatedByUser = au.PK_UserID
			LEFT JOIN [Admin.Users] au1 ON ac.UpdatedByUser = au1.PK_UserID
			WHERE ac.FK_CompanyID = @CompanyID
				AND vg.FK_VehicleGroupID = @GroupID
		END
	ELSE
		BEGIN
			SELECT 
				ac.[FK_VehicleID] AS VehicleID
				,vv.VehiclePlate AS Plate
			  ,ac.[FK_CompanyID] AS CompanyID
			  ,[TimeRange]
			  ,[IsAutoCheckByTime]
			  ,ac.[FK_LandmarkID] AS LandmarkID
			  ,[IsAutoCheckerByPosition]
			  ,[IsActive]
			  ,[MinutesTryAgain]
			  ,[NumbersTryAgain]
			  ,ac.[CreatedDate]
			  ,ac.[CreatedByUser]
			  ,au.Username As CreatedByUserName
			  ,ac.[UpdatedByUser]
			  ,au1.Username AS UpdatedByUserName
			  ,ac.[UpdatedDate]
			  ,[LastTimeChecker]
			  ,lm.Name AS LanmarkName
			FROM [dbo].[Config.AutoCheckerConfigurations] ac
			LEFT JOIN [Landmark.Landmarks] lm ON ac.FK_LandmarkID = lm.PK_LandmarkID
			LEFT JOIN [Vehicle.Vehicles] vv ON ac.FK_VehicleID = vv.PK_VehicleID
			LEFT JOIN [Admin.Users] au ON ac.CreatedByUser = au.PK_UserID
			LEFT JOIN [Admin.Users] au1 ON ac.UpdatedByUser = au1.PK_UserID
			WHERE ac.FK_CompanyID = @CompanyID
		END
	END
