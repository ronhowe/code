BeforeDiscovery {
    $functions = Get-Command -Module "Shell" -CommandType Function -Name "Add-Extension"
    $functionDefinitions = @()
    foreach ($function in $functions) {
        $help = (Get-Help $function.Name -Full)
        $functionDefinitions += @{
            Name = $function.Name
            Help = $help
        }
    }

    $functionDefinitions |
    Out-Null
}
Describe "Comment-Based Help Tests" {
    Context "Synopsis Tests" {
        It "Asserting Function <Name> Has Synopsis }" -ForEach $functionDefinitions {
            $_.Help.Synopsis |
            Should -Not -BeNullOrEmpty
        }
        It "Asserting Function <Name> Synopsis Is Not TODO }" -ForEach $functionDefinitions {
            $_.Help.Synopsis |
            Should -Not -Be "TODO"
        }
    }
    Context "Description Tests" {
        It "Asserting Function <Name> Has Description }" -ForEach $functionDefinitions {
            $_.Help.description |
            Should -Not -BeNullOrEmpty
        }
        It "Asserting Function <Name> Description Is Not TODO }" -ForEach $functionDefinitions {
            $_.Help.description |
            Should -Not -Be "TODO"
        }
    }
}
