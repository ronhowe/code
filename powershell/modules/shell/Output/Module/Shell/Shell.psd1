@{
    RootModule           = 'Shell.psm1'
    ModuleVersion        = '0.0.0'
    # CompatiblePSEditions = @()
    GUID                 = '6c176522-14cb-41e7-b010-12df869d0133'
    Author               = 'Ron Howe'
    CompanyName          = 'Ron Howe.NET'
    Copyright            = '(c) Ron Howe. All rights reserved.'
    Description          = 'A shell in PowerShell.'
    PowerShellVersion    = '7.3'
    # PowerShellHostName = ''
    # PowerShellHostVersion = ''
    # DotNetFrameworkVersion = ''
    # ClrVersion = ''
    # ProcessorArchitecture = ''
    RequiredModules      = @(
        'Az.Accounts',
        'CliMenu',
        'Microsoft.PowerShell.SecretManagement',
        'Microsoft.PowerShell.SecretStore',
        'Pester',
        'WriteAscii'
    )
    # RequiredAssemblies = @()
    # ScriptsToProcess     = @()
    # TypesToProcess = @()
    # FormatsToProcess = @()
    # NestedModules = @()
    FunctionsToExport    = @('Get-CatFact','Get-Quote','Get-Weather','Import-PowerConfiguration','New-PowerConfiguration','Get-Version','Show-Date','Show-Help','Show-Logo','Show-Ready','Show-Version','Start-Shell','Aliases','Protect-WithUserKey','Unprotect-WithUserKey')
    # CmdletsToExport      = @()
    VariablesToExport    = '*'
    AliasesToExport      = '*'
    # DscResourcesToExport = @()
    # ModuleList = @()
    # FileList = @()
    PrivateData          = @{
        PSData = @{
            Tags       = @('powershell', 'psmodule', 'shell')
            # LicenseUri = ''
            ProjectUri = 'https://github.com/ronhowe/code'
            # IconUri = ''
            # ReleaseNotes = ''
            # Prerelease = ''
            # RequireLicenseAcceptance = $false
            # ExternalModuleDependencies = @()
        }
    }
    # HelpInfoURI = ''
    # DefaultCommandPrefix = ''
}
