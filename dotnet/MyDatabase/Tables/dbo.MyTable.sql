﻿CREATE TABLE [dbo].[MyTable]
(
    [Id] INT NOT NULL PRIMARY KEY IDENTITY
    ,[Value] BIT NOT NULL
    ,[Inserted] DATETIME NOT NULL DEFAULT GETUTCDATE()
);