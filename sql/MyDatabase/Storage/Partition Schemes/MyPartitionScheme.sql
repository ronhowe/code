/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

CREATE PARTITION SCHEME [MyPartitionScheme]
AS PARTITION [MyPartitionFunction] ALL TO ([PRIMARY]);
