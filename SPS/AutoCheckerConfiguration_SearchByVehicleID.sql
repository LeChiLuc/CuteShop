USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[AutoCheckerConfiguration_SearchByVehicleID]    Script Date: 02/08/2017 16:46:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		phongnc
-- Create date: 25/02/2015
-- Description:	Search cấu hình chốt cơ tự động thoe id xe
-- =============================================
ALTER PROCEDURE [dbo].[AutoCheckerConfiguration_SearchByVehicleID] --704,0
	@CompanyID INT,
	@VehicleIDs VARCHAR(MAX),
	@PageIndex INT,
	@PageSize INT
AS
	BEGIN
		DECLARE @BeginRow INT = 0
		DECLARE @EndRow INT = 0
		SET @BeginRow = (@PageIndex * @PageSize) - (@PageSize - 1)
		SET @EndRow = (@PageIndex * @PageSize)
		SELECT * FROM (
			SELECT 
				(ROW_NUMBER() OVER (ORDER BY CASE WHEN (isnumeric(VV.PrivateCode) = 1) THEN convert(FLOAT,VV.PrivateCode) ELSE 10000 END ASC)) AS [Index]
				,ac.[FK_VehicleID] AS VehicleID
				,vv.PrivateCode
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
			AND ac.[FK_VehicleID] IN ( SELECT tbe.item FROM dbo.fnSplit(@VehicleIDs, ',') tbe )
			) AS Result
		WHERE Result.[Index] >= @BeginRow AND Result.[Index] <= @EndRow
	END
