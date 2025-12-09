USE [master];
GO

CREATE DATABASE [StackOverflow2013] ON 
(FILENAME = N'D:\MSSQL\Data\StackOverflow2013_1.mdf'),
(FILENAME = N'D:\MSSQL\Data\StackOverflow2013_2.ndf'),
(FILENAME = N'D:\MSSQL\Data\StackOverflow2013_3.ndf'),
(FILENAME = N'D:\MSSQL\Data\StackOverflow2013_4.ndf'),
(FILENAME = N'D:\MSSQL\Data\StackOverflow2013_log.ldf')
FOR ATTACH;
GO
