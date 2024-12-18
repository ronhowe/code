#requires -Module "ModuleBuilder"
#requires -PSEdition "Core"

[CmdletBinding()]
param (
)

$ErrorActionPreference = "Stop"
Write-Output "Running $($MyInvocation.MyCommand.Name)"

Write-Output "Importing Build Definition"
$buildDefinition = Import-PowerShellDataFile -Path "$PSScriptRoot\Build.psd1"
$moduleDirectory = $buildDefinition.ModuleDirectory
$outputDirectory = $buildDefinition.OutputDirectory
$packageDirectory = $buildDefinition.PackageDirectory
$sourceDirectory = $buildDefinition.SourceDirectory
$testsDirectory = $buildDefinition.TestsDirectory
Write-Output "`$moduleDirectory = $moduleDirectory"
Write-Output "`$outputDirectory = $outputDirectory"
Write-Output "`$packageDirectory = $packageDirectory"
Write-Output "`$sourceDirectory = $sourceDirectory"
Write-Output "`$testsDirectory = $testsDirectory"

Write-Output "Importing Certificate Definition"
$certificateDefinition = Import-PowerShellDataFile -Path "$PSScriptRoot\Certificate.psd1"
$certificatePath = $certificateDefinition.Path
$certificateThumbprint = $cercertificateDefinitionificate.Thumbprint
Write-Output "`$certificatePath = $certificatePath"
Write-Output "`$certificateThumbprint = $certificateThumbprint"

Write-Output "Importing Module Definition"
$moduleDefinition = Import-PowerShellDataFile -Path "$PSScriptRoot\Module.psd1"
$moduleName = $moduleDefinition.Name
$moduleVersion = $moduleDefinition.Version
Write-Output "`$moduleName = $moduleName"
Write-Output "`$moduleVersion = $moduleVersion"

Write-Output "Setting Output Path"
$outputPath = "$PSScriptRoot\$outputDirectory"
Write-Output "`$outputPath = $outputPath"

Write-Output "Setting Module Path"
$modulePath = "$outputPath\$moduleDirectory"
Write-Output "`$modulePath = $modulePath"

Write-Output "Setting Package Path"
$packagePath = "$outputPath\$packageDirectory"
Write-Output "`$packagePath = $packagePath"

Write-Output "Setting Source Path"
$sourcePath = "$PSScriptRoot\$sourceDirectory"
Write-Output "`$sourcePath = $sourcePath"

Write-Output "Setting Tests Path"
$testsPath = "$PSScriptRoot\$testsDirectory"
Write-Output "`$testsPath = $testsPath"
