@{
    AllNodes = @(
        @{
            NodeName  = 'LOCALHOST'
            ## NOTE: You can't use variables like $HOME.  Relative like ~ work because Resolve-Path to this string literal.
            ReposPath = '~\repos'
        }
    );
}
