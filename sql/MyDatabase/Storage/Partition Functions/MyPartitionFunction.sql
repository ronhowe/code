﻿/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

CREATE PARTITION FUNCTION [MyPartitionFunction] (DATETIME)

AS

RANGE RIGHT FOR VALUES (N'2000-01-01');
