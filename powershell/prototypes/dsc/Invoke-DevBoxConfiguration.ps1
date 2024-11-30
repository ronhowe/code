#requires -PSEdition Desktop
#requires -RunAsAdministrator

. .\DevBoxConfiguration.ps1
DevBoxConfiguration -OutputPath $env:TEMP
Start-DscConfiguration -Path $env:TEMP -Wait -Force -Verbose
