EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'PlumaCMS'
GO
USE [master]
GO

ALTER DATABASE [PlumaCMS] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE [PlumaCMS]
GO
