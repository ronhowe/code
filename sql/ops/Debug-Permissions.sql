/* IIS USER */

USE [master];
GO

PRINT N'Creating Login';
CREATE LOGIN [IIS APPPOOL\DefaultAppPool] FROM WINDOWS WITH DEFAULT_DATABASE = [master];
GO

USE [MyDatabase];
GO

PRINT N'Creating User';
CREATE USER [IIS APPPOOL\DefaultAppPool] FOR LOGIN [IIS APPPOOL\DefaultAppPool];
GO

PRINT N'Granting Data Reader To User';
ALTER ROLE [db_datareader] ADD MEMBER [IIS APPPOOL\DefaultAppPool];
GO

PRINT N'Granting Data Writer To User';
ALTER ROLE [db_datawriter] ADD MEMBER [IIS APPPOOL\DefaultAppPool];
GO

/* ENTRA ID USER */

USE [master];
GO

-- NOTE: Requires Entra ID authentication.

PRINT N'Creating User';
CREATE USER [app-ronhowe-0] FROM EXTERNAL PROVIDER;
GO

PRINT N'Granting Data Reader To User';
ALTER ROLE [db_datareader] ADD MEMBER [app-ronhowe-0];
GO

PRINT N'Granting Data Writer To User';
ALTER ROLE [db_datawriter] ADD MEMBER [app-ronhowe-0];
GO
