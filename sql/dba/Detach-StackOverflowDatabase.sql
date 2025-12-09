USE [master];
GO

ALTER DATABASE [StackOverflow2013] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

EXECUTE [master].[dbo].[sp_detach_db] @dbname = N'StackOverflow2013';
GO
