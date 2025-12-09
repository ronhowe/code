function Show-ShellConfiguration {
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

        Write-Verbose "Showing Shell Configuration"
        $global:ShellConfig |
        Out-String |
        Write-Host
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
