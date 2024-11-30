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
dotnet --version

Write-Message "Azure CLI"
az --version

Write-Message "Bicep CLI"
bicep --version

Write-Message "GitHub CLI"
gh --version

Write-Message "Git"
git --version

Write-Message "NuGet"
nuget | Select-String -SimpleMatch "NuGet Version"

Write-Message "PowerShell"
pwsh --version

Write-Message "Python"
python --version

Write-Message "Visual Studio Code"
code --version

Write-Message "Windows Subsystem for Linux"
wsl --version

Write-Host "OK" -ForegroundColor Green
