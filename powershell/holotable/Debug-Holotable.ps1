[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $SourceCdfPath = "$HOME\repos\ronhowe\holotable",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $SourceJsonPath = "$HOME\repos\ronhowe\swccg-card-json",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $TargetCdfPath = $PSScriptRoot

)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Import-Module -Name "$PSScriptRoot\Holotable.psm1" -Force

    Write-Verbose "Exporting Dark Side CDF"
    $parameters = @{
        JsonPath       = "$SourceJsonPath\Dark.json"
        JsonLegacyPath = "$SourceJsonPath\DarkLegacy.json"
        JsonSetsPath   = "$SourceJsonPath\sets.json"
        CdfPath        = "$TargetCdfPath\darkside.cdf"
    }
    Export-Cdf @parameters

    Write-Verbose "Exporting Light Side CDF"
    $parameters = @{
        JsonPath       = "$SourceJsonPath\Light.json"
        JsonLegacyPath = "$SourceJsonPath\LightLegacy.json"
        JsonSetsPath   = "$SourceJsonPath\sets.json"
        CdfPath        = "$TargetCdfPath\lightside.cdf"
    }
    Export-Cdf @parameters

    Write-Verbose "Asserting Visual Studio Code Exists"
    if (Get-Command -Name "code" -ErrorAction SilentlyContinue) {
        Write-Verbose "Diffing Dark Side CDF"
        $parameters = @{
            Path         = "code"
            ArgumentList = @(
                "--diff",
            (Resolve-Path -Path "$SourceCdfPath\darkside.cdf"),
            (Resolve-Path -Path "$TargetCdfPath\darkside.cdf")
            )
            NoNewWindow  = $true
            Wait         = $true
        }
        Start-Process @parameters

        Write-Verbose "Diffing Light Side CDF"
        $parameters = @{
            Path         = "code"
            ArgumentList = @(
                "--diff",
            (Resolve-Path -Path "$SourceCdfPath\lightside.cdf"),
            (Resolve-Path -Path "$TargetCdfPath\lightside.cdf")
            )
            NoNewWindow  = $true
            Wait         = $true
        }
        Start-Process @parameters
    }
    else {
        Write-Error "Visual Studio Code Not Found"
    }

    Write-Verbose "Getting Dark Side JSON Statistics"
    Get-Content -Path "$SourceJsonPath\Dark.json" |
    ConvertFrom-Json |
    Select-Object -ExpandProperty "cards" |
    Measure-Object -Property "id" -Minimum -Maximum |
    Select-Object -Property @(
        @{Name = "Side"; Expression = { "Dark" } },
        @{Name = "Total Cards"; Expression = { $_.Count } },
        @{Name = "Minimum Id"; Expression = { $_.Minimum } },
        @{Name = "Maximum Id"; Expression = { $_.Maximum } }
    )

    Write-Verbose "Getting Light Side JSON Statistics"
    Get-Content -Path "$SourceJsonPath\Light.json" |
    ConvertFrom-Json |
    Select-Object -ExpandProperty "cards" |
    Measure-Object -Property "id" -Minimum -Maximum |
    Select-Object -Property @(
        @{Name = "Side"; Expression = { "Light" } },
        @{Name = "Total Cards"; Expression = { $_.Count } },
        @{Name = "Minimum Id"; Expression = { $_.Minimum } },
        @{Name = "Maximum Id"; Expression = { $_.Maximum } }
    )
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
