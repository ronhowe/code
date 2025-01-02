#requires -Module "Pester"
#requires -Module "PSPolly"

param(
    [Parameter(Mandatory = $false)]
    [string]$Name = "MyWebApplication",

    [Parameter(Mandatory = $false)]
    [string]$Platform = "Kestrel",

    [Parameter(Mandatory = $false)]
    [Uri]$Uri = "https://localhost:444",

    [Parameter(Mandatory = $false)]
    [string]$Header = "MyHeader"
)
Describe "API Tests" {
    BeforeAll {
        Write-Host "$([DateTime]::Now.ToString(`"yyyy-MM-dd HH:mm:ss.fff`")) (LOCAL)"
        Write-Host "$([DateTime]::UtcNow.ToString(`"yyyy-MM-dd HH:mm:ss.fff`")) (UTC)"
    }
    Context "<Name> (<Platform>) @ <Uri> MyHealthCheck" {
        It "Asserting Response Status Code Is 200" -Tag @("healthcheck") {
            $policy = New-PollyPolicy -Retry -RetryCount 10 -RetryWait (New-TimeSpan -Seconds 1)
            Invoke-PollyCommand -Policy $policy -ScriptBlock {
                Write-Host "`tInvoking Web Request With Retry" -ForegroundColor DarkGray
                $response = Invoke-WebRequest -Uri "$Uri/healthcheck" -SkipCertificateCheck
                $response.StatusCode | Should -Be 200
            }
        }
        It "Asserting Response Content Code Is Healthy" -Tag @("healthcheck") {
            $policy = New-PollyPolicy -Retry -RetryCount 10 -RetryWait (New-TimeSpan -Seconds 1)
            Invoke-PollyCommand -Policy $policy -ScriptBlock {
                Write-Host "`tInvoking Web Request With Retry" -ForegroundColor DarkGray
                $response = Invoke-WebRequest -Uri "$Uri/healthcheck" -SkipCertificateCheck
                $response.Content | Should -Be "Healthy"
            }
        }
    }
    Context "<Name> (<Platform>) @ <Uri> MyService" {
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
}
