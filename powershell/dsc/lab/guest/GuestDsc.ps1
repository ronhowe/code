Configuration GuestDsc {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [pscredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [pscredential]
        $SqlCredential,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [string]
        $Thumbprint
    )

    Import-DscResource -ModuleName "ActiveDirectoryCSDsc" -ModuleVersion "5.0.0"
    Import-DscResource -ModuleName "ActiveDirectoryDsc" -ModuleVersion "6.7.0"
    Import-DscResource -ModuleName "ComputerManagementDsc" -moduleVersion "10.0.0"
    Import-DscResource -ModuleName "NetworkingDsc" -ModuleVersion "9.1.0"
    Import-DscResource -ModuleName "PSDesiredStateConfiguration" -ModuleVersion "1.1"
    Import-DscResource -ModuleName "SecurityPolicyDsc" -ModuleVersion "2.10.0.0"
    Import-DscResource -ModuleName "SqlServerDsc" -ModuleVersion "17.2.0"

    $domainAdminCredential = New-Object System.Management.Automation.PSCredential ($("{0}\{1}" -f $Node.DomainName, $Credential.UserName), $Credential.Password)

    #region AllNodes
    Node $AllNodes.NodeName {
        LocalConfigurationManager {
            ActionAfterReboot  = $Node.ActionAfterReboot
            CertificateId      = $Thumbprint
            ConfigurationMode  = $Node.ConfigurationMode
            RebootNodeIfNeeded = $Node.RebootNodeIfNeeded
        }
        Log PowerOnSelfTest {
            Message = "Power-On Self-Test"
        }
        File "CreateInstallersFolder" {
            DestinationPath = "C:\installers"
            Ensure          = "Present"
            Type            = "Directory"
        }
        File "DeleteDscEncryptionPfx" {
            DestinationPath = "C:\DscPrivateKey.pfx"
            Ensure          = "Absent"
            Type            = "File"
        }
        TimeZone "SetTimeZone" {
            IsSingleInstance = "Yes"
            TimeZone         = $Node.TimeZone
        }
        NetIPInterface "DisableDhcp" {
            AddressFamily  = "IPv4"
            Dhcp           = "Disabled"
            InterfaceAlias = "Ethernet"
        }
        IPAddress "SetIPAddress" {
            AddressFamily  = "IPV4"
            InterfaceAlias = "Ethernet"
            IPAddress      = $Node.IpAddress
        }
        DefaultGatewayAddress "SetDefaultGatewayIpAddress" {
            Address        = $Node.GatewayIpAddress
            AddressFamily  = "IPv4"
            InterfaceAlias = "Ethernet"
        }
        if ($Node.NodeName -eq "LAB-DC-00") {
            Computer "RenameComputer" {
                Name = $Node.NodeName
            }
            DnsServerAddress "SetDnsServerIpAddress" {
                Address        = $Node.DnsIpAddress
                AddressFamily  = "IPv4"
                InterfaceAlias = "Ethernet"
                Validate       = $false
            }
        }
        else {
            DnsServerAddress "SetDnsServerIpAddress" {
                ## TODO: Remove the secondary DNS.
                Address        = "192.168.0.10", $Node.DnsIpAddress
                AddressFamily  = "IPv4"
                InterfaceAlias = "Ethernet"
                Validate       = $false
            }
            WaitForADDomain "WaitForActiveDirectory" {
                Credential   = $Credential
                DomainName   = $Node.DomainName
                RestartCount = $Node.RestartCount
                WaitTimeout  = $Node.WaitTimeout
            }
            Computer "JoinDomain" {
                Credential = $domainAdminCredential
                DependsOn  = "[WaitForADDomain]WaitForActiveDirectory"
                DomainName = $Node.DomainName
                Name       = $Node.NodeName
            }
        }
        RemoteDesktopAdmin "SetRemoteDesktopSettings" {
            Ensure             = "Present"
            IsSingleInstance   = "Yes"
            UserAuthentication = "NonSecure"
        }
        if ($Node.Sku -eq "Desktop") {
            Service "SetNetworkResourceDiscovery" {
                Name        = "FDResPub"
                StartupType = "Automatic"
                State       = "Running"
            }
        }
        $Node.FirewallRules |
        ConvertFrom-Csv |
        ForEach-Object {
            Firewall "SetFirewallRule$($_.Name)" {
                Action  = "Allow"
                Enabled = $true
                Ensure  = "Present"
                Name    = $_.Name
                Profile = @("Domain", "Private")
            }
        }
        Registry "EnableRemoteDesktop" {
            Ensure    = "Present"
            Key       = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server"
            ValueData = "0"
            ValueName = "fdenyTSConnections"
        }
        ## NOTE: Does not support Domain.  May need to manually set if network discovery does not set it to Domain automatically.
        # NetConnectionProfile "SetNetworkProfile" {
        #     InterfaceAlias  = "Ethernet"
        #     NetworkCategory = "Private"
        # }
    }
    #endregion AllNodes
    #region LAB-APP-00
    Node "LAB-APP-00" {
        ## NOTE: No configuration required.
    }
    #endregion LAB-APP-00
    #region LAB-DC-00
    Node "LAB-DC-00" {
        WindowsFeature "InstallActiveDirectoryServices" {
            Ensure = "Present"
            Name   = "AD-Domain-Services"
        }
        if ($Node.Sku -eq "Desktop") {
            WindowsFeature "InstallActiveDirectoryTools" {
                DependsOn = "[WindowsFeature]InstallActiveDirectoryServices"
                Ensure    = "Present"
                Name      = "RSAT-ADDS"
            }
        }
        ADDomain "ConfigureActiveDirectory" {
            Credential                    = $Credential
            DatabasePath                  = $Node.DatabasePath
            DependsOn                     = "[WindowsFeature]InstallActiveDirectoryServices"
            DomainName                    = $Node.DomainName
            LogPath                       = $Node.LogPath
            SafemodeAdministratorPassword = $Credential
            SysvolPath                    = $Node.SysvolPath
        }
        PendingReboot "RebootAfterConfigureActiveDirectory" {
            DependsOn                   = "[ADDomain]ConfigureActiveDirectory"
            Name                        = "RebootAfterConfigureActiveDirectory"
            SkipCcmClientSDK            = $Node.SkipCcmClientSDK
            SkipComponentBasedServicing = $Node.SkipComponentBasedServicing
            SkipPendingFileRename       = $Node.SkipPendingFileRename
            SkipWindowsUpdate           = $Node.SkipWindowsUpdate
        }
        WaitForADDomain "WaitForActiveDirectory" {
            DependsOn    = "[PendingReboot]RebootAfterConfigureActiveDirectory"
            Credential   = $Credential
            DomainName   = $Node.DomainName
            RestartCount = $Node.RestartCount
            WaitTimeout  = $Node.WaitTimeout
        }
        ADOptionalFeature "EnableActiveDirectoryRecycleBin" {
            DependsOn                         = "[WaitForADDomain]WaitForActiveDirectory"
            EnterpriseAdministratorCredential = $Credential
            FeatureName                       = "Recycle Bin Feature"
            ForestFQDN                        = $Node.DomainName
        }
        ADUser "AddSqlServerServiceAccount" {
            Credential             = $domainAdminCredential
            DependsOn              = "[WaitForADDomain]WaitForActiveDirectory"
            DomainName             = $Node.DomainName
            Enabled                = $true
            Ensure                 = "Present"
            Password               = $SqlCredential
            PasswordAuthentication = "Negotiate"
            PasswordNeverExpires   = $true
            PasswordNeverResets    = $false
            Path                   = "CN=Users,DC=LAB,DC=LOCAL"
            UserName               = $SqlCredential.UserName.Split('\')[1]
        }
    }
    #endregion LAB-DC-00
    #region LAB-SQL-00
    Node "LAB-SQL-00" {
        ScheduledTask "MyScheduledTask" {
            ActionArguments     = "-Version >> C:\powershell.log"
            ActionExecutable    = "powershell.exe"
            Compatibility = "Win8"
            Description         = "MyTaskDescription"
            Enable              = $true
            ExecuteAsCredential = $SqlCredential
            ExecutionTimeLimit  = "02:00:00"
            LogonType           = "ServiceAccount"
            MultipleInstances   = "IgnoreNew"
            Priority            = 9
            RunLevel            = "Highest"
            RunOnlyIfIdle       = $false
            ScheduleType        = "Daily"
            StartTime           = "2025-05-27 17:38:00"
            TaskName            = "MyTaskName"
        }
        SqlSetup "InstallSqlServer" {
            DependsOn            = "[Computer]JoinDomain"
            Features             = $Node.Features
            ForceReboot          = $true
            InstanceName         = $Node.InstanceName
            PsDscRunAsCredential = $domainAdminCredential
            SAPwd                = $Credential
            SecurityMode         = "SQL"
            SourcePath           = $Node.SourcePath
            SQLCollation         = "SQL_Latin1_General_CP1_CI_AS"
            SQLSysAdminAccounts  = $Node.SQLSysAdminAccounts
            SQLSvcAccount        = $SqlCredential
            TcpEnabled           = $true
            UpdateEnabled        = $true
        }
        SqlWindowsFirewall "SetSqlServerFirewall" {
            DependsOn    = "[SqlSetup]InstallSqlServer"
            Ensure       = "Present"
            Features     = $Node.Features
            InstanceName = $Node.InstanceName
            SourcePath   = $Node.SourcePath
        }
        SqlServiceAccount "SetSqlServerDatabaseEngineRunAsAccount" {
            DependsOn      = "[SqlSetup]InstallSqlServer"
            InstanceName   = "MSSQLSERVER"
            RestartService = $true
            ServerName     = "localhost"
            ServiceAccount = $SqlCredential
            ServiceType    = "DatabaseEngine"
        }
        ## TODO: Warning.  Clear text password and no way to check the Test block.
        # $u = $SqlCredential.UserName
        # $p = $SqlCredential.GetNetworkCredential().Password
        # Script "SetSqlServerServiceAccount" {
        #     DependsOn  = "[SqlServiceAccount]SetSqlServerDatabaseEngineRunAsAccount"
        #     GetScript  = {
        #         @{
        #             Result = "Get operation not implemented for this script."
        #         }
        #     }
        #     SetScript  = {
        #         sc.exe config MSSQLSERVER obj= $using:u password= $using:p |
        #         Out-Null
        #     }
        #     TestScript = {
        #         return $false
        #     }
        # }
        UserRightsAssignment "AssignLogOnAsAServicePermissionToSqlServerService" {
            DependsOn            = "[Computer]JoinDomain"
            Force                = $false
            Identity             = $SqlCredential.UserName
            Policy               = "Log_on_as_a_service"
            PsDscRunAsCredential = $domainAdminCredential
        }
        UserRightsAssignment "AssignPerformVolumeMaintenanceTasksPermissionToSqlServerService" {
            DependsOn            = "[Computer]JoinDomain"
            Force                = $false
            Identity             = $SqlCredential.UserName
            Policy               = "Perform_volume_maintenance_tasks"
            PsDscRunAsCredential = $domainAdminCredential
        }
    }
    #endregion LAB-SQL-00
    #region LAB-WEB-00
    Node "LAB-WEB-00" {
        WindowsFeature "InstallWeb-Asp-Net45" {
            Name   = "Web-Asp-Net45"
            Ensure = "Present"
        }
        WindowsFeature "InstallWeb-Server" {
            Name      = "Web-Server"
            Ensure    = "Present"
            DependsOn = "[WindowsFeature]InstallWeb-Asp-Net45"
        }
        WindowsFeature "InstallWeb-Mgmt-Service" {
            Name      = "Web-Mgmt-Service"
            Ensure    = "Present"
            DependsOn = "[WindowsFeature]InstallWeb-Server"
        }
        WindowsFeature "InstallWeb-Http-Errors" {
            Name      = "Web-Http-Errors"
            Ensure    = "Present"
            DependsOn = "[WindowsFeature]InstallWeb-Server"
        }
        WindowsFeature "InstallWeb-Static-Content" {
            Name      = "Web-Static-Content"
            Ensure    = "Present"
            DependsOn = "[WindowsFeature]InstallWeb-Server"
        }
        WindowsFeature "InstallWeb-Mgmt-Tools" {
            Name      = "Web-Mgmt-Tools"
            Ensure    = "Present"
            DependsOn = "[WindowsFeature]InstallWeb-Server"
        }
        WindowsFeature "InstallWeb-Common-Http" {
            Name      = "Web-Common-Http"
            Ensure    = "Present"
            DependsOn = "[WindowsFeature]InstallWeb-Server"
        }
        WindowsFeature "InstallWeb-Http-Logging" {
            Name      = "Web-Http-Logging"
            Ensure    = "Present"
            DependsOn = "[WindowsFeature]InstallWeb-Server"
        }
        WindowsFeature "InstallWeb-Log-Libraries" {
            Name      = "Web-Log-Libraries"
            Ensure    = "Present"
            DependsOn = "[WindowsFeature]InstallWeb-Server"
        }
        WindowsFeature "InstallWeb-Request-Monitor" {
            Name      = "Web-Request-Monitor"
            Ensure    = "Present"
            DependsOn = "[WindowsFeature]InstallWeb-Server"
        }
        WindowsFeature "InstallWeb-Http-Tracing" {
            Name      = "Web-Http-Tracing"
            Ensure    = "Present"
            DependsOn = "[WindowsFeature]InstallWeb-Server"
        }
        WindowsFeature "InstallWeb-Security" {
            Name      = "Web-Security"
            Ensure    = "Present"
            DependsOn = "[WindowsFeature]InstallWeb-Server"
        }
    }
    #endregion LAB-WEB-00
}
