USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[CheckSignalOnlines_Search]    Script Date: 04/08/2017 15:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CheckSignalOnlines_Search]
(
	@FromDate		DATETIME,
	@ToDate			DATETIME,
	@Username		VARCHAR(50),
	@VehiclePlate	VARCHAR(50),
	@XNCode			INT,
	@StartRow		INT,
	@EndRow			INT
)
AS
BEGIN
	-- =============================================
	-- Author:		LuanBH
	-- Description:	
	-- Create date: 02-03-2016
	-- =============================================
	WITH cteReportSpeedOver  AS (
	SELECT  ROW_NUMBER() OVER (ORDER BY VehiclePlate , CheckDate DESC) AS RowNumber, PK_LogID ,
			Username ,
			XNCode ,
			VehiclePlate ,
			IPAddress ,
			CheckDate ,
			LogFlag FROM dbo.[Log.CheckSignalOnlines]
		WHERE CheckDate BETWEEN @FromDate AND @ToDate
		AND ((@Username IS NULL OR @Username = '') OR Username LIKE '%' + @Username + '%')
		AND ((@VehiclePlate IS NULL OR @VehiclePlate = '') OR VehiclePlate LIKE '%' + @VehiclePlate + '%')
		AND (@XNCode = 0 OR XNCode = @XNCode)
	)

	Select cte.*
	From cteReportSpeedOver cte
	WHERE RowNumber BETWEEN @StartRow AND @EndRow 
END

