Configuration HostDsc {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Nodes,
    
        [Parameter(Mandatory = $true)]
        [ValidateSet("Present", "Absent")]
        [string]
        $Ensure
    )

    Import-DscResource -ModuleName "PSDesiredStateConfiguration" -ModuleVersion "1.1"
    Import-DscResource -ModuleName "xHyper-V" -ModuleVersion "3.18.0"

    Node "localhost" {
        # WindowsFeature "HyperV" {
        #     Ensure = "Present"
        #     Name   = "Hyper-V"
        # }
        # xVMSwitch "InternalSwitch" {
        #     DependsOn = "[WindowsFeature]HyperV"
        #     Ensure    = "Present"
        #     Name      = "Internal Switch"
        #     Type      = "Internal"
        # }
        # IPAddress "NewIPv4Address"
        # {
        #     AddressFamily  = "IPV4"
        #     DependsOn      = "[xVMSwitch]InternalSwitch"
        #     InterfaceAlias = "vEthernet (Internal Switch)"
        #     IPAddress      = "192.168.0.1"
        # }
        ## TODO: DSC Support for NAT rule.
        $Nodes |
        ForEach-Object {
            xVHD "xVHD$_" {
                Ensure           = $Ensure
                Generation       = "VHDX"
                MaximumSizeBytes = $Node.MaximumSizeBytes
                Name             = $_
                Path             = $Node.VirtualHardDisksPath
            }
            xVMHyperV "xVMHyperV$_" {
                AutomaticCheckpointsEnabled = $false
                DependsOn                   = "[xVHD]xVHD$_"
                EnableGuestService          = $true
                Ensure                      = $Ensure
                MinimumMemory               = $Node.MinimumMemory
                Name                        = $_
                ProcessorCount              = $Node.ProcessorCount
                RestartIfNeeded             = $true
                SwitchName                  = "Internal Switch"
                VhdPath                     = Join-Path -Path $Node.VirtualHardDisksPath -ChildPath "$_.vhdx"
            }
            if ($Ensure -eq "Present") {
                xVMDvdDrive "xVMDvdDriveWindows$_" {
                    ControllerLocation = 0
                    ControllerNumber   = 1
                    DependsOn          = "[xVMHyperV]xVMHyperV$_"
                    Ensure             = $Ensure
                    Path               = $Node.WindowsServerIsoPath
                    VMName             = $_
                }
                if ($_ -like "*SQL*") {
                    xVMDvdDrive "xVMDvdDriveSqlServer$_" {
                        ControllerLocation = 1
                        ControllerNumber   = 1
                        DependsOn          = "[xVMHyperV]xVMHyperV$_"
                        Ensure             = $Ensure
                        Path               = $Node.SqlServerIsoPath
                        VMName             = $_
                    }
                }
            }
        }
    }
}
