USE [master];

EXECUTE [msdb].[dbo].[sp_delete_database_backuphistory] @database_name = N'AdventureWorks2025';

IF (DB_ID(N'AdventureWorks2025') IS NOT NULL)
BEGIN

    PRINT N'Setting Database Offline';
    ALTER DATABASE [AdventureWorks2025] SET OFFLINE WITH ROLLBACK IMMEDIATE;

    PRINT N'Setting Database Online';
    ALTER DATABASE [AdventureWorks2025] SET ONLINE;

    PRINT N'Dropping Database';
    DROP DATABASE [AdventureWorks2025];

END;
