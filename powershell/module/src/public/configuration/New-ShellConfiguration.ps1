function New-ShellConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path = "$HOME\Shell.json"
    )
    begin {
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        Write-Verbose "Copying Shell Configuration"
        Copy-Item -Path "$PSScriptRoot\Shell.json" -Destination $Path -Force
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}