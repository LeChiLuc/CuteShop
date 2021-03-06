USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Companies_ListCompany_GetCompanyAssign]    Script Date: 04/08/2017 15:22:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[Companies_ListCompany_GetCompanyAssign]
@isShow BIT,
@Accounting UNIQUEIDENTIFIER
AS
BEGIN
	IF(@isShow=1)
	BEGIN
		SELECT  PK_CompanyID AS CompanyID ,
		        ParentCompanyID ,
		        CompanyName ,
		        BrandName ,
		        CompanyType ,
		        Address ,
		        PhoneNumber ,
		        Fax ,
		        Email ,
		        Website ,
		        DateOfEstablishment ,
		        FK_ProvinceID AS ProvinceID ,
		        LogoImagePath ,
		        XNCode ,
		        ListOfXNForPartner ,
		        TaxCode ,
		        DeployState ,
		        BusinessType ,
		        Description ,
		        ContractCompanyName ,
		        ContractAddress ,
		        ContractTaxCode ,
		        ServerDatabase ,
		        FK_SalePersonID AS SalePersonID ,
		        SimServiceType ,
		        IsUsingTaxiOperation ,
		        IsActiveFastTaxi ,
		        IsLocked ,
		        IsDeleted ,
		        Flags ,
		        ReasonOfLocked ,
		        ReasonOfDeleted ,
		        CodeAccounting ,
		        KCSChecked ,
		        DateKCSChecked ,
		        UserKCSChecked ,
		        CreatedByUser ,
		        CreatedDate ,
		        UpdatedByUser ,
		        UpdatedDate FROM dbo.[Company.Companies] WHERE CompanyType=2
	END
	ELSE
	BEGIN
		SELECT  PK_CompanyID  AS CompanyID,
		        ParentCompanyID ,
		        CompanyName ,
		        BrandName ,
		        CompanyType ,
		        Address ,
		        PhoneNumber ,
		        Fax ,
		        Email ,
		        Website ,
		        DateOfEstablishment ,
		        FK_ProvinceID  AS ProvinceID,
		        LogoImagePath ,
		        XNCode ,
		        ListOfXNForPartner ,
		        TaxCode ,
		        DeployState ,
		        BusinessType ,
		        Description ,
		        ContractCompanyName ,
		        ContractAddress ,
		        ContractTaxCode ,
		        ServerDatabase ,
		        FK_SalePersonID AS SalePersonID ,
		        SimServiceType ,
		        IsUsingTaxiOperation ,
		        IsActiveFastTaxi ,
		        IsLocked ,
		        IsDeleted ,
		        Flags ,
		        ReasonOfLocked ,
		        ReasonOfDeleted ,
		        CodeAccounting ,
		        KCSChecked ,
		        DateKCSChecked ,
		        UserKCSChecked ,
		        CreatedByUser ,
		        CreatedDate ,
		        UpdatedByUser ,
		        UpdatedDate FROM dbo.[Company.Companies]
		WHERE CompanyType=2 AND FK_SalePersonID IN ( SELECT  StaffID FROM    dbo.[Admin.BusinessStaffAssignment]  WHERE   AccountingID = @Accounting)
	END
END
