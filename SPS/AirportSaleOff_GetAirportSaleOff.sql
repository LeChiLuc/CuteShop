USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[AirportSaleOff_GetAirportSaleOff]    Script Date: 02/08/2017 16:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		trungtq
-- Create date: 14/07/2015
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[AirportSaleOff_GetAirportSaleOff]
    @CompanyID INT ,
    @SaleOffTypes TINYINT ,
    @Seat TINYINT ,
    @Direction TINYINT
AS 
    BEGIN
        SET NOCOUNT ON;
        SELECT TOP 1
                PK_AirportSaleOffID AS AirportSaleOffID ,
                FK_CompanyID AS CompanyID ,
                ApplyDate ,
                SaleOffTypes ,
                Formula ,
                Seats ,
                Direction ,
                DownPercent2ways ,
                BeginKm2Ways ,
                Description ,
                IsDeleted ,
                CreatedByUser ,
                CreatedDate ,
                UpdatedByUser ,
                UpdatedDate
        FROM    [dbo].[Config.AirportSaleOff]
        WHERE   FK_CompanyID = @CompanyID
                AND SaleOffTypes = @SaleOffTypes
                AND Seats = @Seat
                AND Direction = @Direction
                AND IsDeleted = 0
        ORDER BY ApplyDate DESC 
    END

-----------------------------------------------------------------------------------------------------------
