param appInsightsName string
param appName string
param automationAccountName string = 'aa-ronhowe-0'
param configStoreName string
param location string
param planName string
@secure()
param sqlAdminPassword string
param sqlAdminUsername string
param sqlDatabaseName string
param sqlServerName string
param storageAccountName string
param vaultName string
param workspaceName string

param curveName string = ''
param keyName string = 'mykey'
param keyOps array = []
param keySize int = 2048
param keyType string = 'RSA'
param skuCapacity int = 1
// LINK: https://azure.microsoft.com/en-us/pricing/details/app-service/windows/
// NOTE: B1 => 1 Core => 1.75 GB RAM =>  10 GB Storage => $0.075/hour => $54.75/month
// TODO: Can we get cheaper with Linux?
param skuName string = 'B1'
param vaultSku string = 'standard'

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.web/serverfarms?pivots=deployment-language-bicep
resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: planName
  location: location
  sku: {
    name: skuName
    capacity: skuCapacity
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.web/sites?pivots=deployment-language-bicep
resource appService 'Microsoft.Web/sites@2024-04-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      alwaysOn: true
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnet'
        }
      ]
      netFrameworkVersion: 'v9.0'
      http20Enabled: true
      minTlsVersion: '1.2'
      use32BitWorkerProcess: false
      healthCheckPath: '/healthcheck'
    }
    httpsOnly: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts?pivots=deployment-language-bicep
// TODO: 2023-11-01 is the latest version in eastus2. 2024-04-01 is the latest version in eastus.
resource automationAccount 'Microsoft.Automation/automationAccounts@2023-11-01' = {
  name: automationAccountName
  location: location
  properties: {
    sku: {
      name: 'Free'
    }
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.appconfiguration/configurationstores?pivots=deployment-language-bicep
resource configStore 'Microsoft.AppConfiguration/configurationStores@2024-05-01' = {
  name: configStoreName
  location: location
  sku: {
    name: 'standard'
  }
  properties: {
    enablePurgeProtection: false
    softDeleteRetentionInDays: 1
  }
  identity: {
    type: 'SystemAssigned'
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.operationalinsights/workspaces?pivots=deployment-language-bicep
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/components?pivots=deployment-language-bicep
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts?pivots=deployment-language-bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults?pivots=deployment-language-bicep
resource vault 'Microsoft.KeyVault/vaults@2024-04-01-preview' = {
  name: vaultName
  location: location
  properties: {
    accessPolicies: []
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    tenantId: subscription().tenantId
    sku: {
      name: vaultSku
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults/keys?pivots=deployment-language-bicep
resource key 'Microsoft.KeyVault/vaults/keys@2024-04-01-preview' = {
  parent: vault
  name: keyName
  properties: {
    kty: keyType
    keyOps: keyOps
    keySize: keySize
    curveName: curveName
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers?pivots=deployment-language-bicep
resource sqlServer 'Microsoft.Sql/servers@2024-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdminUsername
    administratorLoginPassword: sqlAdminPassword
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers/databases?pivots=deployment-language-bicep
resource sqlDatabase 'Microsoft.Sql/servers/databases@2024-05-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 2147483648
  }
  sku: {
    name: 'S0'
    tier: 'Standard'
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers/firewallrules?pivots=deployment-language-bicep
resource sqlFirewallRule 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: sqlServer
  name: 'MyFirewallRule'
  properties: {
    startIpAddress: '69.207.185.73'
    endIpAddress: '69.207.185.73'
  }
}

output proxyKey object = key.properties
