USE [master];

IF (DB_ID(N'MyDatabase') IS NOT NULL)
BEGIN

    PRINT N'Setting MyDatabase Offline';
    ALTER DATABASE [MyDatabase] SET OFFLINE WITH ROLLBACK IMMEDIATE;

    PRINT N'Setting MyDatabase Online';
    ALTER DATABASE [MyDatabase] SET ONLINE;

    PRINT N'Dropping MyDatabase';
    DROP DATABASE [MyDatabase];

END;
