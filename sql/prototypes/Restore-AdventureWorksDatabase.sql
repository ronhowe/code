USE [master];
GO

RESTORE DATABASE [AdventureWorks2019] FILE = N'AdventureWorks2017' FROM DISK = N'D:\MSSQL\Backup\AdventureWorks2019.bak' WITH
MOVE N'AdventureWorks2017' TO N'D:\MSSQL\Data\AdventureWorks2019.mdf',
MOVE N'AdventureWorks2017_log' TO N'D:\MSSQL\Data\AdventureWorks2019_0.ldf',
REPLACE,
STATS = 100
;
GO
