@{
    AllNodes = @(
        @{
            ActionAfterReboot    = 'ContinueConfiguration'
            PSDscAllowDomainUser = $true
            CertificateFile      = '~\repos\ronhowe\code\powershell\dsc\lab\DscPublicKey.cer'
            ConfigurationMode    = 'ApplyAndAutoCorrect'
            DnsIpAddress         = '192.168.1.1'
            DomainName           = 'LAB.LOCAL'
            GatewayIpAddress     = '192.168.0.1'
            NodeName             = '*'
            RebootNodeIfNeeded   = $true
            RestartCount         = 3
            Subnet               = 20
            TimeZone             = 'Eastern Standard Time'
            WaitTimeout          = 300
            FirewallRules        = @'
Name
FPS-ICMP4-ERQ-In
FPS-ICMP4-ERQ-Out
NETDIS-FDPHOST-In-UDP
NETDIS-FDPHOST-Out-UDP
NETDIS-FDRESPUB-WSD-In-UDP
NETDIS-FDRESPUB-WSD-Out-UDP
NETDIS-LLMNR-In-UDP
NETDIS-LLMNR-Out-UDP
NETDIS-NB_Datagram-In-UDP
NETDIS-NB_Datagram-Out-UDP
NETDIS-NB_Name-In-UDP
NETDIS-NB_Name-Out-UDP
NETDIS-SSDPSrv-In-UDP
NETDIS-SSDPSrv-Out-UDP
NETDIS-UPnPHost-In-TCP
NETDIS-UPnPHost-Out-TCP
NETDIS-UPnP-Out-TCP
NETDIS-WSDEVNT-In-TCP
NETDIS-WSDEVNT-Out-TCP
NETDIS-WSDEVNTS-In-TCP
NETDIS-WSDEVNTS-Out-TCP
RemoteDesktop-UserMode-In-TCP
WMI-RPCSS-In-TCP
WMSVC-In-TCP
'@
        },
        ## TODO: Determine if , or ; or both are the appropriate delimiters.
        @{
            NodeName            = 'LAB-APP-00'
            IpAddress           = '192.168.0.20/24'
            Sku                 = 'Desktop'
            #
            Features            = 'SQLENGINE'
            InstanceName        = 'MSSQLSERVER'
            SourcePath          = 'E:\'
            SQLSysAdminAccounts = @('Administrators')
        };
        @{
            NodeName                    = 'LAB-DC-00'
            IpAddress                   = '192.168.0.10/24'
            DatabasePath                = 'C:\Windows\NTDS'
            Sku                         = 'Desktop'
            #
            LogPath                     = 'C:\Windows\NTDS'
            SkipCcmClientSDK            = $true
            SkipComponentBasedServicing = $true
            SkipPendingFileRename       = $true
            SkipWindowsUpdate           = $true
            SysvolPath                  = 'C:\Windows\SYSVOL'
        };
        @{
            NodeName            = 'LAB-SQL-00'
            IpAddress           = '192.168.0.30/24'
            Sku                 = 'Desktop'
            #
            Features            = 'SQLENGINE'
            InstanceName        = 'MSSQLSERVER'
            SourcePath          = 'E:\'
            SQLSysAdminAccounts = @('Administrators')
        };
        @{
            NodeName            = 'LAB-WEB-00'
            IpAddress           = '192.168.0.40/24'
            Sku                 = 'Desktop'
            #
            Features            = 'SQLENGINE'
            InstanceName        = 'MSSQLSERVER'
            SourcePath          = 'E:\'
            SQLSysAdminAccounts = @('Administrators')
        };
    );
}