function Get-Weather {
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

        $ProgressPreference = "SilentlyContinue"

        Invoke-Request -Uri "https://wttr.in/" -ContentOnly
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}