USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Companies_IsCompanyLockOrDeleteV2]    Script Date: 04/08/2017 15:22:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Companies_IsCompanyLockOrDeleteV2] @CompanyID INT
AS 
    BEGIN
        DECLARE @IsError INT; 
        SET @IsError = 0
        IF ( EXISTS ( SELECT    *
                      FROM      dbo.[Company.Companies]
                      WHERE     ( PK_CompanyID = @CompanyID )
                                AND ( IsLocked = 1) ) ) 
            BEGIN
                SET @IsError = 1   
            END
		IF ( EXISTS ( SELECT    *
                      FROM      dbo.[Company.Companies]
                      WHERE     ( PK_CompanyID = @CompanyID )
                                AND ( IsDeleted = 1) ) ) 
            BEGIN
                SET @IsError = 2
            END       
        SELECT  @IsError
    END	  
------------------------------------------------------------------------------------------------------------------------
