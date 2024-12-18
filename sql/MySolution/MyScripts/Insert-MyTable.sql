/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

:setvar COUNT 1
:setvar MYINPUT 1

SET NOCOUNT ON;

--PRINT N'Inserting Into Table';
INSERT [dbo].[MyTable]
(
    [PartitionKey]
    ,[RowKey]
    ,[MyInput]
)
VALUES
(
    GETUTCDATE() -- [PartitionKey]
    -- TODO: Replace mock for Guid.CreateVersion7().ToString().
    ,CAST(NEWID() AS CHAR(36)) -- [RowKey]
    ,$(MYINPUT) -- [MyInput]
);

GO $(COUNT)
