
<#
    .SYNOPSIS
    This script copies local Holotable repo files to the installed Holotable client location.

    .DESCRIPTION
    This script copies local Holotable repo files to the installed Holotable client location.

    .PARAMETER $Path
    The path to the local Holotable repo.

    .PARAMETER $IncludeImages
    Whether or not to copy the image files.
#>
[CmdletBinding()]
param(
    [string]
    $Path = "~\repos\ronhowe\powershell\holotable",

    [switch]
    $IncludeImages
)

if (-not (Test-Path -Path $Path)) {
    Write-Error "Cannot find $Path." -ErrorAction Stop
}

if (-not (Test-Path -Path $env:HOLOTABLE_PATH)) {
    Write-Error "Cannot find HOLOTABLE_PATH environment variable or path." -ErrorAction Stop
}

Copy-Item -Path (Join-Path -Path $Path -ChildPath "*.cdf") -Destination $env:HOLOTABLE_PATH -Force -PassThru

# Only needed if file hashes are incorrect.
if ($IncludeImages) {
    Copy-Item -Path (Join-Path -Path $Path -ChildPath "Images-HT\starwars") -Destination (Join-Path -Path $env:HOLOTABLE_PATH -ChildPath "cards") -Recurse -Force -PassThru
}
