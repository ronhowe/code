function Import-ShellConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path -Path $_ })]
        [string]$Path
    )
    begin {
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        try {
            Write-Verbose "Adding Shell Configuration Sources"
            @(
                "$PSScriptRoot\Shell.json",
                "$HOME\Shell.json",
                $Path
            ) |
            ForEach-Object {
                Write-Debug "`$_ = $_"
                Write-Verbose "Asserting Shell Configuration Source Exists"
                if (Test-Path -Path $_) {
                    Write-Verbose "Adding Shell Configuration Source"
                    $config = Get-Content -Path $_ |
                    ConvertFrom-Json

                    Write-Verbose "Defining Shell Configuration Global Variable"
                    New-Variable -Name "ShellConfig" -Value $config -Force -Scope "Global"
                }
                else {
                    Write-Verbose "Shell Configuration Source Not Found"
                }
            }
        }
        catch {
            Write-Error "Import Failed Because $($_.Exception.Message)"
        }
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}