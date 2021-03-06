USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[CheckSignalOnlines_SaveLog]    Script Date: 04/08/2017 15:22:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CheckSignalOnlines_SaveLog]
(
	@Username VARCHAR(50),
	@XNCode INT,
	@VehiclePlate VARCHAR(16),
	@IPAddress VARCHAR(20),
	@LogFlag INT
)
AS
BEGIN
	INSERT INTO dbo.[Log.CheckSignalOnlines]
			( [Username] ,
			  [XNCode] ,
			  [VehiclePlate] ,
			  [IPAddress] ,
			  [LogFlag]
			)
	VALUES  ( @Username , -- Username - varchar(50)
			  @XNCode , -- XNCode - int
			  @VehiclePlate , -- VehiclePlate - varchar(16)
			  @IPAddress , -- IPAddress - varchar(20)
			  @LogFlag  -- LogFlag - int
			)
END