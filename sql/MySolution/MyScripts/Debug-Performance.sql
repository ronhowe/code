/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

SET NOCOUNT ON;
SET STATISTICS IO ON;

PRINT N'Freeing Procedure Cache';
DBCC FREEPROCCACHE;

PRINT N'Selecting Table Ordered By RowKey';
SELECT
    [RowKey]
    ,[Timestamp]
    ,[MyInput]
    ,N'[RowKey]' AS [Sort]
FROM
    [dbo].[MyTable]
ORDER BY
    [RowKey]
;

PRINT N'Selecting Table Ordered By Timestamp';
SELECT
    [RowKey]
    ,[Timestamp]
    ,[MyInput]
    ,N'[Timestamp]' AS [Sort]
FROM
    [dbo].[MyTable]
ORDER BY
    [Timestamp]
;
