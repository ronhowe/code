throw

###############################################################################
#region dependencies

Get-Module -Name "Az" -ListAvailable
Find-Module -Name "Az" -Repository "PSGallery"
Install-Module -Name "Az" -Repository "PSGallery" -Force

#endregion dependencies
###############################################################################

###############################################################################
#region imports

Import-Module -Name "Az.Accounts"
Import-Module -Name "Az.AppConfiguration"
Import-Module -Name "Az.ApplicationInsights"
Import-Module -Name "Az.KeyVault"
Import-Module -Name "Az.OperationalInsights"
Import-Module -Name "Az.Resources"
Import-Module -Name "Az.Storage"
Import-Module -Name "Az.Websites"

#endregion imports
###############################################################################

###############################################################################
#region secrets

Set-Secret -Name "tenantId"
Set-Secret -Name "subscriptionName"
Set-Secret -Name "credential" -Secret (Get-Credential)

#endregion secrets
###############################################################################

###############################################################################
#region authentication

$tenantId = Get-Secret -Name "tenantId" -AsPlainText
$subscriptionName = Get-Secret -Name "subscriptionName" -AsPlainText
$credential = Get-Secret -Name "credential"

Connect-AzAccount -SubscriptionName $subscriptionName -TenantId $tenantId -Credential $credential
az login --username $($credential.UserName) --password $($credential.Password | ConvertFrom-SecureString -AsPlainText) --tenant $tenantId
az account set --subscription $subscriptionName

Disconnect-AzAccount
az logout

#endregion authentication
###############################################################################

###############################################################################
#region resources

# https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
# https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming-and-tagging-decision-guide

Set-Location -Path "$HOME\repos\ronhowe\powershell\azure"

$app = "app-rhowe-idso-000"
$config = "appcs-rhowe-idso-000"
$insights = "appi-rhowe-idso-000"
$key = "kv-rhowe-idso-000"
$location = "eastus"
$log = "log-rhowe-idso-000"
$parameters = ".\parameters.0.json"
$plan = "asp-rhowe-idso-000"
$resource = "rg-rhowe-idso-000"
$storage = "strhoweidso000"

#or

$app = "app-ronhowe-1"
$config = "appcs-ronhowe-1"
$insights = "appi-ronhowe-1"
$key = "kv-ronhowe-1"
$location = "westus"
$log = "log-ronhowe-1"
$parameters = ".\parameters.1.json"
$plan = "asp-ronhowe-1"
$resource = "rg-ronhowe-1"
$storage = "stronhowe1"

New-AzResourceGroup -Name $resource -Location $location -Force -Verbose
New-AzResourceGroupDeployment -ResourceGroupName $resource -Name (New-Guid) -TemplateFile ".\template.bicep" -TemplateParameterFile $parameters -Mode Incremental -Force -Verbose

Get-AzAppConfigurationStore -ResourceGroupName $resource -Name $config
Get-AzApplicationInsights -ResourceGroupName $resource -Name $insights
Get-AzAppServicePlan -ResourceGroupName $resource -Name $plan
Get-AzKeyVault -ResourceGroupName $resource -Name $key
Get-AzOperationalInsightsWorkspace -ResourceGroupName $resource -Name $log
Get-AzResourceGroup -Name $resource
Get-AzStorageAccount -ResourceGroupName $resource -Name $storage
Get-AzWebApp -ResourceGroupName $resource -Name $app

Remove-AzResourceGroup -Name $resource -Force -Verbose

#endregion resources
###############################################################################

###############################################################################
#region managed identity

$webApp = Get-AzWebApp -ResourceGroupName $resource -Name $app
$identity = $webApp.Identity

$appConfig = Get-AzAppConfigurationStore -ResourceGroupName $resource -Name $config
New-AzRoleAssignment -ObjectId $identity.PrincipalId -RoleDefinitionName "App Configuration Data Reader" -Scope $appConfig.Id

#endregion managed identity
###############################################################################

# $appInsights = Get-AzApplicationInsights -ResourceGroupName $resource -Name $insights
# $instrumentationKey = $appInsights.InstrumentationKey
# $connectionString = $appInsights.ConnectionString

###############################################################################
#region settings

# https://mohitgoyal.co/2018/02/26/apply-update-application-settings-for-azure-app-service-using-powershell/

# danger! this wipes out *all* of the app settings and replaces them solely with what is specified here
Set-AzWebApp -ResourceGroupName $resource -Name $app -AppSettings @{ "AppConfig__Endpoint" = "https://$config.azconfig.io" } -Verbose

Restart-AzWebApp -ResourceGroupName $resource -Name $app -Verbose

# preserve settings by exporting them, modifying them, importing them
$appSettings = (Get-AzWebApp -ResourceGroupName $resource -Name $app).SiteConfig.AppSettings |
Sort-Object -Property "Name"
$appSettings

$newAppSettings = @{}
foreach ($item in $appSettings) {
    $newAppSettings[$item.Name] = $item.Value
}
$newAppSettings

$newAppSettings.Add("AppConfig__Endpoint", "https://$config.azconfig.io")

$newAppSettings.CustomHeader = "$app"

$newAppSettings.MockService1PermanentExceptionToggle = "false"
$newAppSettings.MockService1TransientExceptionToggle = "false"
$newAppSettings.MockService1CpuThrottleToggle = "false"
$newAppSettings.MockService1CpuThrottleIterations = 0

Set-AzWebApp -ResourceGroupName $resource -Name $app -AppSettings $newAppSettings

#endregion settings
###############################################################################

###############################################################################
#region configuration

Set-Location -Path "$HOME\repos\ronhowe\powershell\azure"

az appconfig kv export --name $config --destination file --path .\configuration.json --yes --format json

Get-Content -Path .\configuration.json
code .\configuration.json

az appconfig kv import --name $config --source file --path .\configuration.json --yes --format json --import-mode all

Get-AzAppConfigurationKeyValue -Endpoint "https://appcs-rhowe-idso-000.azconfig.io"

# configuration(s)
Get-AzAppConfigurationKeyValue -Endpoint "https://appcs-rhowe-idso-000.azconfig.io" -Key "Sentinel"
Set-AzAppConfigurationKeyValue -Endpoint "https://appcs-rhowe-idso-000.azconfig.io" -Key "Sentinel" -Value (Get-Date -AsUTC)

# feature toggle(s)
Get-AzAppConfigurationKeyValue -Endpoint "https://appcs-rhowe-idso-000.azconfig.io" -Key ".appconfig.featureflag/MockService1PermanentExceptionToggle"

$json = '{"id":"MockService1PermanentExceptionToggle","description":"","enabled":false,"conditions":{"client_filters":[]}}'
Set-AzAppConfigurationKeyValue -Endpoint "https://appcs-rhowe-idso-000.azconfig.io" -Key ".appconfig.featureflag/MockService1PermanentExceptionToggle" -Value $json -ContentType "application/vnd.microsoft.appconfig.ff+json;charset=utf-8"

$json = '{"id":"MockService1PermanentExceptionToggle","description":"","enabled":true,"conditions":{"client_filters":[]}}'
Set-AzAppConfigurationKeyValue -Endpoint "https://appcs-rhowe-idso-000.azconfig.io" -Key ".appconfig.featureflag/MockService1PermanentExceptionToggle" -Value $json -ContentType "application/vnd.microsoft.appconfig.ff+json;charset=utf-8"

# work in progress - trying to do the same as above but with Az PowerShell module (it may not be supported, have seen this before)

# $exportedConfig = Get-AzAppConfigurationKeyValue -Endpoint (Get-Secret -Name "endpoint" -AsPlainText)
# $exportedConfig | ConvertTo-Json | Out-File -FilePath .\appconfig.json

# $importedConfig = Get-Content -Path .\appconfig.json | ConvertFrom-Json
# Set-AzAppConfigurationKeyValue -Name $config -InputObject $importedConfig

#endregion configuration
###############################################################################

###############################################################################
#region continuous integration

Set-Location -Path "$HOME\repos\ronhowe\dotnet"
dotnet build
dotnet test

#endregion continuous integration
###############################################################################

###############################################################################
#region continuous deployment

Get-Service -Name "W3SVC" | Stop-Service -Force -Verbose
Get-Service -Name "W3SVC" | Start-Service -Verbose

Set-Location -Path "$HOME\repos\ronhowe\dotnet"
Remove-Item -Path "$HOME\repos\ronhowe\dotnet\WebApplication1\bin\Release\net8.0\publish" -Recurse -Force -Verbose -ErrorAction SilentlyContinue
dotnet publish
Set-Location -Path "$HOME\repos\ronhowe\dotnet\WebApplication1\bin\Release\net8.0\publish" -ErrorAction Stop
Compress-Archive -Path * -DestinationPath ".\deploy.zip" -Force -Verbose
Publish-AzWebApp -ResourceGroupName $resource -Name $app -ArchivePath ".\deploy.zip" -Force -Verbose

#endregion build and deployment
###############################################################################

###############################################################################
#region live tests

Set-Location -Path "$HOME\repos\ronhowe\powershell\api"
.\Test-Api.ps1 -Name WebApplication1 -Platform AppService

#endregion live tests
###############################################################################
