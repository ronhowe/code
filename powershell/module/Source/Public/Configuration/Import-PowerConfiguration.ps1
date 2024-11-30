# function Import-PowerConfiguration {
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory = $true)]
#         [ValidateNotNullOrEmpty()]
#         [string]$Name,

#         [Parameter(Mandatory = $false)]
#         [ValidateNotNullOrEmpty()]
#         [ValidateScript({ Test-Path -Path $_ })]
#         [string]$Path
#     )
#     begin {
#         Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

#         Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
#         Select-Object -Property @("Name", "Value") |
#         ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
#     }
#     process {
#         Write-Debug "Process$($MyInvocation.MyCommand.Name)"

#         try {
#             Write-Verbose "Newing PowerConfig"
#             $powerConfig = New-PowerConfig

#             Write-Verbose "Adding Module PowerConfig Json Source"
#             $powerConfig |
#             Add-PowerConfigJsonSource -Path "$PSScriptRoot\$Name.json"
#             Out-Null

#             Write-Verbose "TestingHomePowerConfigJsonSource"
#             if (Test-Path -Path "~\$Name.json") {
#                 Write-Verbose "AddingHomePowerConfigJsonSource"
#                 #
#                 $powerConfig |
#                 Add-PowerConfigJsonSource -Path $Path |
#                 Out-Null
#             }

#             Write-Verbose "TestingCustomPowerConfigJsonSource"
#             if (Test-Path -Path "$Path\$Name.json") {
#                 Write-Verbose "AddingCustomPowerConfigJsonSource"

#                 $powerConfig |
#                 Add-PowerConfigJsonSource -Path "$Path\$Name.json" |
#                 Out-Null
#             }
#             Write-Verbose "GettingPowerConfig"

#             $value = $powerConfig |
#             Get-PowerConfig

#             Write-Verbose "NewingConfigurationGlobalVariable"

#             New-Variable -Name "$Name`Configuration" -Value $value -Force -Scope Script

#             return $value
#         }
#         catch {
#             Write-Error $_
#         }
#     }
#     end {
#         Write-Debug "End $($MyInvocation.MyCommand.Name)"
#     }
# }