USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Companies_ListCompany_PartnerSearch]    Script Date: 04/08/2017 15:22:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		quochv
-- Create date: 19/09/2014
-- Description:	Lấy danh sách công ty của partner theo điều kiện tìm kiếm
-- =============================================
ALTER PROCEDURE [dbo].[Companies_ListCompany_PartnerSearch]
(
	@CompanyID			INT,
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
			SET @SortField = ' C.[XNCode]'
		END
	SET @SqlBase = N'
	WITH cteCompany  AS (
		SELECT ROW_NUMBER() OVER ( ORDER BY  ' +  @SortField + ') AS RowNumber
			,C.[PK_CompanyID] AS CompanyID
			,C.[ParentCompanyID]
			,C.[CompanyName]
			,C.[BrandName]
			,C.[CompanyType]
			,C.[Address]
			,C.[PhoneNumber]
			,C.[Fax]
			,C.[Email]
			,C.[Website]
			,C.[DateOfEstablishment]
			,C.[FK_ProvinceID]
			,C.[LogoImagePath]
			,ISNULL(C.[XNCode],0) AS XNCode
			,C.[ListOfXNForPartner]
			,C.[TaxCode]
			,C.[DeployState]
			,C.[BusinessType]
			,C.[Description]
			,C.[ContractCompanyName]
			,C.[ContractAddress]
			,C.[ContractTaxCode]
			,C.[ServerDatabase]
			,C.[FK_SalePersonID] AS SalePersonID
			,C.[SimServiceType]
			,C.[IsActiveFastTaxi]
			,C.[IsLocked]
			,C.[IsDeleted]
			,C.[Flags]
			,C.[ReasonOfLocked]
			,C.[ReasonOfDeleted]
			,C.[CreatedByUser]
			,C.[CreatedDate]
			,C.[UpdatedByUser]
			,C.[UpdatedDate]
			,P.DisplayName AS ProvinceName
			,U.UserName AS SalesmanName
		FROM ( SELECT   *  
					 FROM dbo.[Company.Companies]  
					 WHERE  ParentCompanyID = @CompanyID
					 UNION ALL  
					 SELECT  *  
					 FROM  [dbo].[Company.Companies] AS CC
					 WHERE    CC.ParentCompanyID IN   
					 ( SELECT PK_CompanyID  
					 FROM    dbo.[Company.Companies]  
						WHERE   ParentCompanyID = @CompanyID
						)
             ) C
		LEFT JOIN dbo.[GIS.Provinces] P
		ON C.FK_ProvinceID = P.PK_ProvinceID
		LEFT JOIN dbo.[Admin.Users] U
		ON C.FK_SalePersonID = U.PK_UserID
		WHERE 1 = 1 
	'
	IF(@SearchCondition != '')
	BEGIN 
		SET @SqlBase = @SqlBase + @SearchCondition
	END
	SET @SqlBase =@SqlBase + N') 
								SELECT * FROM cteCompany cte
								WHERE RowNumber BETWEEN @BeginRow AND @EndRow '
	PRINT @SqlBase						
	SET @parameter = N'	@CompanyID				INT,									
						@SearchCondition		NVARCHAR(MAX),
						@SortField				VARCHAR(MAX),
						@BeginRow				INT,
						@EndRow					INT'
																
	EXEC sp_executesql	@SqlBase, @parameter,		
						@CompanyID				=   @CompanyID,																			
						@SearchCondition		=	@SearchCondition,
						@SortField				=	@SortField,
						@BeginRow				=	@BeginRow,
						@EndRow					=	@EndRow
END
-----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON

