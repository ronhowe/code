/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

CREATE TABLE [dbo].[MyTable]
(
    -- NOTE: Modeled after Azure Table Storage.
    -- TODO: Add [PartitionKey].
    [RowKey] CHAR(36) NOT NULL
    ,[Timestamp] DATETIME NOT NULL DEFAULT GETUTCDATE()
    ,[MyInput] BIT NOT NULL
    ,CONSTRAINT [MyTablePrimaryKey] PRIMARY KEY ([RowKey])
);
