--RAISERROR (N'INTENTIONAL SAFETY ERROR', 20, 1) WITH LOG;

SET STATISTICS IO ON;

PRINT N'Freeing Procedure Cache';
DBCC FREEPROCCACHE;

PRINT N'Selecting MyTable Ordered By RowKey';
SELECT
    [PartitionKey]
    ,[RowKey]
    ,[Timestamp]
    ,[MyInput]
    ,N'[RowKey]' AS [Sort]
FROM
    [dbo].[MyTable]
ORDER BY
    [RowKey]
;

PRINT N'Selecting MyTable Ordered By Timestamp';
SELECT
    [PartitionKey]
    ,[RowKey]
    ,[Timestamp]
    ,[MyInput]
    ,N'[Timestamp]' AS [Sort]
FROM
    [dbo].[MyTable]
ORDER BY
    [Timestamp]
;
