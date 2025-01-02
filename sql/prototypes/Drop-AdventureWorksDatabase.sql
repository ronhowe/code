USE [master];

EXECUTE [msdb].[dbo].[sp_delete_database_backuphistory] @database_name = N'AdventureWorks2019';

IF (DB_ID(N'AdventureWorks2019') IS NOT NULL)
BEGIN

    PRINT N'Setting Database Offline';
    ALTER DATABASE [AdventureWorks2019] SET OFFLINE WITH ROLLBACK IMMEDIATE;

    PRINT N'Setting Database Online';
    ALTER DATABASE [AdventureWorks2019] SET ONLINE;

    PRINT N'Dropping Database';
    DROP DATABASE [AdventureWorks2019];

END;
