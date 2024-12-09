:setvar BATCH_SIZE 1000
:setvar VALUE 1

SET NOCOUNT ON;

INSERT [dbo].[MyTable]
(
    [Value]
)
VALUES
(
    $(VALUE)
);

GO $(BATCH_SIZE)
