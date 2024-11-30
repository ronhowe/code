# function Import-PowerConfiguration {
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory = $true)]
#         [ValidateNotNullOrEmpty()]
#         [string]$Name,

#         [Parameter(Mandatory = $false)]
#         [ValidateNotNullOrEmpty()]
#         [ValidateScript({ Test-Path -Path $_ })]
#         [string]$Path,

#         [Parameter()]
#         [switch]$Force
#     )
#     begin {
#         Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

#         Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
#         Select-Object -Property @("Name", "Value") |
#         ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
#     }
#     process {
#         Write-Debug "Process $($MyInvocation.MyCommand.Name)"

#         if ($Path) {
#             $destination = $Path
#         }
#         else {
#             $destination = "~\$Name.json"
#         }
#         Write-Debug "`$destination=$destination"

#         Write-Verbose "Copying PowerConfig Json Source"
#         Copy-Item -Path "$PSScriptRoot\$Name.json" -Destination $destination -Force:$Force

#         Write-Verbose "Importing PowerConfig Json Source"
#         Import-PowerConfiguration -Name $Name -Path $destination
#     }
#     end {
#         Write-Debug "End $($MyInvocation.MyCommand.Name)"
#     }
# }