@{
    AllNodes = @(
        @{
            NodeName  = "localhost"
            ## NOTE: Can't use variables.  Relativives like ~ work because Resolve-Path to this string literal.
            ReposPath = "~\repos"
        }
    );
}