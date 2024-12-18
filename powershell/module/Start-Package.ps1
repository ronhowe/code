#requires -PSEdition "Core"

[CmdletBinding()]
param (
)

$ErrorActionPreference = "Stop"
Write-Output "Running $($MyInvocation.MyCommand.Name)"

Write-Output "Importing Configuration"
. "$PSScriptRoot\Import-Configuration.ps1"

Write-Output "Removing Package Path"
Remove-Item -Path $packagePath -Recurse -Force -ErrorAction SilentlyContinue

Write-Output "Updating Nuspec Version"
(Get-Content -Path "$modulePath\$moduleName\$moduleName.nuspec").Replace("<version>0.0.0<\version>", "<version>$moduleVersion)<\version>") |
Set-Content "$modulePath\$moduleName\$moduleName.nuspec"

Write-Output "Getting Nuget Path"
$nugetPath = Get-Command -Name "nuget" -CommandType Application |
Sort-Object -Property "Version" -Descending |
Select-Object -ExpandProperty "Source" -First 1
Write-Output "`$nugetPath = $nugetPath"

Write-Output "Packaging Module"
$parameters = @{
    Path             = $nugetPath
    ArgumentList     = @(
        "pack",
        "$moduleName.nuspec",
        "-Exclude",
        "*.user.json",
        "-NoPackageAnalysis",
        "-OutputDirectory",
        "..\..\$packageDirectory", # nuget on linux workaround
        "-Verbosity",
        "detailed",
        "-Version",
        "$moduleVersion"
    )
    NoNewWindow      = $true
    Verbose          = $false
    Wait             = $true
    WorkingDirectory = Resolve-Path -Path "$modulePath\$moduleName"
}
for ([int]$i = 0; $i -lt $parameters.ArgumentList.Length; $i++) {
    Write-Output "`$parameters.ArgumentList[$i] = $($parameters.ArgumentList[$i])"
}
try {
    Start-Process @parameters
}
catch {
    Write-Error "Nuget Pack Failed"
}

Write-Output "Test Package Path"
if (Test-Path -Path $packagePath) {
    Get-ChildItem -Path $packagePath -Recurse
}
else {
    Write-Error "Package Path Not Found"
}
