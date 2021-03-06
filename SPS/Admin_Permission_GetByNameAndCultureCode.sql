USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Permission_GetByNameAndCultureCode]    Script Date: 02/08/2017 16:24:47 ******/
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
ALTER PROCEDURE [dbo].[Admin_Permission_GetByNameAndCultureCode]-- '','vi' -- ''
@PermissionName NVARCHAR(100),
@Culture		CHAR(5)
AS 
    BEGIN
		SELECT 
		ISNULL(mil.Culture, @Culture) Culture,
		pl.Culture PCulture,
		pl.PK_PermissionLanguageID,
		ISNULL(mil.DisplayName , me.Name) MenuItemDisplayName ,
		pe.PermissionName,
		pe.PK_PermissionID PermissionID,
		pl.DisplayName PermissionDisplayName ,
		
		pl.CreatedDate PerCreatedDate,
		pl.CreatedUser PerCreatedUser,
		cu.Fullname PerCreatedUserName,
		
		pl.UpdatedDate PerUpdatedDate,
		pl.UpdatedUser PerUpdatedUser,
		uu.Fullname PerUpdatedUserName
		
		
		FROM [Admin.Permissions] pe 
		INNER JOIN [Admin.MenuItems] me ON pe.FK_MenuItemID = me.PK_MenuItemID 
		LEFT JOIN(select * from [Admin.MenuItemLocates] where Culture = @Culture  )mil ON 
		me.PK_MenuItemID = mil.FK_MenuItemID
		LEFT JOIN(select * from [Admin.PermissionLocates] where Culture = @Culture )pl ON pe.PK_PermissionID = pl.FK_PermissionID
		LEFT JOIN [Admin.Users] cu ON pl.CreatedUser = cu.PK_UserID
		LEFT JOIN [Admin.Users] uu ON pl.UpdatedUser = uu.PK_UserID
		WHERE 
		((pe.PermissionName like '%' + @PermissionName + '%') 
		OR ( pl.DisplayName  like '%' + @PermissionName + '%'))
    END 
------------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

