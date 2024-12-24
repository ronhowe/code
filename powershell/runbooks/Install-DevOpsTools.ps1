#requires -PSEdition Desktop
#requires -RunAsAdministrator
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

    $ProgressPreference = "SilentlyContinue"

    ## NOTE: Windows PowerShell ISE does not display winget progress meters well.
    if ($Host.Name -eq "Windows PowerShell ISE Host") {
        Write-Warning "Running Inside PowerShell ISE"
    }

    Write-Verbose "Installing .NET 9 SDK"
    winget install --id Microsoft.DotNet.SDK.9 --source winget

    Write-Verbose "Installing Azure CLI"
    winget install --id Microsoft.AzureCLI --source winget

    Write-Verbose "Installing Bicep CLI"
    winget install --id Microsoft.Bicep --source winget

    Write-Verbose "Installing Git CLI"
    winget install --id Git.Git --source winget

    Write-Verbose "Installing GitHub CLI"
    winget install --id GitHub.cli --source winget

    Write-Verbose "Installing GitHub Desktop"
    winget install --id GitHub.GitHubDesktop --source winget

    Write-Verbose "Installing NuGet"
    winget install --id Microsoft.NuGet --source winget

    Write-Verbose "Installing PowerShell"
    winget install --id Microsoft.Powershell --source winget

    Write-Verbose "Installing Python 3.11"
    winget install --id Python.Python.3.11 --source winget

    Write-Verbose "Installing Visual Studio Code"
    winget install --id Microsoft.VisualStudioCode --source winget

    Write-Verbose "Installing Windows Admin Center"
    winget install --id Microsoft.WindowsAdminCenter --source winget

    Write-Verbose "Installing Windows Terminal"
    winget install --id Microsoft.WindowsTerminal --source winget

    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

    Write-Verbose "Installing Visual Studio Code Extension For .NET Interactive"
    code --install-extension ms-dotnettools.dotnet-interactive-vscode 2>$null

    Write-Verbose "Installing Visual Studio Code Extension For .NET Runtime"
    code --install-extension ms-dotnettools.vscode-dotnet-runtime 2>$null

    Write-Verbose "Installing Visual Studio Code Extension For .NET SDK"
    code --install-extension ms-dotnettools.vscode-dotnet-sdk 2>$null

    Write-Verbose "Installing Visual Studio Code Extension For Bicep"
    code --install-extension ms-azuretools.vscode-bicep 2>$null

    Write-Verbose "Installing Visual Studio Code Extension For Indent Rainbow"
    code --install-extension oderwat.indent-rainbow 2>$null

    Write-Verbose "Installing Visual Studio Code Extension For PowerShell"
    code --install-extension ms-vscode.powershell 2>$null

    Write-Verbose "Installing Visual Studio Code Extension For Python"
    code --install-extension ms-python.python 2>$null

    Write-Verbose "Installing Visual Studio Code Extension For Sort Lines"
    code --install-extension tyriar.sort-lines 2>$null

    Write-Verbose "Installing Python Module For PIP"
    python -m pip install --upgrade pip

    Write-Verbose "Installing Python Module For Jupyter Noteboook"
    python -m pip install jupyter notebook -U

    Write-Verbose "Installing Python Package For PowerShell Kernel"
    pip install powershell_kernel

    Write-Verbose "Installing Python Module For PowerShell Kernel"
    python -m powershell_kernel.install

    Write-Verbose "Installing Remote Server Administration Tools For Active Directory"
    Get-WindowsCapability -Name "Rsat.ActiveDirectory.DS-LDS.Tools*" -Online |
    Add-WindowsCapability -Online -Verbose:$false

    Write-Verbose "Installing Remote Server Administration Tools For DHCP"
    Get-WindowsCapability -Name "Rsat.DHCP.Tools*" -Online |
    Add-WindowsCapability -Online -Verbose:$false

    Write-Verbose "Installing Remote Server Administration Tools For DNS"
    Get-WindowsCapability -Name "Rsat.Dns.Tools*" -Online |
    Add-WindowsCapability -Online -Verbose:$false
}
end {
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"
}
