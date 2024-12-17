/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

PRINT N'Selecting Table';
SELECT
    [RowKey]
    ,[Timestamp]
    ,[MyInput]
FROM
    [dbo].[MyTable]
ORDER BY
    [RowKey]
;
