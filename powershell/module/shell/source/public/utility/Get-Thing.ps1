function Get-Thing {
    [CmdletBinding()]
    [OutputType([string[]])]
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

        Write-Verbose "Getting Something ; Please Wait"

        @(
            [ordered]@{ "Thing" = "Nothing" }
            [ordered]@{ "Thing" = "Something" }
        ) |
        ForEach-Object {
            [PSCustomObject]$_
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
