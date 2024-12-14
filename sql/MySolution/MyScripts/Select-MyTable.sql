/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

SET NOCOUNT ON;

SELECT
    COUNT(*) AS [CountOfMyTable]
FROM
    [dbo].[MyTable]
;

SELECT TOP (1)
    [RowKey]
    ,[Timestamp]
    ,[MyInput]
FROM
    [dbo].[MyTable]
ORDER BY
    [RowKey] DESC
;

GO
