function Install-GuestDscResources {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullorEmpty()]
        [string[]]
        $Nodes,
    
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [pscredential]
        $Credential
    )
    begin {
        Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
    }
    process {
        Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

        foreach ($node in $Nodes) {
            Write-Verbose "Getting PSSession To $node"
            $session = New-PSSession -ComputerName $node -Credential $Credential

            Write-Verbose "Installing Nuget Package Provider On $node"
            $scriptBlock = {
                $ProgressPreference = "SilentlyContinue"
                Install-PackageProvider -Name "nuget" -Force |
                Out-Null
            }
            Invoke-Command -Session $session -ScriptBlock $scriptBlock

            Write-Verbose "Installing Dsc Resources On $node"
            @(
                "ActiveDirectoryCSDsc",
                "ActiveDirectoryDsc",
                "ComputerManagementDsc",
                "NetworkingDsc",
                "PSWindowsUpdate",
                "SqlServerDsc"
            ) |
            ForEach-Object {
                Write-Verbose "Installing Dsc Resource $_ On $node"
                $scriptBlock = {
                    $ProgressPreference = "SilentlyContinue"
                    Install-Module -Name $using:_ -Scope AllUsers -Repository "PSGallery" -Force
                }
                Invoke-Command -Session $session -ScriptBlock $scriptBlock
            }

            Write-Verbose "Removing PSSession To $node"
            $session |
            Remove-PSSession
        }
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
