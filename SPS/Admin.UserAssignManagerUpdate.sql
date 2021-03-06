USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin.UserAssignManagerUpdate]    Script Date: 02/08/2017 16:22:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Admin.UserAssignManagerUpdate]
    @UserID UNIQUEIDENTIFIER ,
    @CompanyID INT ,
    @IsAssign BIT,
	@CreatedBy UNIQUEIDENTIFIER
AS
    BEGIN
        IF ( @IsAssign = 0 )
            BEGIN
                DELETE  FROM dbo.[Admin.UserAssignManager]
                WHERE   FK_CompanyID = @CompanyID
                        AND FK_UserID = @UserID
            END
        ELSE
            BEGIN
                IF NOT EXISTS ( SELECT  FK_CompanyID
                                FROM    dbo.[Admin.UserAssignManager]
                                WHERE   FK_CompanyID = @CompanyID
                                        AND FK_UserID = @UserID )
                    BEGIN
                        INSERT  INTO dbo.[Admin.UserAssignManager]
                                ( FK_CompanyID, FK_UserID,CreatedBy )
                        VALUES  ( @CompanyID, @UserID,@CreatedBy )
                    END
            END
    END

