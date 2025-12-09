function Show-Help {
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

        Write-Host "catfact => Displays a random fact about cats."
        Write-Host "date    => Displays local and UTC times."
        Write-Host "help    => Displays the Shell help."
        Write-Host "home    => Locates the standard home folder."
        Write-Host "matrix  => Take the blue pill or red pill?  (requires wsl and cmatrix)"
        Write-Host "menu    => Starts the Shell menu"
        Write-Host "new     => Refreshes the screen."
        Write-Host "oops    => Opens Notepad to edit command history."
        Write-Host "redact  => Removes the last issued command from the PowerShell history."
        Write-Host "repos   => Locates the standard repos folder."
        Write-Host "shell   => Starts the Shell."
        Write-Host "time    => Displays local and UTC times."
        Write-Host "version => Displays the version of PowerShell and the Shell."
        Write-Host "weather => Displays the weather."
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}

New-Alias -Name "help" -Value "Show-Help" -Force -Scope Global
