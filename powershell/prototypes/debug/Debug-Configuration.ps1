throw

#region dependencies
Get-Module -Name "PowerConfig" -ListAvailable
Find-Module -Name "PowerConfig" -Repository "PSGallery"
Install-Module -Name "PowerConfig" -Repository "PSGallery" -Force
#endregion dependencies

#region imports
Import-Module -Name "PowerConfig"
#endregion imports

#region demo
# https://github.com/JustinGrote/PowerConfig/blob/main/Demo/PowerConfigDemo.ps1
$PowerConfig = New-PowerConfig
$PowerConfig | Add-PowerConfigJsonSource -Path "$PSScriptRoot\Configuration.json" | Out-Null
if (Test-Path -Path "$PSScriptRoot\Configuration.user.json" -ErrorAction SilentlyContinue) {
    $PowerConfig | Add-PowerConfigJsonSource -Path "$PSScriptRoot\Configuration.user.json" | Out-Null
}
$MyConfiguration = $PowerConfig | Get-PowerConfig
# Suppresses PSScriptAnalyzer(PSUseDeclaredVarsMoreThanAssignments).
$MyConfiguration | Out-Null
#endregion demo