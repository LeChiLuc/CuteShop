USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Users_Search_New]    Script Date: 02/08/2017 16:29:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<longtq>
-- Create date: <11/09/2014>
-- Description:	<lấy danh sách user>
-- =============================================
ALTER PROCEDURE [dbo].[Admin_Users_Search_New]
-- [dbo].[Admin_Users_Search_New] 1410,0,'','','','','557b9d49-5e3a-43c0-befa-109975e36cff',1
    @FK_CompanyID INT = 0 ,
    @FK_UserTypeID INT = 0 ,
    @Username NVARCHAR(50) = '' ,
    @Fullname NVARCHAR(100) = '' ,
    @Email NVARCHAR(50) = '' ,
    @PhoneNumber VARCHAR(50) = '' ,
    @CurrentUser UNIQUEIDENTIFIER ,
    @IsSupper BIT ,-- là người dùng pro có thể lấy cả danh sách user,
	@FindDeleted BIT = 0
AS -- Nếu không sử dụng chức năng Chia công ty thành nhiều nhóm 

	DECLARE @companyType TINYINT
	SELECT @companyType = CompanyType FROM dbo.[Company.Companies] WHERE PK_CompanyID = @FK_CompanyID  

    IF NOT EXISTS ( SELECT  1
                    FROM    [dbo].[Config.CompanyConfigurations]
                    WHERE   FK_CompanyID = @FK_CompanyID
                            AND Name = 'EnableGroupInCompany' ) 
        BEGIN
            SELECT  PK_UserID ,
                    FK_UserTypeID ,
                    FK_CompanyID CompanyId ,
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
                    UT.UpdatedDate ,
                    ISNULL('- ' + [dbo].[Function_GetRoleName](PK_UserID), '') Roles
            FROM    dbo.[Admin.Users] AS U
                    INNER JOIN dbo.[Admin.UserTypes] AS UT ON U.FK_UserTypeID = UT.PK_UserTypeID
            WHERE   ( ( @FK_CompanyID > 0
                        AND FK_CompanyID = @FK_CompanyID
                      )
                      OR (@companyType = 1 AND FK_CompanyID = 0) 
                    )
                    AND ( ( @FK_UserTypeID > 0
                            AND FK_UserTypeID = @FK_UserTypeID
                          )
                          OR @FK_UserTypeID = 0
                        )
                    AND ( ( @Username != ''
                            AND Username LIKE '%' + @Username + '%'
                          )
                          OR @Username = ''
                        )
                    AND ( ( @Fullname != ''
                            AND Fullname LIKE '%' + @Fullname + '%'
                          )
                          OR @Fullname = ''
                        )
                    AND ( ( @Email != ''
                            AND Email LIKE '%' + @Email + '%'
                          )
                          OR @Email = ''
                        )
                    AND ( ( @PhoneNumber != ''
                            AND PhoneNumber LIKE '%' + @PhoneNumber + '%'
                          )
                          OR @PhoneNumber = ''
                        )
                    --AND IsDeleted <> 1
					AND IsDeleted = @FindDeleted
            ORDER BY Username 
        END
    ELSE -- Nếu sử dụng chức năng Chia công ty thành nhiều nhóm 
        BEGIN
            SELECT  PK_UserID ,
                    FK_UserTypeID ,
                    FK_CompanyID CompanyId ,
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
                    UT.Description ,
                    UT.CreatedDate ,
                    UT.UpdatedDate ,
                    ISNULL('- ' + [dbo].[Function_GetRoleName](PK_UserID), '') Roles
            FROM    dbo.[Admin.Users] AS U
                    INNER JOIN dbo.[Admin.UserTypes] AS UT ON U.FK_UserTypeID = UT.PK_UserTypeID
            WHERE   ( ( @FK_CompanyID > 0
                        AND FK_CompanyID = @FK_CompanyID
                      )
                      OR (@companyType = 1 AND FK_CompanyID = 0) 
                    )
                    AND ( ( @FK_UserTypeID > 0
                            AND FK_UserTypeID = @FK_UserTypeID
                          )
                          OR @FK_UserTypeID = 0
                        )
                    AND ( ( @Username != ''
                            AND Username LIKE '%' + @Username + '%'
                          )
                          OR @Username = ''
                        )
                    AND ( ( @Fullname != ''
                            AND Fullname LIKE '%' + @Fullname + '%'
                          )
                          OR @Fullname = ''
                        )
                    AND ( ( @Email != ''
                            AND Email LIKE '%' + @Email + '%'
                          )
                          OR @Email = ''
                        )
                    AND ( ( @PhoneNumber != ''
                            AND PhoneNumber LIKE '%' + @PhoneNumber + '%'
                          )
                          OR @PhoneNumber = ''
                        )
                    --AND IsDeleted <> 1
					AND IsDeleted = @FindDeleted
            ORDER BY Username 
        END

