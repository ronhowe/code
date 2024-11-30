#requires -RunAsAdministrator
#requires -PSEdition Desktop

$ProgressPreference = "SilentlyContinue"

function Write-Message {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullorEmpty()]
        [string]$Message
    )
    Write-Host ("#" * 80) -ForegroundColor Green
    Write-Host $Message -ForegroundColor Green
    Write-Host ("#" * 80) -ForegroundColor Green
}

Write-Message ".NET SDK"
winget install --id Microsoft.DotNet.SDK.7 --source winget

Write-Message "Azure CLI"
winget install --id Microsoft.AzureCLI --source winget

Write-Message "Bicep CLI"
winget install --id Microsoft.Bicep --source winget

Write-Message "Git"
winget install --id Git.Git --source winget

Write-Message "GitHub CLI"
winget install --id GitHub.cli --source winget

Write-Message "GitHub Desktop"
winget install --id GitHub.GitHubDesktop --source winget

Write-Message "NuGet"
winget install --id Microsoft.NuGet --source winget

Write-Message "PowerShell"
winget install --id Microsoft.Powershell --source winget

Write-Message "Python"
winget install --id Python.Python.3.11 --source winget

Write-Message "Visual Studio Code"
winget install --id Microsoft.VisualStudioCode --source winget

Write-Message "Windows Admin Center"
winget install --id Microsoft.WindowsAdminCenter --source winget

Write-Message "Windows Terminal"
winget install --id Microsoft.WindowsTerminal --source winget

$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

Write-Message "Visual Studio Code Extension - .NET Interactive"
code --install-extension ms-dotnettools.dotnet-interactive-vscode 2>$null

Write-Message "Visual Studio Code Extension - .NET Runtime"
code --install-extension ms-dotnettools.vscode-dotnet-runtime 2>$null

Write-Message "Visual Studio Code Extension - .NET SDK"
code --install-extension ms-dotnettools.vscode-dotnet-sdk 2>$null

Write-Message "Visual Studio Code Extension - Bicep"
code --install-extension ms-azuretools.vscode-bicep 2>$null

Write-Message "Visual Studio Code Extension - Indent Rainbow"
code --install-extension oderwat.indent-rainbow 2>$null

Write-Message "Visual Studio Code Extension - PowerShell"
code --install-extension ms-vscode.powershell 2>$null

Write-Message "Visual Studio Code Extension - Python"
code --install-extension ms-python.python 2>$null

Write-Message "Visual Studio Code Extension - Sort Lines"
code --install-extension tyriar.sort-lines 2>$null

Write-Message "Python Module - PIP"
python -m pip install --upgrade pip

Write-Message "Python Module - Jupyter Noteboook"
python -m pip install jupyter notebook -U

Write-Message "Python Package - PowerShell Kernel"
pip install powershell_kernel

Write-Message "Python Module - PowerShell Kernel"
python -m powershell_kernel.install

Write-Message "RSAT Active Directory"
Get-WindowsCapability -Name "Rsat.ActiveDirectory.DS-LDS.Tools*" -Online | Add-WindowsCapability -Online

Write-Message "RSAT DHCP"
Get-WindowsCapability -Name "Rsat.DHCP.Tools*" -Online | Add-WindowsCapability -Online

Write-Message "RSAT DNS"
Get-WindowsCapability -Name "Rsat.Dns.Tools*" -Online | Add-WindowsCapability -Online

Write-Host "OK" -ForegroundColor Green
