/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

USE [MyDatabase];

GO

:setvar TOP "TOP (1)"
--:setvar TOP ""

SET NOCOUNT ON;
SET STATISTICS IO ON;

PRINT N'Freeing Procedure Cache';
DBCC FREEPROCCACHE;

SELECT $(TOP)
    [RowKey]
    ,[Timestamp]
    ,[MyInput]
    ,N'[RowKey]' AS [Sort]
FROM
    [dbo].[MyTable]
ORDER BY
    [RowKey]
;

SELECT $(TOP)
    [RowKey]
    ,[Timestamp]
    ,[MyInput]
    ,N'[RowKey] DESC' AS [Sort]
FROM
    [dbo].[MyTable]
ORDER BY
    [RowKey] DESC
;

SELECT $(TOP)
    [RowKey]
    ,[Timestamp]
    ,[MyInput]
    ,N'[Timestamp]' AS [Sort]
FROM
    [dbo].[MyTable]
ORDER BY
    [Timestamp]
;

SELECT $(TOP)
    [RowKey]
    ,[Timestamp]
    ,[MyInput]
    ,N'[Timestamp] DESC' AS [Sort]
FROM
    [dbo].[MyTable]
ORDER BY
    [Timestamp] DESC
;

GO

USE [master];

GO
