function Import-ShellPowerConfiguration {
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
            Write-Verbose "Creating New Shell Configuration Builder"
            $configBuilder = New-PowerConfig

            Write-Verbose "Adding Shell Configuration Sources"
            @(
                "$PSScriptRoot\Shell.json",
                "$HOME\Shell.json",
                $Path
            ) |
            Where-Object { $_ -and $_ -ne ""} |
            ForEach-Object {
                Write-Debug "`$_ = $_"
                Write-Verbose "Asserting Shell Configuration Source Exists"
                if (Test-Path -Path $_) {
                    Write-Verbose "Adding Shell Configuration Source"
                    $configBuilder |
                    Add-PowerConfigJsonSource -Path $_ |
                    Out-Null
                }
                else {
                    Write-Verbose "Shell Configuration Source Not Found"
                }
            }

            Write-Verbose "Building Shell Configuration"
            $config = $configBuilder |
            Get-PowerConfig
            Write-Debug "`$config = $config"

            Write-Verbose "Defining Shell Configuration Global Variable"
            New-Variable -Name "ShellConfig" -Value $config -Force -Scope "Global"

            Write-Verbose "Returning Shell Configuration"
            return $config
        }
        catch {
            Write-Error "Import Failed Because $($_.Exception.Message)"
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
