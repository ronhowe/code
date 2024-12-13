/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

ALTER DATABASE [MyDatabase] SET OFFLINE WITH ROLLBACK IMMEDIATE;
GO
ALTER DATABASE [MyDatabase] SET ONLINE;
GO
DROP DATABASE [MyDatabase];
GO
