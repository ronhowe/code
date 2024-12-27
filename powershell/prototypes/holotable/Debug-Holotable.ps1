#requires -PSEdition Core
[CmdletBinding()]
param(
)
begin {
    Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"

    Import-Module -Name "$HOME\repos\ronhowe\code\powershell\prototypes\holotable\Holotable.psm1" -Force

    # $vscodePath = "C:\Users\ronhowe\AppData\Local\Programs\Microsoft VS Code\Code.exe"

    Write-Verbose "Exporting Dark Side CDF"
    $parameters = @{
        JsonPath       = "$HOME\repos\ronhowe\swccg-card-json\Dark.json"
        JsonLegacyPath = "$HOME\repos\ronhowe\swccg-card-json\DarkLegacy.json"
        JsonSetsPath   = "$HOME\repos\ronhowe\swccg-card-json\sets.json"
        CdfPath        = "$HOME\repos\ronhowe\code\powershell\prototypes\holotable\darkside.cdf"
        # IdFilter       = 634 # Darth Vader (Premiere)
        # SetFilter      = "*17*"
        # TitleFilter    = "*Darth Vader*"
        # TypeFilter     = "Objective"
    }
    Export-Cdf @parameters

    Write-Verbose "Diffing Dark Side CDF"
    $parameters = @{
        Path         = "code"
        ArgumentList = @(
            "--diff",
            (Resolve-Path -Path "$HOME\repos\ronhowe\holotable\darkside.cdf"),
            (Resolve-Path -Path "$HOME\repos\ronhowe\code\powershell\prototypes\holotable\darkside.cdf")
        )
        NoNewWindow  = $true
        Wait         = $true
    }
    Start-Process @parameters

    Write-Verbose "Exporting Light Side CDF"
    $parameters = @{
        JsonPath       = "$HOME\repos\ronhowe\swccg-card-json\Light.json"
        JsonLegacyPath = "$HOME\repos\ronhowe\swccg-card-json\LightLegacy.json"
        JsonSetsPath   = "$HOME\repos\ronhowe\swccg-card-json\sets.json"
        CdfPath        = "$HOME\repos\ronhowe\code\powershell\prototypes\holotable\Lightside.cdf"
        # IdFilter       = 1593 # Luke Skywalker (Premiere)
        # SetFilter      = "*17*"
        # TitleFilter    = "*Luke Skywalker*"
        # TypeFilter     = "Objective"
    }
    Export-Cdf @parameters

    Write-Verbose "Diffing Light Side CDF"
    $parameters = @{
        Path         = "code"
        ArgumentList = @(
            "--diff",
            (Resolve-Path -Path "$HOME\repos\ronhowe\holotable\lightside.cdf"),
            (Resolve-Path -Path "$HOME\repos\ronhowe\code\powershell\prototypes\holotable\lightside.cdf")
        )
        NoNewWindow  = $true
        Wait         = $true
    }
    Start-Process @parameters

    Write-Verbose "Getting Dark Side Statistics..."
    Get-Content -Path "$HOME\repos\ronhowe\swccg-card-json\Dark.json" |
    ConvertFrom-Json |
    Select-Object -ExpandProperty "cards" |
    Measure-Object -Property id -Minimum -Maximum |
    Select-Object -Property @{Name = "Side"; Expression = { "Dark" } }, @{Name = "Total Cards"; Expression = { $_.Count } }, @{Name = "Minimum Id"; Expression = { $_.Minimum } }, @{Name = "Maximum Id"; Expression = { $_.Maximum } }

    Write-Verbose "Getting Light Side Statistics..."
    Get-Content -Path "$HOME\repos\ronhowe\swccg-card-json\Light.json" |
    ConvertFrom-Json |
    Select-Object -ExpandProperty "cards" |
    Measure-Object -Property id -Minimum -Maximum |
    Select-Object -Property @{Name = "Side"; Expression = { "Light" } }, @{Name = "Total Cards"; Expression = { $_.Count } }, @{Name = "Minimum Id"; Expression = { $_.Minimum } }, @{Name = "Maximum Id"; Expression = { $_.Maximum } }
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
