throw

################################################################################
#region Dependencies

Get-Module -Name "Az" -ListAvailable
Find-Module -Name "Az" -Repository "PSGallery"
Install-Module -Name "Az" -Repository "PSGallery" -Force

Import-Module -Name "Az.Accounts"
Import-Module -Name "Az.AppConfiguration"
Import-Module -Name "Az.ApplicationInsights"
Import-Module -Name "Az.Automation"
Import-Module -Name "Az.KeyVault"
Import-Module -Name "Az.OperationalInsights"
Import-Module -Name "Az.Resources"
Import-Module -Name "Az.Storage"
Import-Module -Name "Az.Websites"

#endregion Dependencies
################################################################################

################################################################################
#region Authentication

$tenant = $ShellConfig.Tenant
$subscription = $ShellConfig.Subscription
$credential = Get-Credential -Message "Enter Azure Credential"

Connect-AzAccount -SubscriptionName $subscription -TenantId $tenant -Credential $credential
## NOTE: Required for some Azure Key Vault operations only supported in the Azure CLI.
az login --username $($credential.UserName) --password $($credential.Password | ConvertFrom-SecureString -AsPlainText) --tenant $tenant
az account set --subscription $subscription

Disconnect-AzAccount
az logout

#endregion Authentication
###############################################################################

###############################################################################
#region Resources

# https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
# https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming-and-tagging-decision-guide

$appInsightsName = "appi-ronhowe-0"
$appName = "app-ronhowe-0"
$automationAccountName = "aa-ronhowe-0"
$configStoreName = "appc-ronhowe-0"
$keyVaultName = "kv-ronhowe-0"
$location = "eastus2"
$parametersFile = Resolve-Path -Path "$HOME\repos\ronhowe\code\azure\parameters.json"
$planName = "asp-ronhowe-0"
$resourceGroupName = "rg-ronhowe-0"
$storageAccountName = "stronhowe0"
$templateFile = Resolve-Path -Path "$HOME\repos\ronhowe\code\azure\template.bicep"
$workspaceName = "law-ronhowe-0"

New-AzResourceGroup -Name $resourceGroupName -Location $location -Force -Verbose
## NOTE: Will prompt for any secure input parameters in the template.
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name (New-Guid) -TemplateFile $templateFile -TemplateParameterFile $parametersFile -Mode Incremental -Force -Verbose

Get-AzAppConfigurationStore -ResourceGroupName $resourceGroupName -Name $configStoreName
Get-AzApplicationInsights -ResourceGroupName $resourceGroupName -Name $appInsightsName
Get-AzAppServicePlan -ResourceGroupName $resourceGroupName -Name $planName
Get-AzAutomationAccount -ResourceGroupName $resourceGroupName -Name $automationAccountName
Get-AzKeyVault -ResourceGroupName $resourceGroupName -Name $keyVaultName
Get-AzOperationalInsightsWorkspace -ResourceGroupName $resourceGroupName -Name $workspaceName
Get-AzResourceGroup -Name $resourceGroupName
Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName
Get-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName

Remove-AzResourceGroup -Name $resourceGroupName -Force -Verbose

#endregion Resources
###############################################################################

###############################################################################
#region RBAC

$webApp = Get-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName
$identity = $webApp.Identity
$identity

$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName
New-AzRoleAssignment -ObjectId $identity.PrincipalId -RoleDefinitionName "Storage Table Data Contributor" -Scope $storageAccount.Id

$appConfigurationStore = Get-AzAppConfigurationStore -ResourceGroupName $resourceGroupName -Name $configStoreName
New-AzRoleAssignment -ObjectId $identity.PrincipalId -RoleDefinitionName "App Configuration Data Reader" -Scope $appConfigurationStore.Id

#endregion RBAC
###############################################################################

$applicationInsights = Get-AzApplicationInsights -ResourceGroupName $resourceGroupName -Name $appInsightsName
$connectionString = $applicationInsights.ConnectionString
$connectionString

###############################################################################
#region Configuration

## NOTE: DANAGER!  This wipes out ALL app settings and replaces.
Set-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName -AppSettings @{ "AppConfig__Endpoint" = "https://$configStoreName.azconfig.io" } -Verbose
Restart-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName -Verbose

## NOTE:Preserve settings by exporting, modifying, importin.
$appSettings = (Get-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName).SiteConfig.AppSettings |
Sort-Object -Property "Name"
$appSettings

$newAppSettings = @{}
foreach ($appSetting in $appSettings) {
    $newAppSettings[$appSetting.Name] = $appSetting.Value
}
$newAppSettings | Format-Table -AutoSize

$newAppSettings.Add("AppConfig__Endpoint", "https://$configStoreName.azconfig.io")
$newAppSettings.Add("Serilog:WriteTo:0:Args:connectionString", $connectionString)
$newAppSettings.Add("ApplicationInsights", $connectionString)
$newAppSettings.MyHeader = "$appName"
$newAppSettings.MyFeature = "false"
$newAppSettings | Format-Table -AutoSize

Set-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName -AppSettings $newAppSettings
Restart-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName -Verbose

Get-AzAppConfigurationKeyValue -Endpoint "https://$configStoreName.azconfig.io"

Get-AzAppConfigurationKeyValue -Endpoint "https://$configStoreName.azconfig.io" -Key "Sentinel"
Set-AzAppConfigurationKeyValue -Endpoint "https://$configStoreName.azconfig.io" -Key "Sentinel" -Value ([DateTime]::UtcNow.ToString("yyyy-MM-dd HH:mm:ss.fff"))

Get-AzAppConfigurationKeyValue -Endpoint "https://$configStoreName.azconfig.io" -Key ".appconfig.featureflag/MyFeature"
$json = '{"id":"MyFeature","description":"","enabled":false,"conditions":{"client_filters":[]}}'
Set-AzAppConfigurationKeyValue -Endpoint "https://$configStoreName.azconfig.io" -Key ".appconfig.featureflag/MyFeature" -Value $json -ContentType "application/vnd.microsoft.appconfig.ff+json;charset=utf-8"

## TODO: Implement with PowerShell cmdlets if/when they become available for this particular operation.
az appconfig kv export --name $configStoreName --destination file --path .\configuration.json --yes --format json
Get-Content -Path .\configuration.json
az appconfig kv import --name $configStoreName --source file --path .\configuration.json --yes --format json --import-mode all

#endregion Configuration
###############################################################################

###############################################################################
#region Deployment

$codePath = "$HOME\repos\ronhowe\code"
Remove-Item -Path "$codePath\dotnet\MyWebApplication\bin\Release\net9.0\publish" -Recurse -Force -Verbose -ErrorAction SilentlyContinue
dotnet publish "$codePath\dotnet\MyWebApplication\MyWebApplication.csproj" -c Release -o $path -v n
Compress-Archive -Path "$codePath\dotnet\MyWebApplication\bin\Release\net9.0\publish\*" -DestinationPath "$codePath\dotnet\MyWebApplication\bin\Release\net9.0\publish\deploy.zip" -Force -Verbose
Publish-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName -ArchivePath "$codePath\dotnet\MyWebApplication\bin\Release\net9.0\publish\deploy.zip" -Force -Verbose

#endregion Deployment
###############################################################################
