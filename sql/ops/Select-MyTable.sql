PRINT N'Selecting MyTable';
SELECT
    [PartitionKey]
    ,[RowKey]
    ,[Timestamp]
    ,[MyInput]
FROM
    [dbo].[MyTable]
ORDER BY
    [RowKey]
;
