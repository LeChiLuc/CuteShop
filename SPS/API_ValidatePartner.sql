USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[API_ValidatePartner]    Script Date: 02/08/2017 16:34:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: trungtq (longtq bê gps sang)
-- Create date: 26/10/2012
-- Description:	<Kiem tra xem partner co hop le ko?>
-- =============================================
ALTER PROCEDURE [dbo].[API_ValidatePartner] 
    @XNCode INT ,
    @Key VARCHAR(100) ,
    @Date DATETIME
AS 
    BEGIN
		DECLARE @trafficAccess INT 
		DECLARE @trafficValid INT
		DECLARE @IsExist BIT; 
		SET @trafficAccess = (SELECT COUNT(1) FROM dbo.[API.Logs] WHERE XNCode = @XNCode  AND DATEDIFF(DAY,@date,AccessDate) = 0)
        SET @trafficValid = (SELECT TOP 1 TrafficPerDay FROM dbo.[API.Licenses] WHERE XNCode  = @XNCode  )
        SET @IsExist = 0
        IF ( EXISTS ( SELECT    XNCode
                      FROM      dbo.[API.Licenses]
                      WHERE     XNCode = @XNCode
                                AND [Key] = @Key
                                AND ((EndDate IS NULL) OR (@Date BETWEEN StartDate AND EndDate ))
                                AND IsLocked = 0 ) ) 
            BEGIN
				--Neu so luong truy cap nho hon so luong cho phep.
				IF((@trafficAccess <@trafficValid ) OR @trafficAccess IS NULL)
                SET @IsExist = 1   
            END 
		SELECT @IsExist
    END	  
------------------------------------------------------------------------------------------------------------------------
    SET ANSI_NULLS ON