function Debug-Function {
    param (
        [switch]
        $Wait
    )

    Write-Output $Wait
}

Debug-Function
Debug-Function -Wait
