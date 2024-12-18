/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

PRINT N'Selecting Table';
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
