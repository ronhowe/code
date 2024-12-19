#requires -Module "Pester"
#requires -Module "PSPolly"
#requires -Module "WriteAscii"

param(
    [Parameter(Mandatory = $false)]
    [string]$Name = "MyWebApplication",

    [Parameter(Mandatory = $false)]
    [string]$Platform = "Kestrel",

    [Parameter(Mandatory = $false)]
    [Uri]$Uri = "https://LOCALHOST:444",

    [Parameter(Mandatory = $false)]
    [string]$Header = "MyHeader"
)
Describe "API Tests" {
    BeforeAll {
        Write-Host "$((Get-Date).ToString()) (LOCAL)" -ForegroundColor Yellow
        Write-Host "$((Get-Date -AsUTC).ToString()) (UTC)" -ForegroundColor Yellow
    }
    Context "<Name> (<Platform>) @ <Uri>" {
        # It "ClientRetries" -Tag @("healthcheck") {
        #     $policy = New-PollyPolicy -Retry -RetryCount 10 -RetryWait (New-TimeSpan -Seconds 1)
        #     Invoke-PollyCommand -Policy $policy -ScriptBlock {
        #         Write-Host "`tInvoking Web Request within Polly Policy.." -ForegroundColor DarkGray
        #         $response = Invoke-WebRequest -Uri "$Uri/health" -SkipCertificateCheck
        #         $response.StatusCode | Should -Be 200
        #     }
        # }
        It "Asserting Response Status Code Is 200" -Tag @("application") {
            $response = Invoke-WebRequest -Uri "$Uri/v1/MyService?input=false" -SkipCertificateCheck
            $response.StatusCode | Should -Be 200
        }
        It "Asserting Response Content Is False" -Tag @("application") {
            $response = Invoke-WebRequest -Uri "$Uri/v1/MyService?input=false" -SkipCertificateCheck
            $response.Content | Should -Be "false"
        }
        It "Asserting Response Headers Include [<Header>]" -Tag @("application") {
            $response = Invoke-WebRequest -Uri "$Uri/v1/MyService?input=false" -SkipCertificateCheck
            $response.Headers["MyHeader"] | Should -Be $Header
        }
    }
    AfterAll {
        Write-Ascii $Name
    }
}
