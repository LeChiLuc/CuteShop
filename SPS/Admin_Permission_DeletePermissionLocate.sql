USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Permission_DeletePermissionLocate]    Script Date: 02/08/2017 16:24:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: trungtq
-- Create date: 11/08/2014
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[Admin_Permission_DeletePermissionLocate] --'','vi' -- ''
@PermissionID	INT,
@Culture		CHAR(5)
AS 
    BEGIN
		DELETE [Admin.PermissionLocates] WHERE FK_PermissionID = @PermissionID AND Culture = @Culture
    END 
------------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

