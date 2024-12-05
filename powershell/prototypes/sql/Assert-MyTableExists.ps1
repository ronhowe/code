<###############################################################################
https://github.com/ronhowe
###############################################################################>

function Assert-MyTableExists {
    $parameters = @{
        ServerInstance = "localhost"
        Database       = "MyDatabase"
        Encrypt        = "Optional"
        InputFile      = "$HOME\repos\ronhowe\code\sql\MySolution\MyScripts\Assert-MyTableExists.sql"
        QueryTimeout   = 100
    }
    return Invoke-SqlCmd @parameters
}
