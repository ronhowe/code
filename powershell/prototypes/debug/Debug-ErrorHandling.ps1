#requires -PSEdition Core
function Debug-Function {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path -Path $_ })]
        [string]$Path = "$PSScriptRoot\image.png"
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }

        # $ErrorActionPreference = "Stop"
        # $ProgressPreference = "SilentlyContinue"
        # $WarningPreference = "SilentlyContinue"
    }
    process {
        Write-Debug "Process $($MyInvocation.MyCommand.Name)"
        try {

            Write-Verbose "CallingNativeCommand"
            # throw "NoSoupForYouException"
            pwsh.exe --version
            if ($LASTEXITCODE -ne 0) {
                Write-Error "NativeCommandCallException"
            }
            Not-AFunction
        }
        catch {
            # colors are not a way to indicate failure
            # Write-Host "DontDoThisVeryBadErrorHandlingException" -ForegroundColor Red
            Write-Error $_.Exception.Message
            # Write-Error $_.Exception.Message
            # Send-MailMessage -SmtpServer OPSSMTP01.IDI.COM -To rhowe@idibilling.com -From rhowe@idibilling.com -Subject "test" -Body "hello world" -Verbose
        }
        finally  {
            Write-Host "AWLAYS RUNS" -ForegroundColor Yellow
        }
        Write-Host "OK" -ForegroundColor Green
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}
Clear-Host
Debug-Function
# Debug-Function -InformationAction Continue -WarningAction Continue -ErrorAction Stop -Debug -Verbose
# Debug-Function -InformationAction Continue -WarningAction Continue -ErrorAction Continue -Debug -Verbose
# Debug-Function -InformationAction Continue -WarningAction Continue -ErrorAction SilentlyContinue -Debug -Verbose
Write-Host "DONE" -ForegroundColor Blue
