/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

:setvar COUNT 1000
:setvar MYINPUT 1

SET NOCOUNT ON;

INSERT [dbo].[MyTable]
(
    [MyInput]
)
VALUES
(
    $(MYINPUT)
);

GO $(COUNT)
