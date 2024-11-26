#requires -PSEdition "Core"
#requires -Module "Pester"
Write-Output "Importing Configuration"

Write-Output "Importing Configuration"
. "$PSScriptRoot\Import-Configuration.ps1" -Debug -Verbose

Write-Output "Installing Dependencies"
& "$PSScriptRoot\..\..\dependencies\Install-Dependencies.ps1" -Debug -Verbose

Write-Output "Testing Dependencies"
Invoke-Pester -Path "$PSScriptRoot\..\..\dependencies\Invoke-Dependencies.Tests.ps1" -Output Detailed -PassThru |
New-Variable -Name "result" -Force
if ($result.FailedCount -gt 0) {
    Write-Error "Dependencies Tests Failed"
}

Write-Output "Removing Output"
Remove-Item -Path $outputPath -Recurse -Force -ErrorAction SilentlyContinue

Write-Output "Starting Build"
& "$PSScriptRoot\Start-Build.ps1" -Debug -Verbose

Write-Output "Testing Module"
Invoke-Pester -Path "$PSScriptRoot\Invoke-Tests.ps1" -Output Detailed -PassThru |
New-Variable -Name "result" -Force
if ($result.FailedCount -gt 0) {
    Write-Error "Module Tests Failed"
}

Write-Output "Starting Package"
& "$PSScriptRoot\Start-Package.ps1" -Debug -Verbose

Write-Output "Unregistering Repository"
Unregister-PSRepository -Name $moduleName -ErrorAction SilentlyContinue

Write-Output "Registering Repository"
Register-PSRepository -Name $moduleName -SourceLocation $packagePath -InstallationPolicy Trusted |
Out-Null

Write-Output "Removing Module"
Get-Module -Name $moduleName |
Remove-Module -Force

Write-Output "Finding Module"
Find-Module -Name $moduleName -RequiredVersion $moduleVersion -Repository $moduleName -WarningAction SilentlyContinue

Write-Output "Installing Module"
Install-Module -Name $moduleName -RequiredVersion $moduleVersion -Repository $moduleName -Scope CurrentUser -AllowClobber -Force -WarningAction SilentlyContinue

Write-Output "Importing Module"
Import-Module -Name $moduleName -RequiredVersion $moduleVersion -Force -WarningAction SilentlyContinue
