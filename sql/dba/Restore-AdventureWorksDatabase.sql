USE [master];
GO

RESTORE FILELISTONLY FROM DISK = N'D:\MSSQL\Backup\AdventureWorks2025.bak';
GO

RESTORE DATABASE [AdventureWorks2025] FROM DISK = N'D:\MSSQL\Backup\AdventureWorks2025.bak' WITH
MOVE N'AdventureWorks' TO N'D:\MSSQL\Data\AdventureWorks2025.mdf',
MOVE N'AdventureWorks_log' TO N'D:\MSSQL\Data\AdventureWorks2025.ldf',
REPLACE,
STATS = 100
;
GO
