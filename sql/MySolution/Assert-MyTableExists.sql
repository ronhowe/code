SET NOCOUNT ON;
IF EXISTS
(
	SELECT
		[name]
	FROM
		[sys].[tables]
	WHERE
		[name] = N'MyTable'
)
BEGIN
	SELECT 1 AS [result];
END;
ELSE
BEGIN
	SELECT 0 AS [result];
END;
