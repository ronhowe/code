function Get-CatFact {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        $result = Invoke-Request -Uri "https://catfact.ninja/fact" -ContentOnly |
        ConvertFrom-Json |
        Select-Object -ExpandProperty "fact"

        return $result
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
