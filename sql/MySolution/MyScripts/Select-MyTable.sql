/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

SET NOCOUNT ON;

SELECT
    COUNT(*) AS [CountOfMyTable]
FROM
    [dbo].[MyTable]
;

SELECT TOP (10)
    [Id]
    ,[Value]
    ,[Inserted]
FROM
    [dbo].[MyTable]
ORDER BY
    [Id] DESC
;
