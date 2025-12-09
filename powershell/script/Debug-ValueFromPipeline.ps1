function Debug-ValueFromPipeline {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]
        $Items
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    ## NOTE: process{} blocks not supported in Azure Automation runbooks for initial pipeline input.
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        foreach ($item in $Items) {
            Write-Output $item
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}

Debug-ValueFromPipeline -Items 1 -Verbose -Debug
Debug-ValueFromPipeline -Items 2 -Verbose -Debug

Debug-ValueFromPipeline -Items @(1, 2) -Verbose -Debug

@(1..2) | Debug-ValueFromPipeline -Verbose -Debug
