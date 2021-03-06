USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin.UserAssignManagerGetByUserIDType]    Script Date: 02/08/2017 16:21:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<hanhth>
-- Create date: <10-03-2015>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Admin.UserAssignManagerGetByUserIDType] 
    @UserID UNIQUEIDENTIFIER ,
    @IsAssign BIT
AS
    BEGIN        
        IF ( @IsAssign = 0 )
            BEGIN
                SELECT  PK_CompanyID ,
                        CompanyName ,
                        XNCode ,
						ParentCompanyID,
                        FK_ProvinceID
                FROM    dbo.[Company.Companies]
                WHERE   PK_CompanyID NOT IN (
                        SELECT  FK_CompanyID
                        FROM    dbo.[Admin.UserAssignManager]
                        WHERE   IsDeleted = 0 AND FK_UserID=@UserID ) AND CompanyType = 3 AND [Company.Companies].IsDeleted = 0
						ORDER BY XNCode ASC
            END
        ELSE
            BEGIN
                SELECT  PK_CompanyID ,
                        CompanyName ,
                        XNCode ,
						ParentCompanyID,
                        FK_ProvinceID
                FROM    dbo.[Company.Companies]
                WHERE   PK_CompanyID IN (
                        SELECT  FK_CompanyID
                        FROM    dbo.[Admin.UserAssignManager]
                        WHERE   IsDeleted = 0 AND FK_UserID=@UserID )  AND CompanyType = 3 AND [Company.Companies].IsDeleted = 0
						ORDER BY XNCode ASC
            END
    END

