function Debug-ValueFromPipeline {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]
        $Items
    )
    begin {
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    ## NOTE: process{} blocks not supported in Azure Automation runbooks for initial pipeline input.
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        foreach ($item in $Items) {
            Write-Output $item
        }
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}

Debug-ValueFromPipeline -Items 1 -Verbose -Debug
Debug-ValueFromPipeline -Items 2 -Verbose -Debug

Debug-ValueFromPipeline -Items @(1, 2) -Verbose -Debug

@(1..2) | Debug-ValueFromPipeline -Verbose -Debug
