USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin_ListUserPermission_Search]    Script Date: 02/08/2017 16:23:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quochv
-- Create date: 17/09/2014
-- Description:	Lấy danh sách công ty theo điều kiện tìm kiếm
-- =============================================
ALTER PROCEDURE [dbo].[Admin_ListUserPermission_Search]
(
	@SearchCondition	NVARCHAR(MAX),
	@SortField			NVARCHAR(MAX),
	@PageIndex			INT,
	@PageSize			INT
)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @BeginRow INT = 0
	DECLARE @EndRow INT = 0
	SET @BeginRow = (@PageIndex * @PageSize) - (@PageSize - 1)
	SET @EndRow = (@PageIndex * @PageSize)
	DECLARE @SqlBase NVARCHAR(Max)
	DECLARE @parameter NVARCHAR(Max)
	IF(@SortField = '')
		BEGIN
			SET @SortField = ' CC.XNCode'
		END
	SET @SqlBase = N'
	WITH ctePermission  AS (
		SELECT ROW_NUMBER() OVER ( ORDER BY  ' +  @SortField + ') AS RowNumber
			,P.[PK_PermissionID] AS PermissionID
			,P.[PermissionName]
			,U.Username
			,CC.CompanyName
			,CC.CompanyType
			,CC.ListOfXNForPartner
			,CC.XNCode
			,UP.CreatedByUser AS AssignedByUser
			,UP.CreatedDate AS AssignedDate
			,UU.UserName AS AssignedByUserName
		  FROM [dbo].[Admin.Permissions] P
		  LEFT JOIN [dbo].[Admin.UserPersmissions] UP
		  ON P.PK_PermissionID = UP.FK_PermissionID
		  LEFT JOIN [dbo].[Admin.Users] U
		  ON U.PK_UserID = UP.FK_UserID
		  LEFT JOIN dbo.[Company.Companies] CC
		  ON U.FK_CompanyID = CC.PK_CompanyID
		  LEFT JOIN [dbo].[Admin.Users] UU
		  ON UU.PK_UserID = UP.CreatedByUser
		  WHERE 1 = 1 	'
	IF(@SearchCondition != '')
	BEGIN 
		SET @SqlBase = @SqlBase + @SearchCondition
	END
	SET @SqlBase =@SqlBase + N') 
								SELECT * FROM ctePermission cte
								WHERE RowNumber BETWEEN @BeginRow AND @EndRow '
	PRINT @SqlBase						
	SET @parameter = N'												
						@SearchCondition		NVARCHAR(MAX),
						@SortField				VARCHAR(MAX),
						@BeginRow				INT,
						@EndRow					INT'
																
	EXEC sp_executesql	@SqlBase, @parameter																						
						,@SearchCondition		=	@SearchCondition,
						@SortField				=	@SortField,
						@BeginRow				=	@BeginRow,
						@EndRow					=	@EndRow
END
-----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON

