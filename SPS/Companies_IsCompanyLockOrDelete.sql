USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Companies_IsCompanyLockOrDelete]    Script Date: 04/08/2017 15:22:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Companies_IsCompanyLockOrDelete] @CompanyID INT
AS 
    BEGIN
        DECLARE @IsCompanyLockOrDelete BIT; 
        SET @IsCompanyLockOrDelete = 0
        IF ( EXISTS ( SELECT    *
                      FROM      dbo.[Company.Companies]
                      WHERE     ( PK_CompanyID = @CompanyID )
                                AND ( IsDeleted = 1) ) ) 
            BEGIN
                SET @IsCompanyLockOrDelete = 1   
            END 
        SELECT  @IsCompanyLockOrDelete
    END	  
------------------------------------------------------------------------------------------------------------------------
