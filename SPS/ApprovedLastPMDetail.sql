USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[ApprovedLastPMDetail]    Script Date: 02/08/2017 16:39:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: trungtq
-- Create date: 19/08/2014
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[ApprovedLastPMDetail]
AS 
    BEGIN
    SET NOCOUNT ON
	BEGIN TRY
        DECLARE @FK_VehicleID BIGINT;
		DECLARE @CompanyID INT;
		SET @CompanyID = (SELECT TOP 1 PK_CompanyID FROM dbo.[Company.Companies] WHERE XNCode = 9093)

        DECLARE AccumulateCursor CURSOR
        FOR
            SELECT  PK_VehicleID
            FROM    [dbo].[Vehicle.Vehicles]
            WHERE FK_CompanyID = @CompanyID AND IsDeleted = 0 AND IsLocked = 0
        OPEN AccumulateCursor
        FETCH NEXT FROM AccumulateCursor INTO @FK_VehicleID
        WHILE ( @@FETCH_STATUS = 0 ) 
            BEGIN 
			-- Cập nhật ở đây.
                EXEC [dbo].[ApprovedLastPMDetailByVehicleID] @FK_VehicleID = @FK_VehicleID -- int
                
                FETCH NEXT FROM AccumulateCursor INTO @FK_VehicleID
            END 
        CLOSE AccumulateCursor
        DEALLOCATE AccumulateCursor
		END TRY
		BEGIN CATCH
			DECLARE @description NVARCHAR(250);
			SELECT  @description = ERROR_MESSAGE();
				
			-- Log lai
			EXEC dbo.SynTriggerLog_InsertSynTriggerLog 
				@ActionName = '[dbo].[ApprovedLastPMDetail]',
				@Value = '', 
				@Result = 'Error', 
				@Description = @description           
		END CATCH       
    END 
------------------------------------------------------------------------------------------------------------------------

