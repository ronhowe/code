function Show-Help {
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

        # sync with Aliases.ps1
        # sync with Aliases.Tests.ps1
        # sync with Show-Help.ps1
        Write-Host "catfact`n`t- Displays a random fact about cats."
        Write-Host "clock`n`t- Displays local and UTC times."
        Write-Host "date`n`t- Displays local and UTC times."
        Write-Host "go`n`t- Locates the standard code folder."
        Write-Host "header`n`t- Displays the Shell header."
        Write-Host "help`n`t- Displays the Shell help."
        Write-Host "home`n`t- Locates the standard home folder."
        Write-Host "line`n`t- Sets the PowerShell read line predictor to inline format."
        Write-Host "list`n`t- Sets the PowerShell read line predictor to list format."
        Write-Host "logo`n`t- Displays the Shell logo."
        Write-Host "matrix`n`t- Take the blue pill or red pill?  (requires wsl and cmatrix)"
        Write-Host "menu`n`t- Starts the Shell menu"
        Write-Host "new`n`t- Refreshes the screen."
        Write-Host "now`n`t- Displays local and UTC times."
        Write-Host "oops`n`t- Opens Notepad to edit command history."
        Write-Host "quiet`n`t- Minimizes the PowerShell prompt."
        Write-Host "redact`n`t- Removes the last issued command from the PowerShell history."
        Write-Host "repos`n`t- Locates the standard repos folder."
        Write-Host "shell`n`t- Starts the Shell."
        Write-Host "silence`n`t- Hides the PowerShell prompt."
        Write-Host "time`n`t- Displays local and UTC times."
        Write-Host "version`n`t- Displays the version of PowerShell and the Shell."
        Write-Host "weather`n`t- Displays the weather."
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
