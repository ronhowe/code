/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

:setvar COUNT 1
:setvar MYINPUT 1

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
