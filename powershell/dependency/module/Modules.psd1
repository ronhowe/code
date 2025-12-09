@{
    Modules = @(
        # https://github.com/Azure/azure-powershell
        @{ Name = 'Az' ; Version = '15.1.0' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://github.com/torgro/cliMenu
        ## NOTE: This module is failing to download.
        # @{ Name = 'CliMenu' ; Version = '1.0.52.0' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://github.com/PoshCode/Configuration
        @{ Name = 'Configuration' ; Version = '1.6.0' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://dbatools.io
        @{ Name = 'dbatools' ; Version = '2.7.13' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://learn.microsoft.com/en-us/powershell/module/iisadministration
        @{ Name = 'IISAdministration' ; Version = '1.1.0.0' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://github.com/dfinke/ImportExcel
        @{ Name = 'ImportExcel' ; Version = '7.8.10' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://github.com/nightroman/Invoke-Build
        @{ Name = 'InvokeBuild' ; Version = '5.14.22' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://github.com/PoshCode/Metadata
        @{ Name = 'Metadata' ; Version = '1.5.7' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://github.com/PowerShell/ConsoleGuiTools
        @{ Name = 'Microsoft.Powershell.ConsoleGuiTools' ; Version = '0.7.7' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core') },

        # https://github.com/PowerShell/Crescendo
        @{ Name = 'Microsoft.PowerShell.Crescendo' ; Version = '1.1.0' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core') },

        # https://github.com/powershell/secretmanagement
        @{ Name = 'Microsoft.PowerShell.SecretManagement' ; Version = '1.1.2' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core') },

        # https://github.com/powershell/secretstore
        @{ Name = 'Microsoft.PowerShell.SecretStore' ; Version = '1.0.6' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core') },

        # https://github.com/PoshCode/ModuleBuilder
        @{ Name = 'ModuleBuilder' ; Version = '3.1.8' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://oneget.org/
        @{ Name = 'PackageManagement' ; Version = '1.4.8.1' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://github.com/pester/Pester
        @{ Name = 'Pester' ; Version = '5.7.1' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://github.com/dahlbyk/posh-git
        @{ Name = 'posh-git' ; Version = '1.1.0' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://github.com/justingrote/powerconfig
        ## NOTE: This module has not been updated with latest .NET and no longer works well.
        # @{ Name = 'PowerConfig' ; Version = '0.1.6' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://github.com/RamblingCookieMonster/PSDepend
        @{ Name = 'PSDepend' ; Version = '0.3.8' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://github.com/adamdriscoll/pspolly
        @{ Name = 'PSPolly' ; Version = '0.0.2' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://github.com/PowerShell/PSReadLine
        @{ Name = 'PSReadLine' ; Version = '2.3.6' ; Repository = 'PSGallery' }

        # https://github.com/PowerShell/PSScriptAnalyzer
        @{ Name = 'PSScriptAnalyzer' ; Version = '1.24.0' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://github.com/mgajda83/PSWindowsUpdate
        ## NOTE: This module is interesting, but doesn't work well remotely.
        # @{ Name = 'PSWindowsUpdate' ; Version = '2.2.1.5' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://github.com/microsoft/SQLServerPSModule
        @{ Name = 'SqlServer' ; Version = '22.4.5.1' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') },

        # https://github.com/EliteLoser/WriteAscii
        @{ Name = 'WriteAscii' ; Version = '1.2.2.1' ; Repository = 'PSGallery' ; CompatiblePSEditions = @('Core', 'Desktop') }
    )
}
