function Assert-MyTable {
    $parameters = @{
        ServerInstance = "localhost"
        Database       = "MyDatabase"
        Encrypt        = "Optional"
        InputFile      = "$HOME\repos\ronhowe\code\sql\MySolution\MyScripts\Assert-MyTable.sql"
        QueryTimeout   = 100
    }
    return Invoke-SqlCmd @parameters
}
