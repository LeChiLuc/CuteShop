USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Permission_GetByDisplayNameAndPermissionId]    Script Date: 02/08/2017 16:24:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: trungtq
-- Create date: 11/08/2014
-- Description:	
-- =============================================

--      [Admin_Permission_GetByNameAndCultureCode]'111','fr' 
ALTER PROCEDURE [dbo].[Admin_Permission_GetByDisplayNameAndPermissionId]-- '','vi' -- ''
@PermissionName NVARCHAR(100),
@PermissionId	INT
AS 
    BEGIN
		SELECT 
		mil.Culture,
		pl.Culture PCulture,
		pl.PK_PermissionLanguageID,
		ISNULL(mil.DisplayName , me.Name) MenuItemDisplayName ,
		pe.PermissionName,
		pe.PK_PermissionID PermissionID,
		pl.DisplayName PermissionDisplayName
		
		
		FROM [Admin.Permissions] pe 
		INNER JOIN [Admin.MenuItems] me ON pe.FK_MenuItemID = me.PK_MenuItemID 
		LEFT JOIN [Admin.MenuItemLocates] mil ON 
		me.PK_MenuItemID = mil.FK_MenuItemID
		LEFT JOIN [Admin.PermissionLocates] pl ON pe.PK_PermissionID = pl.FK_PermissionID
		WHERE 
		pl.DisplayName  like '%' + @PermissionName + '%'
		AND pe.PK_PermissionID = @PermissionId
    END 
------------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

