function Get-Weather {
    [CmdletBinding()]
    param (
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
    }
    process {
        $ProgressPreference = "SilentlyContinue"

        Write-Debug "Process $($MyInvocation.MyCommand.Name)"

        Invoke-Request -Uri "https://wttr.in/" -ContentOnly
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}
