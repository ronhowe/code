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

            Write-Verbose "Installing ActiveDirectoryCSDsc Dsc Resource On $node"
            $scriptBlock = {
                $ProgressPreference = "SilentlyContinue"
                Install-Module -Name "ActiveDirectoryCSDsc" -RequiredVersion "5.0.0" -Repository "PSGallery" -Scope AllUsers -Force
            }
            Invoke-Command -Session $session -ScriptBlock $scriptBlock

            Write-Verbose "Installing ActiveDirectoryDsc Dsc Resource On $node"
            $scriptBlock = {
                $ProgressPreference = "SilentlyContinue"
                Install-Module -Name "ActiveDirectoryDsc" -RequiredVersion "6.6.0" -Repository "PSGallery" -Scope AllUsers -Force
            }
            Invoke-Command -Session $session -ScriptBlock $scriptBlock

            Write-Verbose "Installing ComputerManagementDsc Dsc Resource On $node"
            $scriptBlock = {
                $ProgressPreference = "SilentlyContinue"
                Install-Module -Name "ComputerManagementDsc" -RequiredVersion "9.2.0" -Repository "PSGallery" -Scope AllUsers -Force
            }
            Invoke-Command -Session $session -ScriptBlock $scriptBlock

            Write-Verbose "Installing NetworkingDsc Dsc Resource On $node"
            $scriptBlock = {
                $ProgressPreference = "SilentlyContinue"
                Install-Module -Name "NetworkingDsc" -RequiredVersion "9.0.0" -Repository "PSGallery" -Scope AllUsers -Force
            }
            Invoke-Command -Session $session -ScriptBlock $scriptBlock

            Write-Verbose "Installing SqlServerDsc Dsc Resource On $node"
            $scriptBlock = {
                $ProgressPreference = "SilentlyContinue"
                Install-Module -Name "SqlServerDsc" -RequiredVersion "17.0.0" -Repository "PSGallery" -Scope AllUsers -Force
            }
            Invoke-Command -Session $session -ScriptBlock $scriptBlock

            Write-Verbose "Removing PSSession To $node"
            $session |
            Remove-PSSession
        }
    }
    end {
        Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
    }
}
