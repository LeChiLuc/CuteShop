USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Users_GetListUserAssignAccounting]    Script Date: 02/08/2017 16:28:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[Admin_Users_GetListUserAssignAccounting]
@isShowAll BIT,
@Accounting UNIQUEIDENTIFIER
AS 
BEGIN
	IF(@isShowAll=1)
	BEGIN
		SELECT  PK_UserID ,
		        FK_UserTypeID ,
		        FK_CompanyID ,
		        Username ,
		        Password ,
		        Fullname ,
		        LockLevel ,
		        PhoneNumber ,
		        Email ,
		        Avatar ,
		        LastPasswordChanged ,
		        ChangePasswordAfterDays ,
		        LastLoginDate ,
		        IsLock ,
		        IsDeleted ,
		        CreatedByUser ,
		        CreatedDate ,
		        UpdatedByUser ,
		        UpdatedDate ,
				DepartmentOfTransportID
		FROM dbo.[Admin.Users]
		WHERE FK_UserTypeID =3 AND IsDeleted = 0
	END
	ELSE
	BEGIN
		SELECT  PK_UserID ,
		        FK_UserTypeID ,
		        FK_CompanyID ,
		        Username ,
		        Password ,
		        Fullname ,
		        LockLevel ,
		        PhoneNumber ,
		        Email ,
		        Avatar ,
		        LastPasswordChanged ,
		        ChangePasswordAfterDays ,
		        LastLoginDate ,
		        IsLock ,
		        IsDeleted ,
		        CreatedByUser ,
		        CreatedDate ,
		        UpdatedByUser ,
		        UpdatedDate FROM dbo.[Admin.Users]
		WHERE FK_UserTypeID =3 AND IsDeleted = 0 AND PK_UserID IN ( SELECT  StaffID FROM    dbo.[Admin.BusinessStaffAssignment]  WHERE   AccountingID = @Accounting)	
	END
END

-----------------------------------------------------------------------------------------------------------
