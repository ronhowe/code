[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$InputPath = "$HOME\OneDrive\Pictures",

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = "E:\TEST" # "$HOME\OneDrive\Media"
)

if (!(Test-Path $InputPath)) {
    Write-Error "Input path does not exist."
    return
}

if (!(Test-Path $OutputPath)) {
    Write-Error "Output path does not exist."
    return
}

Get-ChildItem -Path $InputPath -Recurse |
Where-Object { $_.Extension -ne ".db" } |
# Select-Object -First 1000 |
ForEach-Object {
    if ($_.PSIsContainer) {
        return
    }

    $oldFilePath = $_.FullName
    Write-Debug "`$oldFilePath = $oldFilePath"

    $oldFolderPath = $_.Directory.FullName
    Write-Debug "`$oldFolderPath = $oldFolderPath"

    $oldFileName = $_.Name
    Write-Debug "`$oldFileName = $oldFileName"

    $oldFileExtension = $_.Extension
    Write-Debug "`$oldFileExtension = $oldFileExtension"

    $oldFileLastWriteTime = $_.LastWriteTime
    Write-Debug "`$oldFileLastWriteTime = $oldFileLastWriteTime"

    $newFolderName = $oldFileLastWriteTime.ToString("yyyy-MM")
    Write-Debug "`$newFolderName = $newFolderName"

    $newFolderPath = Join-Path -Path $OutputPath -ChildPath $newFolderName
    Write-Debug "`$newFolderPath = $newFolderPath"

    $newFileName = $oldFileLastWriteTime.ToString("yyyy-MM-dd_HH-mm-ss") + $oldFileExtension
    Write-Debug "`$newFileName = $newFileName"

    $newFilePath = Join-Path -Path $newFolderPath -ChildPath $newFileName
    Write-Debug "`$newFilePath = $newFilePath"

    if (!(Test-Path $newFolderPath)) {
        New-Item -ItemType Directory -Path $newFolderPath | Out-Null
    }

    if (Test-Path $newFilePath) {
        $newFileName = $oldFileLastWriteTime.ToString("yyyy-MM-dd_HH-mm-ss") + "_" + $(New-Guid) + $oldFileExtension
        Write-Debug "`$newFileName = $newFileName"

        $newFilePath = Join-Path -Path $newFolderPath -ChildPath $newFileName
        Write-Debug "`$newFilePath = $newFilePath"
    }

    Copy-Item -Path $oldFilePath -Destination $newFilePath -Verbose

    if ($InputPath -ne $oldFolderPath) {
        $oldFolderPath.Substring($InputPath.Length + 1).Replace("'", "").Replace(",", "").ToLower().Split("\") |
        ForEach-Object {
            $newFileName = $_ + ".txt"
            Write-Debug "`$newFileName = $newFileName"

            $newFilePath = Join-Path -Path $newFolderPath -ChildPath $newFileName
            Write-Debug "`$newFilePath = $newFilePath"

            if (-not (Test-Path -Path $newFilePath)) {
                New-Item -ItemType File -Path $newFilePath -Verbose | Out-Null
            }
        }
    }
}
