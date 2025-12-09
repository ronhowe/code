Clear-Host

## NOTE: Invoke-Command does not apply VerbosePreference to ScriptBlock
## LINK: https://github.com/PowerShell/PowerShell/issues/4040

$scriptBlock = {
    [CmdletBinding()]
    param(
    )
    Write-Host "`$VerbosePreference = $VerbosePreference" -ForegroundColor DarkRed

    Write-Verbose "VERBOSE MESSAGE"
}

## NOTE: You should not see this.
Write-Host "TEST 1" -ForegroundColor DarkRed
Invoke-Command -ScriptBlock $scriptBlock -Verbose

## NOTE The workaround is to pass the VerbosePreference as a parameter.

$scriptBlock = {
    param(
        [Parameter(Mandatory = $false)]
        [ValidateSet("Continue", "SilentlyContinue")]
        [string]
        $CommandVerbosePreference = "SilentlyContinue"
    )
    Write-Host "`$VerbosePreference = $VerbosePreference" -ForegroundColor DarkGreen
    Write-Host "`$CommandVerbosePreference = $CommandVerbosePreference" -ForegroundColor DarkGreen

    $VerbosePreference = $CommandVerbosePreference
    Write-Verbose "VERBOSE MESSAGE"
}

Write-Host "TEST 2" -ForegroundColor DarkGreen
## NOTE: You should see VERBOSE MESSAGE because $ScriptBlockVerbosePreference is "Continue".
Invoke-Command -ScriptBlock $scriptBlock -ArgumentList @("Continue")
## NOTE: You should not see VERBOSE MESSAGE because $ScriptBlockVerbosePreference is "SilentlyContinue".
Invoke-Command -ScriptBlock $scriptBlock -ArgumentList @("SilentlyContinue")
