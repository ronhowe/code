$ScriptBlock = {
    [CmdletBinding()]
    param()
    Write-Verbose "Verbose Message"
}

# Does not work.
# Invoke-Command does not apply VerbosePreference to ScriptBlock
# https://github.com/PowerShell/PowerShell/issues/4040
Invoke-Command -ScriptBlock $ScriptBlock -Verbose

$ScriptBlock = {
    param(
        [ValidateSet("Continue", "SilentlyContinue")]
        [string]
        $VerbosePreference = "SilentlyContinue"
    )
    $VerbosePreference = $VerbosePreference
    Write-Verbose "Verbose Message"
}

# Workaround.
Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList "Continue"
Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList "SilentlyContinue"
