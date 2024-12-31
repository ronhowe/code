param appInsightsName string
param appName string
param automationAccountName string
param configStoreName string
param fileShareName string
param location string
param ipStartAddress string
param ipEndAddress string
param keyVaultName string
param planName string
@secure()
param sqlAdminPassword string
param sqlAdminUsername string
param sqlDatabaseName string
param sqlServerName string
param storageAccountName string
param workspaceName string

param automationSku string = 'Free'
param configSku string = 'standard'
param curveName string = ''
param includeAppConfiguration bool = false
param includeAutomationAccount bool = false
param includeKeyVault bool = false
param keyName string = 'mykey'
param keyOps array = []
param keySize int = 2048
param keyType string = 'RSA'
param planCapacity int = 1
param planSku string = 'B1'
param shareQuotaGB int = 1
param sqlFirewallRuleName string = 'MyFirewallRule'
param sqlSku string = 'S0'
param sqlTier string = 'Standard'
param storageKind string = 'StorageV2'
param storageSku string = 'Standard_LRS'
param vaultFamily string = 'A'
param vaultSku string = 'standard'

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.web/serverfarms
resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: planName
  location: location
  sku: {
    name: planSku
    capacity: planCapacity
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.web/sites
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

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts
// TODO: 2023-11-01 is the latest version in eastus2. 2024-04-01 is the latest version in eastus.
resource automationAccount 'Microsoft.Automation/automationAccounts@2023-11-01' = if (includeAutomationAccount) {
  name: automationAccountName
  location: location
  properties: {
    sku: {
      name: automationSku
    }
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.appconfiguration/configurationstores
resource configStore 'Microsoft.AppConfiguration/configurationStores@2024-05-01' = if (includeAppConfiguration) {
  name: configStoreName
  location: location
  sku: {
    name: configSku
  }
  properties: {
    enablePurgeProtection: false
    softDeleteRetentionInDays: 1
  }
  identity: {
    type: 'SystemAssigned'
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.operationalinsights/workspaces
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/components
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  kind: storageKind
  sku: {
    name: storageSku
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts/fileservices
resource fileServices 'Microsoft.Storage/storageAccounts/fileServices@2023-05-01' = {
  parent: storageAccount
  name: 'default'
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts/fileservices/shares
resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-05-01' = {
  parent: fileServices
  name: fileShareName
  properties: {
    shareQuota: shareQuotaGB
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults
resource vault 'Microsoft.KeyVault/vaults@2024-04-01-preview' = if (includeKeyVault) {
  name: keyVaultName
  location: location
  properties: {
    accessPolicies: []
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7 // minimum value
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    tenantId: subscription().tenantId
    sku: {
      name: vaultSku
      family: vaultFamily
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.keyvault/vaults/keys
resource key 'Microsoft.KeyVault/vaults/keys@2024-04-01-preview' = if (includeKeyVault) {
  parent: vault
  name: keyName
  properties: {
    kty: keyType
    keyOps: keyOps
    keySize: keySize
    curveName: curveName
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers
resource sqlServer 'Microsoft.Sql/servers@2024-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    // TODO: administrators  The Azure Active Directory administrator of the server. This can only be used at server create time
    administratorLogin: sqlAdminUsername
    administratorLoginPassword: sqlAdminPassword
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers/databases
resource sqlDatabase 'Microsoft.Sql/servers/databases@2024-05-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 2147483648
  }
  sku: {
    name: sqlSku
    tier: sqlTier
  }
}

// LINK: https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers/firewallrules
resource sqlFirewallRule 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: sqlServer
  name: sqlFirewallRuleName
  properties: {
    startIpAddress: ipStartAddress
    endIpAddress: ipEndAddress
  }
}

resource sqlFirewallRuleForAzure 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: sqlServer
  name: 'AllowAllAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

output proxyKey object = key.properties
