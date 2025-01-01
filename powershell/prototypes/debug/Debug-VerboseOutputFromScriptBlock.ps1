## NOTE: Invoke-Command does not apply VerbosePreference to ScriptBlock
## LINK: https://github.com/PowerShell/PowerShell/issues/4040

Clear-Host

$scriptBlock = {
    [CmdletBinding()]
    param()
    ## NOTE: You should not see this.
    Write-Verbose "`$VerbosePreference = $VerbosePreference"
}

Invoke-Command -ScriptBlock $scriptBlock -Verbose

$scriptBlock = {
    param(
        [ValidateSet("Continue", "SilentlyContinue")]
        [string]
        $ScriptBlockVerbosePreference = "SilentlyContinue"
    )
    ## NOTE: You should see these if $ScriptBlockVerbosePreference is "Continue".
    $VerbosePreference = $ScriptBlockVerbosePreference
    Write-Verbose "`$VerbosePreference = $VerbosePreference"
    Write-Verbose "`$ScriptBlockVerbosePreference = $ScriptBlockVerbosePreference"
}

Invoke-Command -ScriptBlock $scriptBlock -ArgumentList @("Continue")
