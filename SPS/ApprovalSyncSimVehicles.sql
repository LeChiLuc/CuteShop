USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[ApprovalSyncSimVehicles]    Script Date: 02/08/2017 16:38:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Longtq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ApprovalSyncSimVehicles]
    @ID BIGINT ,
    @User UNIQUEIDENTIFIER
AS 
    BEGIN
        UPDATE  dbo.[PNC.Sim.Vehicles]
        SET     IsUserApproved = 1 ,
                ApprovedDate = GETDATE() ,
                ApprovedByUser = @User
        WHERE   ID = @ID
		SELECT @@ROWCOUNT
    END
