throw

#region dependencies
Get-Module -Name "Microsoft.PowerShell.SecretManagement" -ListAvailable
Get-Module -Name "Microsoft.PowerShell.SecretStore" -ListAvailable
Find-Module -Name "Microsoft.PowerShell.SecretManagement" -Repository "PSGallery"
Find-Module -Name "Microsoft.PowerShell.SecretStore" -Repository "PSGallery"
Install-Module -Name "Microsoft.PowerShell.SecretManagement" -Repository "PSGallery"
Install-Module -Name "Microsoft.PowerShell.SecretStore" -Repository "PSGallery"
#endregion dependencies

#region imports
Import-Module -Name "Microsoft.PowerShell.SecretManagement"
Import-Module -Name "Microsoft.PowerShell.SecretStore"
#endregion imports

#region reset
Reset-SecretStore -PassThru -Force
#endregion reset

#region register
Register-SecretVault -Name "ronhowe-secret-vault" -ModuleName "Microsoft.PowerShell.SecretStore" -DefaultVault
Get-SecretVault | Unregister-SecretVault
#endregion register

#region test secret
Set-Secret -Name "Test Secret" -Secret "Test Password" -Metadata @{ Description = "A Test Secret" }
Get-Secret -Name "Test Secret" -AsPlainText
Get-SecretInfo | Select-Object -Property *
#endregion test secret

#region scenarios
Set-Secret -Name "Administrator" -Secret $(Get-Credential) -Metadata @{ Description = "Administrator Credential" }
Get-Secret -Name "Administrator"

Set-Secret -Name "function-app-code" -Metadata @{ Description = "Function App API Code" }
Get-Secret -Name "function-app-code" -AsPlainText

Get-SecretInfo | Select-Object -Property *

$(Read-Host -Prompt "Enter Comma Separated Computers") -split "," |
ForEach-Object { [System.Net.Dns]::GetHostByName($_).HostName.ToUpper() }(Read-Host -Prompt "Enter Computer Name") |
Invoke-Command -Credential $(Get-Secret -Name "Administrator") -UseSSL -ScriptBlock { $env:COMPUTERNAME }
#endregion scenarios
