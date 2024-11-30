Write-Output ".NET SDK"
dotnet --version

Write-Output "Azure CLI"
az --version

Write-Output "Bicep CLI"
bicep --version

Write-Output "GitHub CLI"
gh --version

Write-Output "Git"
git --version

Write-Output "NuGet"
nuget | Select-String -SimpleMatch "NuGet Version"

Write-Output "PowerShell"
pwsh --version

Write-Output "Python"
python --version

Write-Output "Visual Studio Code"
code --version

Write-Output "Windows Subsystem for Linux"
wsl --version
