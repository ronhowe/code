using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Polly;
using System.Diagnostics;
using System.Net;

namespace MyTestProject;

[TestClass]
public sealed class MyLiveTests
{
    [TestMethod]
    [TestCategory("LiveTest")]
    [DataTestMethod]
    [DataRow("https://app-ronhowe-0.azurewebsites.net:443/healthcheck", "MyHeader (Production)", HttpStatusCode.OK)]
    public void LiveSiteTests(string uriString, string headerValue, HttpStatusCode httpStatusCode)
    {
        // TODO: Read retry settings from configuration.
        const int _maxRetries = 2;
        const int _retryMilliseconds = 1;

        Debug.WriteLine("Creating Retry Policy");
        var retryPolicy = Policy
            .Handle<HttpRequestException>()
            .WaitAndRetryAsync(_maxRetries, retryAttempt => TimeSpan.FromMilliseconds(_retryMilliseconds),
                (ex, timeSpan, retryAttempt, context) =>
                {
                    Debug.WriteLine($"HTTP Request Failed Because {ex.Message}");
                    Debug.WriteLine($"Retry Attempt # {retryAttempt} Of {_maxRetries}");
                });

        var handler = new HttpClientHandler()
        {
#if DEBUG
            ServerCertificateCustomValidationCallback = HttpClientHandler.DangerousAcceptAnyServerCertificateValidator
#endif
        };

        using var client = new HttpClient(handler);

        using var response = retryPolicy.ExecuteAsync(async () =>
        {
            Debug.WriteLine($"Sending HTTP GET Request");
            return await client.GetAsync(new Uri(uriString));
        }).Result;

        Debug.WriteLine($"Asserting HTTP Status Code Is {httpStatusCode}");
        response.StatusCode.Should().Be(httpStatusCode);

        Debug.WriteLine($"Logging Headers");
        foreach (var header in response.Headers)
        {
            Debug.WriteLine($"{header.Key} = {header.Value.FirstOrDefault<string>()}");
        }

        Debug.WriteLine($"Asserting MyHeader Contains {headerValue}");
        response.Headers.Should().Contain(header => header.Key == "MyHeader" && header.Value.Contains(headerValue));

        Debug.WriteLine($"Asserting Health Check Is Healthy");
        (response.Content.ReadAsStringAsync().Result).Should().Be("Healthy");
    }
}
