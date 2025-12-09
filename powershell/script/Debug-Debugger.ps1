function Debug-Debugger {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Message = "OK"
    )
    begin {
        Write-Host "BEFORE `$DebugPreference = $DebugPreference" -ForegroundColor DarkCyan

        if ($PSBoundParameters.ContainsKey("Debug")) {
            $DebugPreference = "Continue"
        }

        Write-Host "AFTER `$DebugPreference = $DebugPreference" -ForegroundColor Cyan

        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Write-Verbose "Doing Something ; Please Wait"

        Write-Host $Message -ForegroundColor Green
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
Clear-Host
Wait-Debugger
Debug-Debugger
Debug-Debugger -Verbose
Debug-Debugger -Debug
Debug-Debugger -Verbose -Debug
