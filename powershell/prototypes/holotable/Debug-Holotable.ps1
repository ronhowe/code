#requires -PSEdition Core

#region setup

Clear-Host

Set-Location -Path "~\repos\ronhowe\powershell\holotable"

Import-Module -Name ".\Holotable.psm1" -Force -Verbose

$vscodePath = "C:\Users\ronhowe\AppData\Local\Programs\Microsoft VS Code\Code.exe"

#endregion setup

#region export dark side

Write-Verbose "Exporting Dark Side CDF"
$parameters = @{
    JsonPath       = "~\repos\ronhowe\swccg-card-json\Dark.json"
    JsonLegacyPath = "~\repos\ronhowe\swccg-card-json\DarkLegacy.json"
    JsonSetsPath   = "~\repos\ronhowe\swccg-card-json\sets.json"
    CdfPath        = "~\repos\ronhowe\powershell\holotable\darkside.cdf"
    # IdFilter       = 634 # Darth Vader (Premiere)
    # SetFilter      = "*17*"
    # TitleFilter    = "*Darth Vader*"
    # TypeFilter     = "Objective"
}
Export-Cdf @parameters

#endregion export dark side

#region diff dark side

Write-Verbose "Diffing Dark Side CDF"
$parameters = @{
    Path         = $vscodePath
    ArgumentList = @(
        "--diff",
        (Resolve-Path -Path "~\repos\ronhowe\holotable\darkside.cdf"),
        (Resolve-Path -Path "~\repos\ronhowe\powershell\holotable\darkside.cdf")
    )
    NoNewWindow  = $true
    Wait         = $true
}
Start-Process @parameters

#endregion diff dark side

#region export light side

Write-Verbose "Exporting Light Side CDF"
$parameters = @{
    JsonPath       = "~\repos\ronhowe\swccg-card-json\Light.json"
    JsonLegacyPath = "~\repos\ronhowe\swccg-card-json\LightLegacy.json"
    JsonSetsPath   = "~\repos\ronhowe\swccg-card-json\sets.json"
    CdfPath        = "~\repos\ronhowe\powershell\holotable\lightside.cdf"
    # IdFilter       = 1593 # Luke Skywalker (Premiere)
    # SetFilter      = "*17*"
    # TitleFilter    = "*Luke Skywalker*"
    # TypeFilter     = "Objective"
}
Export-Cdf @parameters

#endregion export light side

#region diff light side

Write-Verbose "Diffing Light Side CDF"
$parameters = @{
    Path         = $vscodePath
    ArgumentList = @(
        "--diff",
        (Resolve-Path -Path "~\repos\ronhowe\holotable\lightside.cdf"),
        (Resolve-Path -Path "~\repos\ronhowe\powershell\holotable\lightside.cdf")
    )
    NoNewWindow  = $true
    Wait         = $true
}
Start-Process @parameters

#endregion diff light side

#region dark side stats

Write-Verbose "Getting Dark Side Statistics..."
Get-Content -Path "~\repos\ronhowe\swccg-card-json\Dark.json" |
ConvertFrom-Json |
Select-Object -ExpandProperty "cards" |
Measure-Object -Property id -Minimum -Maximum |
Select-Object -Property @{Name = "Side"; Expression = { "Dark" } }, @{Name = "Total Cards"; Expression = { $_.Count } }, @{Name = "Minimum Id"; Expression = { $_.Minimum } }, @{Name = "Maximum Id"; Expression = { $_.Maximum } }

#endregion dark side stats

#region light side stats

Write-Verbose "Getting Light Side Statistics..."
Get-Content -Path "~\repos\ronhowe\swccg-card-json\Light.json" |
ConvertFrom-Json |
Select-Object -ExpandProperty "cards" |
Measure-Object -Property id -Minimum -Maximum |
Select-Object -Property @{Name = "Side"; Expression = { "Light" } }, @{Name = "Total Cards"; Expression = { $_.Count } }, @{Name = "Minimum Id"; Expression = { $_.Minimum } }, @{Name = "Maximum Id"; Expression = { $_.Maximum } }

#endregion light side stats
