@(
    "C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\FontMagic\FontMagic_MinimapRing_Best_64.tga"
    "C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\FontMagic\FontMagic_MinimapIcon_Best_64.tga",
    "C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\FontMagic\FontMagic_MinimapRing_Best_64.tga",
    "C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\FontMagic\FontMagic_MinimapIcon_Best_64.tga",
    "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\FontMagic\FontMagic_MinimapIcon_Best_64.tga",
    "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\FontMagic\FontMagic_MinimapRing_Best_64.tga"
) | ForEach-Object {
    if (Test-Path -Path $_) {
        Remove-Item -Path $_ -Force
        Write-Host "Removed: $_"
    }
    else {
        Write-Host "File Not Found: $_"
    }
}
