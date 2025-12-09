@{
    RootModule        = 'Shell.psm1'
    ModuleVersion     = '0.0.0'
    # CompatiblePSEditions = @()
    GUID              = '43326943-7807-4be1-b234-eda334a63d6f'
    Author            = 'Ron Howe'
    CompanyName       = 'Ron Howe.NET'
    Copyright         = '(c) Ron Howe. All rights reserved.'
    Description       = 'A shell in PowerShell.'
    PowerShellVersion = '5.1'
    # PowerShellHostName = ''
    # PowerShellHostVersion = ''
    # DotNetFrameworkVersion = ''
    # ClrVersion = ''
    # ProcessorArchitecture = ''
    RequiredModules   = @(
        ## NOTE: Import at runtime (except Pester), but document critical dependencies here.
        ## TODO: Formalize and document this strategy.
        # 'Az.Accounts',
        # 'Az.Resources',
        # 'CliMenu',
        # 'Microsoft.PowerShell.SecretManagement',
        # 'Microsoft.PowerShell.SecretStore',
        # # 'Peste,r'
        # 'WriteAscii'
    )
    # RequiredAssemblies = @()
    # ScriptsToProcess     = @()
    # TypesToProcess = @()
    # FormatsToProcess = @()
    # NestedModules = @()
    FunctionsToExport = @()
    # CmdletsToExport      = @()
    VariablesToExport = '*'
    AliasesToExport   = '*'
    # DscResourcesToExport = @()
    # ModuleList = @()
    # FileList = @()
    PrivateData       = @{
        PSData = @{
            Tags       = @('powershell', 'psmodule', 'shell')
            # LicenseUri = ''
            ProjectUri = 'https://github.com/ronhowe/powershellrshellrshell'
            # IconUri = ''
            # ReleaseNotes = ''
            # Prerelease = ''
            # RequireLicenseAcceptance = $false
            # ExternalModuleDependencies = @()
        }
    }
    # HelpInfoURI = ''
    # DefaultCommandPrefix = 
}
