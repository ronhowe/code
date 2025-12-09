function Get-CatFact {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        $result = Invoke-Request -Uri "https://catfact.ninja/fact" -ContentOnly |
        ConvertFrom-Json |
        Select-Object -ExpandProperty "fact"

        return $result
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}

New-Alias -Name "catfact" -Value "Get-CatFact" -Force -Scope Global
