BeforeAll {
    Import-Module -Name "$PSScriptRoot\Holotable.psm1" -Force
}

Describe "ConvertTo-CdfRarity" {
    It "RarityParses" {
        @'
{
"rarity": "U"
}
'@ |
        ConvertFrom-Json |
        ConvertTo-CdfRarity |
        Should -Be "U"
    }
}

Describe "ConvertTo-CdfDeploy" {
    It "BraniacParses" {
        @'
{
"id": 319
}
'@ |
        ConvertFrom-Json |
        ConvertTo-CdfDeploy |
        Should -Be "Y"
    }
    It "NonBrianiacParses" {
        @"
{
"front": {
    "deploy": "0"
},
"id": 0
}
"@ |
        ConvertFrom-Json |
        ConvertTo-CdfDeploy |
        Should -Be "0"
    }
}

Describe "Format-CdfTagGroup" {
    It "OutputIsEmptyWithEmptyTagValue" {
        Format-CdfTagGroup -Tags @("a", "b") |
        Should -Be "a b\n"
    }
    It "TagsAreTrimmed" {
        Format-CdfTagGroup -Tags @(" a ", " b ") |
        Should -Be "a b\n"
    }
}

Describe "Format-CdfTagPrefix" {
    It "OutputIsEmptyWithEmptyTagValue" {
        Format-CdfTagPrefix -TagName "tagname" -TagValue "" |
        Should -Be ""
    }
    It "OutputIsTrimmed" {
        Format-CdfTagPrefix -TagName " tagname " -TagValue " tagvalue " |
        Should -Be "tagname: tagvalue"
    }
}

# Clear-Host

# Set-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

# Import-Module -Name "./HolotableTools.psm1" -Force

# BeforeAll {
#     $Dark = Get-Content -Path "~/source/repos/swccg-card-json/Dark.json" |
#     ConvertFrom-Json |
#     Select-Object -ExpandProperty "cards"

#     $Light = Get-Content -Path "~/source/repos/swccg-card-json/Light.json" |
#     ConvertFrom-Json |
#     Select-Object -ExpandProperty "cards"

#     # Suppress PSScriptAnalyzer(PSUseDeclaredVarsMoreThanAssignments)
#     @($Dark, $Light) | Out-Null
# }

# Describe "ConvertTo-CdfGameText" {
#     Context "When GameText Is Missing" {
#         It "Should Return Empty GameText" {
#             # JediPack-Dark/large
#             $Dark.Where( { $_.id -eq 2424 }) |
#             ConvertTo-CdfGameText |
#             Should -Be ""
#         }
#     }
# }

# Describe "ConvertTo-CdfImage" {
#     Context "When ImageUrl Is Normal" {
#         It "Should Parse ImageUrl" {
#             # Coruscant-Dark/large/beginlandingyourtroops
#             $Dark.Where( { $_.id -eq 216 }) |
#             ConvertTo-CdfImage |
#             Should -Be "/starwars/Coruscant-Dark/t_beginlandingyourtroops"
#         }
#     }
# }

# Describe "ConvertTo-CdfIcons" {
#     Context "When Multiple Icons Exist" {
#         It "Should Concatenate Icons" {
#             # Premiere-Dark/large/darthvader
#             $Dark.Where( { $_.id -eq 634 }) |
#             ConvertTo-CdfIcons |
#             Should -Be "Pilot, Warrior"
#         }
#     }
# }

# Describe "ConvertTo-CdfSection" {
#     Context "When SubType Is Simple" {
#         It "Should Parse" {
#             # Premiere-Dark/large/alderaan
#             $Dark.Where( { $_.id -eq 79 }) |
#             ConvertTo-CdfSection |
#             Should -Be "[Location - System]"
#         }
#     }
#     Context "When SubType Is Complex" {
#         It "Should Parse" {
#             # Dagobah-Dark/large/ig2000
#             $Dark.Where( { $_.id -eq 1244 }) |
#             ConvertTo-CdfSection |
#             Should -Be "[Starship - Starfighter]"
#         }
#     }
# }

# Describe "ConvertTo-CdfTitle" {
#     Context "When Title Contains <>" {
#         It "Should Remove <>" {
#             # Dagobah-Dark/large/asteroidfield
#             $Dark.Where( { $_.id -eq 148 }) |
#             ConvertTo-CdfTitle |
#             Should -Be "Asteroid Field"
#         }
#     }
# }

# Describe "ConvertTo-CdfTitleSort" {
#     Context "When Title Contains <>" {
#         It "Should Remove <>" {
#             # Dagobah-Dark/large/asteroidfield
#             $Dark.Where( { $_.id -eq 148 }) |
#             ConvertTo-CdfTitleSort |
#             Should -Be "Asteroid Field"
#         }
#     }
#     Context "When Title Contains •" {
#         It "Should Remove •" {
#             # Dagobah-Dark/large/3720to1
#             $Dark.Where( { $_.id -eq 4 }) |
#             ConvertTo-CdfTitleSort |
#             Should -Be "3,720 To 1"
#         }
#     }
# }
