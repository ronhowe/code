USE [MyDatabase];
GO

-- NOTE: Requires Entra ID authentication.
PRINT N'Creating User';
CREATE USER [app-ronhowe-0] FROM EXTERNAL PROVIDER;

PRINT N'Granting Data Writer To User';
ALTER ROLE [db_datawriter] ADD MEMBER [app-ronhowe-0];
