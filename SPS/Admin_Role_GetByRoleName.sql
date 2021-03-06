USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Role_GetByRoleName]    Script Date: 02/08/2017 16:25:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: trungtq
-- Create date: 11/08/2014
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[Admin_Role_GetByRoleName]-- ''
@RoleName NVARCHAR(100),
@CompanyId INT,
@TypeSearch INT
AS 
    BEGIN
		IF(@TypeSearch = 1)
		BEGIN
			SELECT 
			r.*,
			cu.Fullname CreatedByUserName,
			uu.Fullname UpdatedByUserName
			 FROM [Admin.Roles] r
			INNER JOIN [Admin.Users] cu ON r.CreatedByUser = cu.PK_UserID 
			LEFT JOIN [Admin.Users] uu ON r.UpdatedByUser = uu.PK_UserID 
			WHERE r.RoleName like '%' + @RoleName  + '%'
			AND (r.FK_CompanyID = @CompanyId OR @CompanyId = 0)
		END
		ELSE
		BEGIN
			SELECT 
			r.*,
			cu.Fullname CreatedByUserName,
			uu.Fullname UpdatedByUserName
			 FROM [Admin.Roles] r
			INNER JOIN [Admin.Users] cu ON r.CreatedByUser = cu.PK_UserID 
			LEFT JOIN [Admin.Users] uu ON r.UpdatedByUser = uu.PK_UserID 
			WHERE r.Description like '%' + @RoleName  + '%'
			AND (r.FK_CompanyID = @CompanyId OR @CompanyId = 0)
		END
    END 
------------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

