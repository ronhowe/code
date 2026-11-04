$files = @(
    "C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\ElvUI\Game\Shared\Media\SharedMedia.lua"
    "C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\ElvUI\Game\Shared\Media\SharedMedia.lua"
    "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\ElvUI\Game\Shared\Media\SharedMedia.lua"
)

$oldLine = "AddMedia('font','Invisible.ttf')"
$newLine = "AddMedia('font','Invisible.ttf',`t`t`t'INVISIBLE')"
$updates = @()

foreach ($file in $files) {
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
        throw "Required File Not Found: $file"
    }

    $content = [System.IO.File]::ReadAllText($file)
    if ($content.Contains($oldLine)) {
        $updates += [PSCustomObject]@{
            Path    = $file
            Content = $content.Replace($oldLine, $newLine)
            Changed = $true
        }
    }
    elseif ($content.Contains($newLine)) {
        $updates += [PSCustomObject]@{
            Path    = $file
            Content = $content
            Changed = $false
        }
    }
    else {
        throw "Expected Font Entry Was Not Found: $file"
    }
}

foreach ($update in $updates) {
    if ($update.Changed) {
        [System.IO.File]::WriteAllText($update.Path, $update.Content)
        Write-Host "Updated: $($update.Path)"
    }
    else {
        Write-Host "Already Updated: $($update.Path)"
    }
}
