CREATE PARTITION SCHEME [MyPartitionScheme]

AS

PARTITION [MyPartitionFunction] ALL TO ([PRIMARY]);
