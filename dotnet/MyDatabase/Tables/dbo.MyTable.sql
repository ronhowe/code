CREATE TABLE [dbo].[MyTable]
(
    -- @NOTE: Modeled after Azure Table Storage.
    -- @TODO: Add [PartitionKey]
    [RowKey] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWSEQUENTIALID()
    ,[Timestamp] DATETIME NOT NULL DEFAULT GETUTCDATE()
    ,[MyInput] BIT NOT NULL
);
