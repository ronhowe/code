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
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    foreach ($node in $Nodes) {
        Write-Host "Creating PSSession To $node"
        $session = New-PSSession -ComputerName $node -Credential $Credential

        $scriptBlock = {
            $ProgressPreference = "SilentlyContinue"

            Write-Host "Installing Nuget Package Provider On $env:COMPUTERNAME"
            Install-PackageProvider -Name "nuget" -Force |
            Out-Null

            Write-Host "Installing ActiveDirectoryCSDsc Resource On $env:COMPUTERNAME"
            Install-Module -Name "ActiveDirectoryCSDsc" -RequiredVersion "5.0.0" -Repository "PSGallery" -Scope AllUsers -Force

            Write-Host "Installing ActiveDirectoryDsc Resource On $env:COMPUTERNAME"
            Install-Module -Name "ActiveDirectoryDsc" -RequiredVersion "6.7.0" -Repository "PSGallery" -Scope AllUsers -Force

            Write-Host "Installing ComputerManagementDsc Resource On $env:COMPUTERNAME"
            Install-Module -Name "ComputerManagementDsc" -RequiredVersion "10.0.0" -Repository "PSGallery" -Scope AllUsers -Force

            Write-Host "Installing NetworkingDsc Resource On $env:COMPUTERNAME"
            Install-Module -Name "NetworkingDsc" -RequiredVersion "9.1.0" -Repository "PSGallery" -Scope AllUsers -Force

            Write-Host "Installing SecurityPolicyDsc Resource On $env:COMPUTERNAME"
            Install-Module -Name "SecurityPolicyDsc" -RequiredVersion "2.10.0.0" -Repository "PSGallery" -Scope AllUsers -Force

            Write-Host "Installing SqlServerDsc Resource On $env:COMPUTERNAME"
            Install-Module -Name "SqlServerDsc" -RequiredVersion "17.2.0" -Repository "PSGallery" -Scope AllUsers -Force
        }
        Invoke-Command -Session $session -ScriptBlock $scriptBlock

        Write-Host "Removing PSSession To $node"
        $session |
        Remove-PSSession
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
