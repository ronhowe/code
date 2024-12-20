function Debug-ValueFromPipeline {
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
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        foreach ($Item in $Items) {
            Write-Debug $Item
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}

Debug-ValueFromPipeline -Items 1 -Verbose -Debug

# DEBUG: Beginning Debug-ValueFromPipeline
# DEBUG: $Items = 1
# DEBUG: Processing Debug-ValueFromPipeline
# DEBUG: 1
# DEBUG: Ending Debug-ValueFromPipeline

Debug-ValueFromPipeline -Items @(1, 2) -Verbose -Debug

# DEBUG: Beginning Debug-ValueFromPipeline
# DEBUG: $Items = 1 2
# DEBUG: Processing Debug-ValueFromPipeline
# DEBUG: 1
# DEBUG: 2
# DEBUG: Ending Debug-ValueFromPipeline

@(1..2) | Debug-ValueFromPipeline -Verbose -Debug

# DEBUG: Beginning Debug-ValueFromPipeline
# DEBUG: $Items = 
# DEBUG: Processing Debug-ValueFromPipeline
# DEBUG: 1
# DEBUG: Processing Debug-ValueFromPipeline
# DEBUG: 2
# DEBUG: Ending Debug-ValueFromPipeline
