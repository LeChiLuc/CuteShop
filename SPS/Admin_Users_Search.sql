USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Users_Search]    Script Date: 02/08/2017 16:29:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<longtq>
-- Create date: <11/09/2014>
-- Description:	<lấy danh sách user>
-- =============================================
ALTER PROCEDURE [dbo].[Admin_Users_Search] 
    @FK_CompanyID INT =0,
    @FK_UserTypeID INT =0,
    @Username NVARCHAR(50) ='' ,
    @Fullname NVARCHAR(100) ='',
    @Email NVARCHAR(50) ='',
    @PhoneNumber VARCHAR(50)=''
AS 
    BEGIN
        SELECT  PK_UserID ,
                FK_UserTypeID ,
                FK_CompanyID CompanyId,
                Username ,
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
                PK_UserTypeID UserType ,
                Type ,
                UserTypeName ,
                Description ,
                UT.CreatedDate ,
                UT.UpdatedDate,
				ISNULL('- '+[dbo].[Function_GetRoleName] (PK_UserID),'') Roles,
				DepartmentOfTransportID,
				BP.DisplayName
        FROM    dbo.[Admin.Users] AS U INNER JOIN dbo.[Admin.UserTypes] AS UT ON U.FK_UserTypeID = UT.PK_UserTypeID
				LEFT JOIN [dbo].[BGT.Provinces] AS BP ON U.DepartmentOfTransportID = BP.PK_ProvinceID      
WHERE ((@FK_CompanyID>0 AND FK_CompanyID=@FK_CompanyID) OR @FK_CompanyID=0)
AND ((@FK_UserTypeID>0 AND FK_UserTypeID=@FK_UserTypeID) OR @FK_UserTypeID=0)
AND ((@Username!='' AND Username LIKE '%'+@Username+'%') OR @Username='')
AND ((@Fullname!='' AND Fullname LIKE '%'+@Fullname+'%') OR @Fullname='')  
AND ((@Email!='' AND Email LIKE '%'+@Email+'%') OR @Email='')
AND ((@PhoneNumber!='' AND PhoneNumber LIKE '%'+@PhoneNumber+'%') OR @PhoneNumber='')
AND IsDeleted <> 1
ORDER BY Username 
END

-----------------------------------------------------------------------------------------------------------
