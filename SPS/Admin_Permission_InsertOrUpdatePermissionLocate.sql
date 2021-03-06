USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Permission_InsertOrUpdatePermissionLocate]    Script Date: 02/08/2017 16:24:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: trungtq
-- Create date: 11/08/2014
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[Admin_Permission_InsertOrUpdatePermissionLocate] --'','vi' -- ''
@PermissionID	INT,
@Culture		CHAR(5),
@DisplayName	NVARCHAR(250),
@User			UNIQUEIDENTIFIER
AS 
    BEGIN
		IF((SELECT 1 FROM [Admin.PermissionLocates] 
		WHERE FK_PermissionID = @PermissionID AND Culture = @Culture) > 0)
		BEGIN
			UPDATE [Admin.PermissionLocates] SET 
			DisplayName = @DisplayName,
			UpdatedDate = GETDATE(),
			UpdatedUser = @User
			WHERE FK_PermissionID = @PermissionID AND Culture = @Culture
		END
		ELSE
		BEGIN
			INSERT INTO [Admin.PermissionLocates]
			(
				[FK_PermissionID]
				,[Culture]
				,[DisplayName]
				,[CreatedUser]
				,[CreatedDate]
				,[UpdatedUser]
				,[UpdatedDate]
			 )
			 VALUES
			 (
				@PermissionID,
				@Culture,
				@DisplayName,
				@User,
				GETDATE(),
				null,
				null
			 )
		END
    END 
------------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

