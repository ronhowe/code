function Import-ShellConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path -Path $_ })]
        [string]
        $Path
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        try {
            Write-Verbose "Adding Shell Configuration Sources"
            @(
                "$PSScriptRoot\Shell.json",
                "$HOME\Shell.json",
                $Path
            ) |
            Where-Object { $_ -and $_ -ne "" } |
            ForEach-Object {
                Write-Debug "`$_ = $_"
                Write-Verbose "Asserting Shell Configuration Source Exists"
                if (Test-Path -Path $_) {
                    Write-Verbose "Adding Shell Configuration Source"
                    $global:ShellConfig = Get-Content -Path $_ |
                    ConvertFrom-Json
                }
                else {
                    Write-Verbose "Shell Configuration Source Not Found"
                }
            }
        }
        catch {
            Write-Error "Import Failed Because $($_.Exception.Message)"
        }

        try {
            Write-Verbose "Adding Shell Configuration Sources"
            @(
                "$HOME\repos\ronhowe\azure\parameters.json"
            ) |
            Where-Object { $_ -and $_ -ne "" } |
            ForEach-Object {
                Write-Debug "`$_ = $_"
                Write-Verbose "Asserting Azure Shell Configuration Source Exists"
                if (Test-Path -Path $_) {
                    Write-Verbose "Importing Azure Shell Configuration"
                    Import-ShellAzureConfiguration -Path $_ |
                    Out-Null
                }
                else {
                    Write-Verbose "Azure Shell Configuration Source Not Found"
                }
            }
        }
        catch {
            Write-Error "Import Failed Because $($_.Exception.Message)"
        }

        Write-Verbose "Returning Shell Configuration"
        return $global:ShellConfig
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
