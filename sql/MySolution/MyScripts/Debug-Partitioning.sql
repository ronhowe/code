/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

SELECT
    *
FROM
    [sys].[partitions]
WHERE
    1 = 1
    AND [object_id] = OBJECT_ID(N'dbo.MyTable')
    AND [index_id] IN (0, 1)
ORDER BY
    [partition_number]
;

GO
