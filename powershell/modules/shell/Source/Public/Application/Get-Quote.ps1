function Get-Quote {
    [CmdletBinding()]
    param (
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
    }
    process {
        $ProgressPreference = "SilentlyContinue"

        Write-Debug "Process $($MyInvocation.MyCommand.Name)"

        $quotes = Invoke-Request -Uri "https://type.fit/api/quotes" -ContentOnly |
        ConvertFrom-Json

        $random = Get-Random -Minimum 0 -Maximum $quotes.Count

        return $quotes[$random]
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}
