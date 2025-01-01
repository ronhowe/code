@{
    AllNodes = @(
        @{
            ActionAfterReboot    = "ContinueConfiguration"
            PSDscAllowDomainUser = $true
            CertificateFile      = "$PSScriptRoot\DscPublicKey.cer"
            ConfigurationMode    = "ApplyAndAutoCorrect"
            DnsIpAddress         = "192.168.1.1"
            DomainName           = "LAB.LOCAL"
            GatewayIpAddress     = "192.168.0.1"
            NodeName             = "*"
            RebootNodeIfNeeded   = $true
            RestartCount         = 3
            Subnet               = 20
            TimeZone             = "Eastern Standard Time"
            WaitTimeout          = 300
            FirewallRules        = @"
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
"@
        },
        ## TODO: Determine if , or ; or both are the appropriate delimiters.
        @{
            IpAddress = "192.168.0.20/24"
            NodeName  = "LAB-APP-00"
            Sku       = "Desktop"
        };
        @{
            DatabasePath                = "C:\Windows\NTDS"
            IpAddress                   = "192.168.0.10/24"
            LogPath                     = "C:\Windows\NTDS"
            NodeName                    = "LAB-DC-00"
            Sku                         = "Desktop"
            SkipCcmClientSDK            = $true
            SkipComponentBasedServicing = $true
            SkipPendingFileRename       = $true
            SkipWindowsUpdate           = $true
            SysvolPath                  = "C:\Windows\SYSVOL"
        };
        @{
            Features            = "SQLENGINE"
            IpAddress           = "192.168.0.30/24"
            InstanceName        = "MSSQLSERVER"
            NodeName            = "LAB-SQL-00"
            Sku                 = "Desktop"
            SourcePath          = "E:\"
            SQLSysAdminAccounts = @("Administrators")
        };
        @{
            IpAddress = "192.168.0.40/24"
            NodeName  = "LAB-WEB-00"
            Sku       = "Desktop"
        };
    );
}