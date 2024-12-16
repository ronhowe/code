/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

DBCC FREEPROCCACHE;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;

SELECT TOP (1)
    [RowKey]
    ,[Timestamp]
    --,[MyInput]
    ,N'[RowKey]' AS [Sort]
FROM
    [dbo].[MyTable]
ORDER BY
    [RowKey]
;

SELECT TOP (1)
    [RowKey]
    ,[Timestamp]
    --,[MyInput]
    ,N'[RowKey] DESC' AS [Sort]
FROM
    [dbo].[MyTable]
ORDER BY
    [RowKey] DESC
;

SELECT TOP (1)
    [RowKey]
    ,[Timestamp]
    --,[MyInput]
    ,N'[Timestamp]' AS [Sort]
FROM
    [dbo].[MyTable]
ORDER BY
    [Timestamp]
;

SELECT TOP (1)
    [RowKey]
    ,[Timestamp]
    --,[MyInput]
    ,N'[Timestamp] DESC' AS [Sort]
FROM
    [dbo].[MyTable]
ORDER BY
    [Timestamp] DESC
;

GO
