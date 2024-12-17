## TODO: Add erase to profile.
$filePath = (Get-PSReadLineOption).HistorySavePath
$lastCommand = (Get-History -Count 1).CommandLine
$content = Get-Content $filePath | Where-Object { $_ -ne $lastCommand }
Set-Content $filePath -Value $content
