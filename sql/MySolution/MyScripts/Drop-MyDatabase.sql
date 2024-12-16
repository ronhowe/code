/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

USE [master];

GO

IF (DB_ID(N'MyDatabase') IS NOT NULL)
BEGIN

    PRINT N'Setting Database Offline';
    ALTER DATABASE [MyDatabase] SET OFFLINE WITH ROLLBACK IMMEDIATE;

    PRINT N'Setting Database Online';
    ALTER DATABASE [MyDatabase] SET ONLINE;

    PRINT N'Dropping Database';
    DROP DATABASE [MyDatabase];

END;

GO
