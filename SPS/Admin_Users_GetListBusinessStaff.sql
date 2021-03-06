USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Users_GetListBusinessStaff]    Script Date: 02/08/2017 16:28:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<longtq>
-- Create date: <06/04/2015>
-- Description:	<lấy danh sách nhân viên kinh doanh>
-- =============================================
ALTER PROCEDURE [dbo].[Admin_Users_GetListBusinessStaff]
AS 
    BEGIN
        SELECT  PK_UserID ,
                FK_UserTypeID ,
                FK_CompanyID ,
                Username ,
                '' Password ,
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
                U.CreatedDate ,
                UpdatedByUser ,
                U.UpdatedDate ,
                UT.UserTypeName,
				DepartmentOfTransportID
        FROM    dbo.[Admin.Users] U
                INNER JOIN dbo.[Admin.UserTypes] UT ON U.FK_UserTypeID = UT.PK_UserTypeID
        WHERE   UT.[PK_UserTypeID] = 3 -- Nhân viên kinh doanh
                AND U.IsDeleted = 0
                AND U.IsLock = 0
        ORDER BY U.Username ASC
    END

-----------------------------------------------------------------------------------------------------------
