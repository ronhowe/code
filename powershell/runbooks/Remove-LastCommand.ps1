#requires -PSEdition "Core"

[CmdletBinding()]
param()

Write-Verbose "Getting History Save Path"
$filePath = (Get-PSReadLineOption).HistorySavePath
Write-Debug $filePath

Write-Verbose "Getting Last Command"
$lastCommand = (Get-History -Count 1).CommandLine
Write-Debug $lastCommand

Write-Verbose "Getting Content"
$content = Get-Content $filePath |
Where-Object { $_ -ne $lastCommand }

Write-Verbose "Setting Content"
Set-Content $filePath -Value $content
