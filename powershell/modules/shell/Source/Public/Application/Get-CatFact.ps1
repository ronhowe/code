function Get-CatFact {
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
        Write-Debug "Process $($MyInvocation.MyCommand.Name)"

        $result = Invoke-Request -Uri "https://catfact.ninja/fact" -ContentOnly |
        ConvertFrom-Json

        return $result.fact
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}
