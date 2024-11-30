function Debug-Function {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]
        $Items
    )
    begin {
        Write-Output "begin {}"
    }
    process {
        Write-Output "process {} begin"
        foreach ($Item in $Items) {
            Write-Output $Item
        }
        Write-Output "process {} end"
    }
    end {
        Write-Output "end {}"
    }
}

Debug-Function -Items 1

Debug-Function -Items @(1, 2)

@(1..2) | Debug-Function
