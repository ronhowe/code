@{
    Endpoints = @(
        @{
            Enabled  = $false
            Endpoint = @{
                Name     = "Application"
                Platform = "FrontDoor"
                Uri      = "https://rhowe-fwbuh9b9cxbdhrgs.z01.azurefd.net:443"
                Header   = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name     = "Application"
                Platform = "Gateway"
                Uri      = "https://api-rhowe-000.azure-api.net:443/httpbin"
                Header   = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name     = "WebApplication1"
                Platform = "IIS"
                Uri      = "https://lab-web-01:443"
                Header   = "default"
            }
        }
        @{
            Enabled  = $true
            Endpoint = @{
                Name     = "MyWebApplication"
                Platform = "Kestrel"
                Uri      = "https://LOCALHOST:444"
                Header   = "MyHeader (Development)"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name     = "WebApplication1"
                Platform = "Docker"
                Uri      = "TBD"
                Header   = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name     = "WebApplication1"
                Platform = "AppService"
                Uri      = "https://app-rhowe-idso-000.azurewebsites.net:443"
                Header   = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name     = "WebApplication1"
                Platform = "AppService"
                Uri      = "https://app-rhowe-1.azurewebsites.net:443"
                Header   = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name     = "FunctionApp1"
                Platform = "Kestrel"
                Uri      = "http://LOCALHOST:83/api"
                Header   = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name     = "FunctionApp1"
                Platform = "Docker"
                Uri      = "TBD"
                Header   = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name     = "FunctionApp1"
                Platform = "FunctionApp"
                Uri      = "https://func-rhowe-idso-000.azurewebsites.net"
                Header   = "default"
            }
        }
    )
}
