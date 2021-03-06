USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Users_GetListBAUser]    Script Date: 02/08/2017 16:28:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<hanhth>
-- Create date: <11/09/2014>
-- Description:	<lấy danh sách user>
-- =============================================
ALTER PROCEDURE [dbo].[Admin_Users_GetListBAUser]
AS
    BEGIN
        SELECT   PK_UserID ,
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
                au.CreatedDate ,
                UpdatedByUser ,
                au.UpdatedDate ,
				ut.UserTypeName,
				DepartmentOfTransportID
        FROM    dbo.[Admin.Users] au
                INNER JOIN dbo.[Admin.UserTypes] aut ON au.FK_UserTypeID = aut.PK_UserTypeID
				INNER JOIN dbo.[Admin.UserTypes] ut ON ut.PK_UserTypeID = au.FK_UserTypeID
        WHERE   aut.[Type] = 1 AND au.IsDeleted=0 AND au.IsLock=0
		ORDER BY au.Username ASC
    END


-----------------------------------------------------------------------------------------------------------
