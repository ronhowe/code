-- NOTE: Modeled after Azure Table Storage.
CREATE TABLE [dbo].[MyTable]
(
    [PartitionKey] DATETIME NOT NULL
    ,[RowKey] CHAR(36) NOT NULL
    ,[Timestamp] DATETIME NOT NULL DEFAULT GETUTCDATE()
    ,[MyInput] BIT NOT NULL
    CONSTRAINT [MyTablePrimaryKey] PRIMARY KEY ([PartitionKey], [RowKey]) -- both required
)
ON [MyPartitionScheme]([PartitionKey]);
