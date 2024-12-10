USE [master];
GO

EXECUTE [msdb].[dbo].[sp_delete_database_backuphistory] @database_name = N'AdventureWorks2019';
GO

DROP DATABASE [AdventureWorks2019];
GO
