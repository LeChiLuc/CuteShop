USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[ApprovedLastPMDetailByVehicleID]    Script Date: 02/08/2017 16:39:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: trungtq
-- Create date: 19/08/2014
-- Description: Chốt bảo dưỡng lần cuối
-- =============================================
ALTER PROCEDURE [dbo].[ApprovedLastPMDetailByVehicleID]
	@FK_VehicleID BIGINT
AS 
    BEGIN
    SET NOCOUNT ON
	BEGIN TRY
		INSERT INTO dbo.[Maintenance.LastPMDetails]
		        ( FK_ServiceID ,
		          FK_VehicleID ,
		          FK_CompanyID ,
		          LastPerformedDate ,
		          LastPerformedKm ,
		          IsActived ,
		          CreatedByUser ,
		          CreatedDate 
		        )
		SELECT 
			PS.PK_ServiceID AS FK_ServiceID,
			PV.FK_VehicleID,
			PV.FK_CompanyID,
			VP.LastPerformedDate,
			VP.LastPerformedKm,
			1 AS IsActived,
			'E66E300E-B644-41B0-8124-CE9954434C6F' AS CreatedByUser,
			GETDATE() AS CreatedDate
		FROM [dbo].[Maintenance.PMSchedules] AS S INNER JOIN dbo.[Maintenance.PMScheduleVehicles] AS PV 
		ON S.PK_ScheduleID = PV.FK_ScheduleID
		INNER JOIN dbo.[Maintenance.PMServices] AS PS 
		ON S.PK_ScheduleID = PS.FK_ScheduleID
		INNER JOIN [dbo].[Maintenance.VehicleLastPMDetails] AS VP
		ON PV.FK_VehicleID = VP.FK_VehicleID
		WHERE S.IsDeleted = 0
		AND PV.FK_VehicleID = @FK_VehicleID
	END TRY
		BEGIN CATCH
			DECLARE @description NVARCHAR(250);
			SELECT  @description = ERROR_MESSAGE();
				
			-- Log lai
			EXEC dbo.SynTriggerLog_InsertSynTriggerLog 
				@ActionName = '[dbo].[ApprovedLastPMDetailByVehicleID',
				@Value = '', 
				@Result = 'Error', 
				@Description = @description           
		END CATCH       
    END 
------------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

