USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[Assign]    Script Date: 02/08/2017 16:46:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------
--phongnc 17/07/2015 created
--Gán nhanh nhóm tuyến, xe, tài khoản
--------------------------------

ALTER PROCEDURE [dbo].[Assign]
@CompanyID INT,
@UserActID UNIQUEIDENTIFIER,
@PrivateCode NVARCHAR(50),
@GroupParent NVARCHAR(250),
@Group NVARCHAR(250),
@Account NVARCHAR(50),
@Password NVARCHAR(250)
AS
BEGIN
	SET XACT_ABORT ON --bất cứ lỗi nào xảy ra thì đều ko cho commit

	BEGIN TRANSACTION
	BEGIN TRY

		DECLARE @groupParentID INT
		DECLARE @groupID INT 
        DECLARE @groupTbl TABLE(PK_VehicleGroupID INT, ParentGroupID INT, GroupName NVARCHAR(250)) 
		DECLARE @vehicleID BIGINT
		DECLARE @vehicleGroupID INT
		DECLARE @userVehicleGroupCount INT 
		DECLARE @user UNIQUEIDENTIFIER
		DECLARE @ErrorMessage VARCHAR(2000) = ''

	--check nhóm cha
	IF(@GroupParent IS NOT NULL AND @GroupParent <> '')
	BEGIN
		--kiểm tra nhóm cha
		SET @groupParentID = (SELECT TOP 1 PK_VehicleGroupID FROM dbo.[Vehicle.Groups] vg 
								WHERE LOWER(@GroupParent) = vg.GroupName 
								AND vg.FK_CompanyID = @CompanyID
								AND (vg.IsDeleted IS NULL OR vg.IsDeleted = 0)
								)
		IF(@groupParentID IS NULL OR @groupParentID = 0) --nếu chưa có thì insert
		BEGIN
			INSERT INTO dbo.[Vehicle.Groups]
			        ( FK_CompanyID ,
					ParentGroupID,
			          GroupName ,
			          DisplayName ,
			          CreatedByUser ,
			          CreatedDate 
			        )
			VALUES  ( @CompanyID , -- FK_CompanyID - int
						0,
			          N''+ @GroupParent +'' , -- GroupName - nvarchar(250)
			          N''+ @GroupParent +'' , -- DisplayName - nvarchar(250)
			          @UserActID , -- CreatedByUser - uniqueidentifier
			          GETDATE()  -- CreatedDate - datetime
			        )

			SET @groupParentID = SCOPE_IDENTITY()

		END

	END

		--kiểm tra nhóm đã có chưa
		INSERT INTO @groupTbl ( PK_VehicleGroupID, ParentGroupID, GroupName )
		SELECT TOP 1 PK_VehicleGroupID, ParentGroupID, vg.GroupName FROM dbo.[Vehicle.Groups] vg 
		WHERE LOWER(@Group) = vg.GroupName 
		AND vg.FK_CompanyID = @CompanyID
		AND (vg.IsDeleted IS NULL OR vg.IsDeleted = 0)

		IF((SELECT COUNT(1) FROM @groupTbl) <= 0) --nếu chưa có thì insert
		BEGIN
			IF(@groupParentID IS NULL OR @groupParentID = 0) --nếu ko có nhóm cha thì cho nhóm cha là 0
			BEGIN
				INSERT INTO dbo.[Vehicle.Groups]
			        ( ParentGroupID ,
					  FK_CompanyID ,
			          GroupName ,
			          DisplayName ,
			          CreatedByUser ,
			          CreatedDate 
			        )
				VALUES  ( 0,
						  @CompanyID , -- FK_CompanyID - int
						  N''+ @Group +'' , -- GroupName - nvarchar(250)
						  N''+ @Group +'' , -- DisplayName - nvarchar(250)
						  @UserActID , -- CreatedByUser - uniqueidentifier
						  GETDATE()  -- CreatedDate - datetime
						)

				SET @groupID = SCOPE_IDENTITY()

			END
			ELSE
			BEGIN --nếu có nhóm cha ở trên
				INSERT INTO dbo.[Vehicle.Groups]
				        ( ParentGroupID ,
				          FK_CompanyID ,
						  GroupName ,
						  DisplayName ,
						  CreatedByUser ,
						  CreatedDate 
				        )
				VALUES  ( @groupParentID , -- ParentGroupID - int
				          @CompanyID , -- FK_CompanyID - int
						  N''+ @Group +'' , -- GroupName - nvarchar(250)
						  N''+ @Group +'' , -- DisplayName - nvarchar(250)
						  @UserActID , -- CreatedByUser - uniqueidentifier
						  GETDATE()  -- CreatedDate - datetime
				        )

				SET @groupID = SCOPE_IDENTITY()

			END
		END
		ELSE --nếu nhóm đã tồn tại
		BEGIN
			SET @groupID = (SELECT TOP 1 PK_VehicleGroupID FROM @groupTbl)
			--cập nhật nhóm cha
			IF(@groupParentID IS NOT NULL AND @groupParentID > 0)
			BEGIN
				UPDATE dbo.[Vehicle.Groups]
				SET ParentGroupID = @groupParentID
				WHERE PK_VehicleGroupID = (SELECT TOP 1 PK_VehicleGroupID FROM @groupTbl)
			END
		END

		--check tài khoản
		SET @user = (SELECT TOP 1 PK_UserID FROM [dbo].[Admin.Users] 
					WHERE UPPER(Username) = UPPER(@Account) 
					AND FK_CompanyID = @CompanyID
					AND ( IsDeleted IS NULL OR IsDeleted = 0)
					AND (IsLock IS NULL OR IsLock = 0 )
					)
		IF(@user IS NULL OR @user = '00000000-0000-0000-0000-000000000000')
		BEGIN
			SET @user = NEWID()
			INSERT INTO [dbo].[Admin.Users]
			        ( [PK_UserID] ,
			          [FK_UserTypeID] ,
			          [FK_CompanyID] ,
			          [Username] ,
			          [Password] ,
			          [Fullname] ,
			          [LockLevel] ,
			          [CreatedByUser] ,
			          [CreatedDate] 
			        )
			VALUES  ( @user , -- PK_UserID - uniqueidentifier
			          2 , -- FK_UserTypeID - tinyint
			          @CompanyID , -- FK_CompanyID - int
			          N''+ @Account +'' , -- Username - nvarchar(50)
			          N''+ @Password +'' , -- Password - nvarchar(250)
			          N''+ @Account +'' , -- Fullname - nvarchar(50)
			          0 , -- LockLevel - tinyint
			          @UserActID , -- CreatedByUser - uniqueidentifier
			          GETDATE()  -- CreatedDate - smalldatetime
			        )
		END

		--lấy ra id xe
		SET @vehicleID = (SELECT TOP 1 PK_VehicleID FROM [dbo].[Vehicle.Vehicles] 
							WHERE PrivateCode = @PrivateCode 
							AND FK_CompanyID = @CompanyID
							AND ( IsDeleted IS NULL OR IsDeleted = 0)
							AND ( IsLocked IS NULL OR IsLocked = 0 )
							)
		
		--kiểm tra xem xe - nhóm đội đã được gán với nhau chưa
		SET @vehicleGroupID = (SELECT TOP 1 FK_VehicleGroupID FROM [dbo].[Vehicle.VehicleGroups] WHERE FK_VehicleGroupID = @groupID AND FK_VehicleID = @vehicleID )
		IF(@vehicleGroupID IS NULL OR @vehicleGroupID = 0) --nếu chưa có thì insert vào
		BEGIN 
			INSERT INTO [dbo].[Vehicle.VehicleGroups]
					( [FK_VehicleGroupID] ,
					  [FK_VehicleID] ,
					  [CreatedByUser] ,
					  [CreatedDate]
					)
			VALUES  ( @groupID , -- FK_VehicleGroupID - int
					  @vehicleID , -- FK_VehicleID - bigint
					  @UserActID , -- CreatedByUser - uniqueidentifier
					  GETDATE()  -- CreatedDate - datetime
					)
		END

		--nếu có nhóm cha thì kiểm tra xem nhóm cha đã được gán với người dùng chưa

		IF(@groupParentID IS NOT NULL AND @groupParentID > 0)
		BEGIN
			IF((SELECT COUNT(1) FROM [dbo].[Admin.UserVehicleGroups] WHERE FK_UserID = @user AND FK_VehicleGroupID = @groupParentID) <= 0)
			BEGIN
				INSERT INTO [dbo].[Admin.UserVehicleGroups]
					( [FK_UserID] ,
					  [FK_VehicleGroupID] ,
					  [CreatedByUser] ,
					  [CreatedDate] 
					)
				VALUES  ( @user , -- FK_UserID - uniqueidentifier
						  @groupParentID , -- FK_VehicleGroupID - int
						  @UserActID , -- CreatedByUser - uniqueidentifier
						  GETDATE()  -- CreatedDate - datetime
						)
			END
		END

		--kiểm tra xem tài khoản - nhóm đội đã được gán với nhau chưa
		SET @userVehicleGroupCount = (SELECT COUNT(1) FROM [dbo].[Admin.UserVehicleGroups] WHERE FK_UserID = @user AND FK_VehicleGroupID = @groupID)
		IF(@userVehicleGroupCount IS NULL OR @userVehicleGroupCount <= 0)
		BEGIN
			INSERT INTO [dbo].[Admin.UserVehicleGroups]
					( [FK_UserID] ,
					  [FK_VehicleGroupID] ,
					  [CreatedByUser] ,
					  [CreatedDate] 
					)
			VALUES  ( @user , -- FK_UserID - uniqueidentifier
					  @groupID , -- FK_VehicleGroupID - int
					  @UserActID , -- CreatedByUser - uniqueidentifier
					  GETDATE()  -- CreatedDate - datetime
					)
		END 
	COMMIT

	END TRY
	BEGIN CATCH
		ROLLBACK
		SET @ErrorMessage = 'Lỗi: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMessage, 16, 1)
	END CATCH

	SELECT @ErrorMessage
END