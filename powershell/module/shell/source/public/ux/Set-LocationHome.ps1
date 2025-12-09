function Set-LocationHome {
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

        Set-Location -Path $HOME
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}

New-Alias -Name "home" -Value "Set-LocationHome" -Force -Scope Global
