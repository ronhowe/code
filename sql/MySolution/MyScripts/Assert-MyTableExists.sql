/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

SET NOCOUNT ON;

SELECT
    CASE
        WHEN OBJECT_ID(N'dbo.MyTable') IS NOT NULL THEN 1
        ELSE 0
    END AS [MyTableExists]
;

GO
