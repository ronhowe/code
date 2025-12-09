#requires -Module "WriteAscii"
function Write-Header {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Header
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Write-Host ("#" * 80) -ForegroundColor Blue
        Write-Ascii $Header
        Write-Host ("#" * 80) -ForegroundColor Blue
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
