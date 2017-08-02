USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin.UserAssignManagerGetByMultiCondition]    Script Date: 02/08/2017 16:20:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<hanhth>
-- Create date: <10-03-2015>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Admin.UserAssignManagerGetByMultiCondition] @Query NVARCHAR(MAX)
AS
    BEGIN        
        DECLARE @sql NVARCHAR(MAX)
        SET @sql = '
	                SELECT  PK_CompanyID ,
                        CompanyName ,
                        XNCode ,
						ParentCompanyID,
                        FK_ProvinceID
                FROM    dbo.[Company.Companies]
                WHERE   (1=1) AND ' + @Query
        EXEC(@sql)
            
    END

