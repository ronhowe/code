@{
    Endpoints = @(
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "Application"
                Platform     = "FrontDoor"
                Uri          = "https://rhowe-fwbuh9b9cxbdhrgs.z01.azurefd.net:443"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "Application"
                Platform     = "Gateway"
                Uri          = "https://api-rhowe-000.azure-api.net:443/httpbin"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $true
            Endpoint = @{
                Name         = "WebApplication1"
                Platform     = "IIS"
                Uri          = "https://lab-web-01:443"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $true
            Endpoint = @{
                Name         = "WebApplication1"
                Platform     = "Kestrel"
                Uri          = "https://localhost:444"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "WebApplication1"
                Platform     = "Docker"
                Uri          = "TBD"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $true
            Endpoint = @{
                Name         = "WebApplication1"
                Platform     = "AppService"
                Uri          = "https://app-rhowe-idso-000.azurewebsites.net:443"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "WebApplication1"
                Platform     = "AppService"
                Uri          = "https://app-rhowe-1.azurewebsites.net:443"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "FunctionApp1"
                Platform     = "Kestrel"
                Uri          = "http://localhost:83/api"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "FunctionApp1"
                Platform     = "Docker"
                Uri          = "TBD"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $true
            Endpoint = @{
                Name         = "FunctionApp1"
                Platform     = "FunctionApp"
                Uri          = "https://func-rhowe-idso-000.azurewebsites.net"
                CustomHeader = "default"
            }
        }
    )
}
