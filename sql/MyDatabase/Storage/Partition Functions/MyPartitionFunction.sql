/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

CREATE PARTITION FUNCTION [MyPartitionFunction] (DATETIME)
AS RANGE RIGHT FOR VALUES ('2022-12-31', '2023-12-31', '2024-12-31');
