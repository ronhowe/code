USE [MyDatabase];
GO

--RAISERROR (N'INTENTIONAL SAFETY ERROR', 20, 1) WITH LOG;

PRINT N'Selecting Partition Functions';
SELECT * FROM [sys].[partition_functions];

PRINT N'Selecting Partition Schemes';
SELECT * FROM [sys].[partition_schemes];

PRINT N'Selecting Partitions';
SELECT
    OBJECT_NAME([object_id]) AS [object_name]
    ,OBJECT_NAME([index_id]) AS [index_name]
    ,*
FROM
    [sys].[partitions]
WHERE
    1 = 1
    AND [object_id] = OBJECT_ID(N'dbo.MyTable')
    AND [index_id] IN (0, 1)
ORDER BY
    [partition_number]
;

--ALTER PARTITION FUNCTION [MyPartitionFunction]() SPLIT RANGE (N'2024-12-19');
--ALTER PARTITION SCHEME [MyPartitionScheme] NEXT USED [PRIMARY];
