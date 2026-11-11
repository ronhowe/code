using Polly;
using Polly.Retry;
using Shouldly;
using System.Diagnostics;
using System.Net;

namespace MyTestProject10;

/// <summary>
/// Live endpoint tests for production environments (currently ignored).
/// </summary>
[TestClass]
public sealed class MyLiveTests : TestBase
{
    /// <summary>
    /// Tests live production endpoints (currently ignored).
    /// </summary>
    /// <param name="uriString">The endpoint URI to test.</param>
    /// <param name="headerValue">Expected custom header value.</param>
    /// <param name="httpStatusCode">Expected HTTP status code.</param>
    [Ignore]
    [TestMethod]
    [TestCategory("LiveTest")]
    //[DataRow("https://localhost:443/healthcheck", "MyHeader (Production)", HttpStatusCode.OK)]
    //[DataRow("https://lab-web-00:443/healthcheck", "MyHeader (Production)", HttpStatusCode.OK)]
    //[DataRow("https://app-ronhowe-0.azurewebsites.net:443/healthcheck", "MyHeader (Production)", HttpStatusCode.OK)]
    public async Task LiveSiteTests(string uriString, string headerValue, HttpStatusCode httpStatusCode)
    {
        const int maxRetries = 3;
        const int retryMilliseconds = 1000;

        AsyncRetryPolicy retryPolicy = Policy
            .Handle<HttpRequestException>()
            .WaitAndRetryAsync(maxRetries, retryAttempt => TimeSpan.FromMilliseconds(retryMilliseconds),
                (ex, timeSpan, retryAttempt, context) =>
                {
                    Debug.WriteLine($"Retry Attempt {retryAttempt} Of {maxRetries}");
                });

        HttpClientHandler handler = new()
        {
            ServerCertificateCustomValidationCallback = HttpClientHandler.DangerousAcceptAnyServerCertificateValidator
        };

        using HttpClient client = new(handler);

        using HttpResponseMessage response = await retryPolicy.ExecuteAsync(async () =>
            await client.GetAsync(new Uri(uriString), TestContext.CancellationToken));

        response.StatusCode.ShouldBe(httpStatusCode);
        response.Headers.Any(h => h.Key == "MyHeader" && h.Value.Contains(headerValue)).ShouldBeTrue();
        (await response.Content.ReadAsStringAsync(TestContext.CancellationToken)).ShouldBe("Healthy");
    }

    public TestContext TestContext { get; set; }
}
