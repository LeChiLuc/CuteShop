USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[CheckSignalOnlines_Count]    Script Date: 02/08/2017 16:47:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[CheckSignalOnlines_Count]
(
	@FromDate		DATETIME,
	@ToDate			DATETIME,
	@Username		VARCHAR(50),
	@VehiclePlate	VARCHAR(50),
	@XNCode		INT
)
AS
BEGIN
	-- =============================================
	-- Author:		LuanBH
	-- Description:	
	-- Create date: 02-03-2016
	-- =============================================
	SELECT COUNT(1) FROM dbo.[Log.CheckSignalOnlines]
	WHERE CheckDate BETWEEN @FromDate AND @ToDate
	AND ((@Username IS NULL OR @Username = '') OR Username LIKE '%' + @Username + '%')
		AND ((@VehiclePlate IS NULL OR @VehiclePlate = '') OR VehiclePlate LIKE '%' + @VehiclePlate + '%')
		AND (@XNCode = 0 OR XNCode = @XNCode)
END