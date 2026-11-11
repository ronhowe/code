using System.Diagnostics;

namespace MyTestProject10;

/// <summary>
/// Helper methods for logging raw HTTP requests and responses.
/// </summary>
internal static class HttpLoggingHelper
{
    /// <summary>
    /// Logs a raw HTTP request to the debug output.
    /// </summary>
    /// <param name="request">The HTTP request message.</param>
    /// <param name="cancellationToken">Cancellation token for async operations.</param>
    internal static async Task LogRawHttpRequest(HttpRequestMessage request, CancellationToken cancellationToken)
    {
        Debug.WriteLine(string.Empty);
        Debug.WriteLine("<<<<< RAW HTTP REQUEST BEGIN >>>>>");
        Debug.WriteLine($"{request.Method} {request.RequestUri} HTTP/1.1");

        foreach (KeyValuePair<string, IEnumerable<string>> header in request.Headers)
        {
            Debug.WriteLine($"{header.Key}: {string.Join(", ", header.Value)}");
        }

        if (request.Content is not null)
        {
            foreach (KeyValuePair<string, IEnumerable<string>> header in request.Content.Headers)
            {
                Debug.WriteLine($"{header.Key}: {string.Join(", ", header.Value)}");
            }

            string body = await request.Content.ReadAsStringAsync(cancellationToken);
            if (!string.IsNullOrEmpty(body))
            {
                Debug.WriteLine(string.Empty);
                Debug.WriteLine(body);
            }
        }

        Debug.WriteLine("<<<<< RAW HTTP REQUEST END >>>>>");
        Debug.WriteLine(string.Empty);
    }

    /// <summary>
    /// Logs a raw HTTP response to the debug output.
    /// </summary>
    /// <param name="response">The HTTP response message.</param>
    /// <param name="cancellationToken">Cancellation token for async operations.</param>
    internal static async Task LogRawHttpResponse(HttpResponseMessage response, CancellationToken cancellationToken)
    {
        string responseBody = await response.Content.ReadAsStringAsync(cancellationToken);

        Debug.WriteLine(string.Empty);
        Debug.WriteLine(">>>>> RAW HTTP RESPONSE BEGIN <<<<<");
        Debug.WriteLine($"HTTP/{response.Version} {(int)response.StatusCode} {response.ReasonPhrase}");

        foreach (KeyValuePair<string, IEnumerable<string>> header in response.Headers)
        {
            Debug.WriteLine($"{header.Key}: {string.Join(", ", header.Value)}");
        }

        foreach (KeyValuePair<string, IEnumerable<string>> header in response.Content.Headers)
        {
            Debug.WriteLine($"{header.Key}: {string.Join(", ", header.Value)}");
        }

        if (!string.IsNullOrEmpty(responseBody))
        {
            Debug.WriteLine(string.Empty);
            Debug.WriteLine(responseBody);
        }

        Debug.WriteLine(">>>>> RAW HTTP RESPONSE END <<<<<");
        Debug.WriteLine(string.Empty);
    }
}
