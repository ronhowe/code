
function Set-PredictionInline {
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

        Set-PSReadLineOption -PredictionViewStyle InlineView -WarningAction SilentlyContinue -Verbose
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
