#requires -module "PSWindowsUpdate"
#requires -RunAsAdministrator

Write-Host "Getting Windows Updates"
Get-WindowsUpdate -Verbose

# todo - too many hardware drives come back to trust going any further without proper filtering

