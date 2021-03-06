USE [BA_XeChieuVe_Common]
GO
/****** Object:  StoredProcedure [dbo].[AdminlogGetLoginByEventLog]    Script Date: 02/08/2017 16:33:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--hanhth 24-04 lay theo loai event
ALTER PROC [dbo].[AdminlogGetLoginByEventLog]
@companyID INT,
@eventID int
AS 
BEGIN
	
	SELECT [PK_LogID]		  
		  ,[EventTime]
		  ,[IP]
		  ,[LogContent]
		  ,av.Name
		  ,au.Username
		  ,au.Fullname
	  FROM [BA_WebTaxi_V2_Report].[dbo].[Admin.Logs] al
	  INNER JOIN dbo.[Admin.EventLogs] av 
	  ON av.PK_EventID = al.FK_EventID
	  INNER JOIN dbo.[Admin.Users] au
	  ON au.PK_UserID = al.FK_UserID 
	  WHERE al.FK_CompanyID=@companyID AND al.FK_EventID=@eventID
	  ORDER BY al.EventTime DESC
END
