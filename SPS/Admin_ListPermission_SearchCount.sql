USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin_ListPermission_SearchCount]    Script Date: 02/08/2017 16:23:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quochv
-- Create date: 17/09/2014
-- Description:	Đếm danh sách công ty theo điều kiện tìm kiếm
-- =============================================
ALTER PROCEDURE [dbo].[Admin_ListPermission_SearchCount]
	@SearchCondition	NVARCHAR(MAX)
	
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @SqlBase NVARCHAR(Max)
	DECLARE @parameter NVARCHAR(Max)
	SET @SqlBase =N'
					SELECT COUNT([PK_PermissionID])
					FROM ( 
						SELECT P.[PK_PermissionID]
						FROM [dbo].[Admin.Permissions] P
						INNER JOIN [dbo].[Admin.UserPersmissions] UP
						ON P.PK_PermissionID = UP.FK_PermissionID
						LEFT JOIN [dbo].[Admin.Users] U
						ON U.PK_UserID = UP.FK_UserID
						LEFT JOIN dbo.[Company.Companies] CC
						ON U.FK_CompanyID = CC.PK_CompanyID
						WHERE 1 = 1 '
	IF(@SearchCondition != '')
	BEGIN 
		SET @SqlBase = @SqlBase + @SearchCondition
	END
    SET @SqlBase = @SqlBase + ' GROUP BY P.PK_PermissionID, P.PermissionName ) AS P '    
		SET @parameter =	N'	 	
							@SearchCondition		NVARCHAR(MAX)						
							'		
	
		EXEC sp_executesql @SqlBase,
			 @parameter,
			 @SearchCondition		=	@SearchCondition
END

------------------------------------------------------------------------------------
SET ANSI_NULLS ON

