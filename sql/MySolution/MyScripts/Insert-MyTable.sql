/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

USE [MyDatabase];

GO

:setvar COUNT 1
:setvar MYINPUT 1

SET NOCOUNT ON;

PRINT N'Inserting Into Table';
INSERT [dbo].[MyTable]
(
    [RowKey]
    ,[MyInput]
)
VALUES
(
    -- TODO: Replace mock for Guid.CreateVersion7().ToString().
    CAST(NEWID() AS CHAR(36))
    ,$(MYINPUT)
);

GO $(COUNT)

USE [master];

GO
