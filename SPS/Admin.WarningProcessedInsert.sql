USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Admin.WarningProcessedInsert]    Script Date: 02/08/2017 16:23:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[Admin.WarningProcessedInsert]
@UserID UNIQUEIDENTIFIER,
@WarningID INT,
@Content NVARCHAR(500)
AS
BEGIN
INSERT INTO dbo.[Admin.WarningProcessed]
        ( FK_WarningID ,
          Content ,
          CreatedBy 
        )
VALUES  ( @WarningID, -- FK_WarningID - int
          @Content , -- Content - nvarchar(500)
          @UserID
        ) 
END
