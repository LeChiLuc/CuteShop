USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[CheckerTrip_AgreementTrip_ByVehicleID]    Script Date: 02/08/2017 16:47:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=======================
-- <phongnc>
-- 20/01/2015
-- Đếm số cuốc thỏa thuận, tiền thực thu, tiền đồng hồ theo xnCode và vehicleID
--=======================
ALTER PROC [dbo].[CheckerTrip_AgreementTrip_ByVehicleID] --'444',49293,'1970-01-01 12:00:00','2015-01-30 4:51:42'
    @XnCode int,
    @VehicleID bigint,
    @TimeCheckerBefore datetime,
    @TimeChecker datetime
AS
BEGIN
     
    --Kiểm tra xem có phải loại đồng hồ Patent(1) và Adsun(3) không ?
    --Nếu phải thì lấy dữ liệu trong bảng cuốc khách chốt cơ.
    --Không thì lấy trong bảng Trip.Trips

     DECLARE @TypeMeter INT = 0
     SET @TypeMeter = (	SELECT COUNT(1) 
						FROM [Vehicle.Vehicles]
						WHERE XNCode = @XnCode  AND PK_VehicleID = @VehicleID AND FK_MeterTypeID  IN (1,3))
	IF	@TypeMeter = 0 OR @XnCode='433' OR @XnCode='6052' OR @XnCode='6041' OR @XnCode='9005' OR @XNCode='835' OR @XNCode='6072'
	BEGIN
		SELECT --SUM(CONVERT(int,t.IsTripAgreement)) TripAgreementCount,
			   --SUM(ISNULL(0,t.FK_TripAgreementID)) TripAgreementCount,
			   SUM(CASE WHEN tt.IsTripAgreement is NULL then 0 else 1 end) TripAgreementCount,
			   --SUM(ISNULL(tt.IsTripAgreement,0)) TripAgreementCount,
			   SUM(MoneyReceiver) MoneyReceiver,
			   SUM(MoneyOnMeter) MoneyOnMeter,
			   Count(MoneyOnMeter) TripCount
		FROM  [Trip.Trips] tt
		INNER JOIN [Company.Companies] c ON tt.FK_CompanyID = c.PK_CompanyID
				--LEFT JOIN [Vehicle.Vehicles] vv ON tt.FK_VehicleID = vv.PK_VehicleID
				WHERE (c.XNCode = @XnCode OR (@XnCode='771' AND tt.KmHasGuest > 0.1))
				AND ( tt.IsDeleted = 0 OR tt.IsDeleted IS NULL ) 
				AND ( tt.TripType = 0 OR tt.TripType = 1)
				--AND ( tt.MoneyReceiver <= 0 OR 0 = 0 )
				--AND ( tt.MoneyReceiver IS NOT NULL)
				AND tt.EndTimeGPS > @TimeCheckerBefore
				AND tt.EndTimeGPS <= @TimeChecker
				AND tt.FK_VehicleID = @VehicleID
				AND CheckerDateTime is not null 
				AND CheckerDateTime > '2000/01/01 00:00:00'
	END
	ELSE		
	BEGIN
		SELECT 0 AS TripAgreementCount,
			SUM(MoneyOnMeter) MoneyReceiver, --trong bảng này thì tiền đồng hồ và tiền thực thu bằng nhau
			SUM(MoneyOnMeter) MoneyOnMeter,
			Count(MoneyOnMeter) TripCount
		FROM  [Trip.ChekerTrips] tc
		INNER JOIN [Company.Companies] c ON tc.FK_CompanyID = c.PK_CompanyID
		WHERE (c.XNCode = @XnCode OR (@XnCode='771' AND tc.KmHasGuest > 0.1))
				  AND tc.FK_VehicleID = @VehicleID 
				  --AND CheckerDateTime > @TimeCheckerBefore 
				  --AND CheckerDateTime <= @TimeChecker
				  --AND CheckerDateTime is not NULL
				  AND tc.EndTimeMeter > @TimeCheckerBefore
				  AND tc.EndTimeMeter <= @TimeChecker
				  AND tc.EndTimeMeter is not null
	--) T
	END
END
