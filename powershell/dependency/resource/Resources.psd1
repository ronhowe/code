@{
    Resources = @(
        # Sync with GuestDsc.ps1 and Install-GuestDscResources.ps1.
        # https://github.com/dsccommunity/ActiveDirectoryCSDsc
        @{ Name = 'ActiveDirectoryCSDsc' ; Version = '5.0.0' ; Repository = 'PSGallery' },
        # https://github.com/dsccommunity/ActiveDirectoryDsc
        @{ Name = 'ActiveDirectoryDsc' ; Version = '6.7.1' ; Repository = 'PSGallery' },
        # https://github.com/dsccommunity/ComputerManagementDsc
        @{ Name = 'ComputerManagementDsc' ; Version = '10.0.0' ; Repository = 'PSGallery' },
        # https://github.com/dsccommunity/NetworkingDsc
        @{ Name = 'NetworkingDsc' ; Version = '9.1.0' ; Repository = 'PSGallery' },
        # https://github.com/dsccommunity/SecurityPolicyDsc
        @{ Name = 'SecurityPolicyDsc' ; Version = '2.10.0.0' ; Repository = 'PSGallery' },
        # https://github.com/dsccommunity/SqlServerDsc/tree/main
        @{ Name = 'SqlServerDsc' ; Version = '17.5.1' ; Repository = 'PSGallery' },
        # https://github.com/dsccommunity/HyperVDsc
        @{ Name = 'xHyper-V' ; Version = '3.18.0' ; Repository = 'PSGallery' }
    )
}
