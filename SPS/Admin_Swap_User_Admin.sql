USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Swap_User_Admin]    Script Date: 02/08/2017 16:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<trungtq>
-- Create date: <03/06/2015>
-- Description:	<Swap người dùng quản trị>
-- =============================================
ALTER PROCEDURE [dbo].[Admin_Swap_User_Admin]
	@AdminOld UNIQUEIDENTIFIER,
	@AdminNew UNIQUEIDENTIFIER
AS 
BEGIN	
BEGIN TRY
	BEGIN TRANSACTION
    IF (@adminOld <> @adminNew) 
		BEGIN
		-- Select t?p quy?n, t?p vai trò c?a qu?n tr? c? vào b?ng t?m      
		 SELECT  * INTO #tmpUserPersmissions FROM [dbo].[Admin.UserPersmissions] WHERE FK_UserID = @adminOld
		 SELECT * INTO #tmpUserRoles FROM [dbo].[Admin.UserRoles] WHERE FK_UserID =@adminOld

		 -- Xóa t?p quy?n, t?p vai trò c?a qu?n tr? c?    
		 DELETE FROM [dbo].[Admin.UserPersmissions] WHERE FK_UserID = @adminOld
		 DELETE FROM [dbo].[Admin.UserRoles] WHERE FK_UserID =@adminOld

		 -- Thêm t?p quy?n c?a qu?n tr? c? b?ng qu?n tr? m?i
		 INSERT INTO [dbo].[Admin.UserPersmissions]
		         ( [FK_UserID] ,
		           [FK_PermissionID] ,
		           [CreatedByUser] ,
		           [CreatedDate]
		         )
		 SELECT  @adminOld AS  FK_UserID ,
		         FK_PermissionID ,
		         CreatedByUser ,
		         GETDATE() CreatedDate FROM 
				 [dbo].[Admin.UserPersmissions]
				 WHERE FK_UserID = @adminNew
		 -- Thêm t?p vai trò c?a qu?n tr? c? b?ng qu?n tr? m?i
		 INSERT INTO [dbo].[Admin.UserRoles]
		         ( [FK_UserID] ,
		           [FK_RoleID] ,
		           [CreatedByUser] ,
		           [CreatedDate]
		         )
		 SELECT @adminOld AS  FK_UserID ,
		         FK_RoleID ,
		         CreatedByUser ,
		         GETDATE() AS CreatedDate 
				 FROM [dbo].[Admin.UserRoles]
				 WHERE FK_UserID = @adminNew
		
		 -- Xóa t?p quy?n, t?p vai trò c?a qu?n tr? c? vào b?ng t?m     
		 DELETE FROM [dbo].[Admin.UserPersmissions] WHERE FK_UserID = @adminNew
		 DELETE FROM [dbo].[Admin.UserRoles] WHERE FK_UserID =@adminNew
		 
		 -- Thêm t?p quy?n c?a qu?n tr? m?i b?ng t?p quy?n c?a qu?n tr? c? trong b?ng t?m
		 INSERT INTO [dbo].[Admin.UserPersmissions]
		         ( [FK_UserID] ,
		           [FK_PermissionID] ,
		           [CreatedByUser] ,
		           [CreatedDate]
		         )
		 SELECT  @adminNew AS  FK_UserID ,
		         FK_PermissionID ,
		         CreatedByUser ,
		         GETDATE() CreatedDate FROM 
				 #tmpUserPersmissions
		-- Thêm t?p vai trò c?a qu?n tr? m?i b?ng t?p quy?n c?a qu?n tr? c? trong b?ng t?m
		 INSERT INTO [dbo].[Admin.UserRoles]
		         ( [FK_UserID] ,
		           [FK_RoleID] ,
		           [CreatedByUser] ,
		           [CreatedDate]
		         )
		 SELECT @adminNew AS  FK_UserID ,
		         FK_RoleID ,
		         CreatedByUser ,
		         GETDATE() AS CreatedDate 
				FROM #tmpUserRoles

		UPDATE [dbo].[Admin.Users] SET FK_UserTypeID = 1 WHERE PK_UserID = @adminNew
		UPDATE [dbo].[Admin.Users] SET FK_UserTypeID = 2 WHERE PK_UserID = @adminOld

		END
     COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
        END CATCH        
    END
    
------------------------------------------------------------------------------------------------------------------------