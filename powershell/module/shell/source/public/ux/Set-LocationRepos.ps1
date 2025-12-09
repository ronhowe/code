function Set-LocationRepos {
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

        if (Test-Path -Path "$HOME\repos") {
            Set-Location -Path "$HOME\repos"
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}

New-Alias -Name "repos" -Value "Set-LocationRepos" -Force -Scope Global
