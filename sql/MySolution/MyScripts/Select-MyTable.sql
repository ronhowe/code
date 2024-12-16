/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

USE [MyDatabase];

GO

:setvar TOP "TOP (1)"
--:setvar TOP ""

SET NOCOUNT ON;

PRINT N'Selecting Count Of Rows In Table';
SELECT
    COUNT(*) AS [CountOfMyTable]
FROM
    [dbo].[MyTable]
;

PRINT N'Selecting Rows From Table';
SELECT $(TOP)
    [RowKey]
    ,[Timestamp]
    ,[MyInput]
FROM
    [dbo].[MyTable]
ORDER BY
    [RowKey] DESC
;

GO

USE [master];

GO
