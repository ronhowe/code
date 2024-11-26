#requires -Module "ModuleBuilder"
#requires -PSEdition "Core"

[CmdletBinding()]
param (
)

$ErrorActionPreference = "Stop"
Write-Output "Running $($MyInvocation.MyCommand.Name)"

Write-Output "Importing Configuration"
. "$PSScriptRoot\Import-Configuration.ps1"

Write-Output "Removing Module Path"
Remove-Item -Path $modulePath -Recurse -Force -ErrorAction SilentlyContinue

Write-Output "Building Module"
$parameters = @{
    CopyPaths                  = @(
        "$sourcePath\$moduleName.json",
        "$sourcePath\$moduleName.nuspec",
        "$PSScriptRoot\..\..\dependencies\Dependencies.psd1",
        "$PSScriptRoot\..\..\dependencies\Dependencies.Tests.ps1",
        "$PSScriptRoot\..\..\dependencies\Install-Dependencies.ps1",
        "$PSScriptRoot\..\..\dependencies\Invoke-Dependencies.Tests.ps1",
        "$PSScriptRoot\LICENSE*",
        "$PSScriptRoot\README.md"
    )
    OutputDirectory            = $modulePath
    SourcePath                 = "$sourcePath\$moduleName.psd1"
    UnversionedOutputDirectory = $true
    Verbose                    = $false
    Version                    = $moduleVersion
}
Build-Module @parameters

Write-Output "Testing Module Path"
if (Test-Path -Path $modulePath) {
    Get-ChildItem -Path $modulePath -Recurse
}
else {
    Write-Error "Module Path Not Found"
}

if ($certificateThumbprint) {
    Write-Output "Getting Certificate"
    $certificate = Join-Path -Path $certificatePath -ChildPath $certificateThumbprint |
    Get-ChildItem

    Write-Output "Signing Module"
    Get-ChildItem -Path "$modulePath\$certificateThumbprint\*.ps*" |
    ForEach-Object {
        Set-AuthenticodeSignature -Certificate $certificate -FilePath $_
    } |
    Out-Null
}
else {
    Write-Output "Skipping Signing Module" -WarningAction Continue
}
