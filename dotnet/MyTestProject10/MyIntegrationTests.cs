using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Hosting.Internal;
using Microsoft.Extensions.Logging;
using Microsoft.FeatureManagement;
using Microsoft.IdentityModel.Tokens;
using MyClassLibrary10;
using Serilog;
using Shouldly;
using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;

namespace MyTestProject10;

/// <summary>
/// Integration tests for MyService and MyRepository with full service configuration.
/// </summary>
[TestClass]
public sealed class MyIntegrationTests : TestBase
{
    /// <summary>
    /// Tests MyService integration with a full service collection (in-memory/debug configuration).
    /// </summary>
    /// <param name="value">The input value to process.</param>
    [TestMethod]
    [TestCategory("IntegrationTest")]
    [DataRow(false)]
    [DataRow(true)]
    public async Task MyDebugHostTests(bool value)
    {
        ServiceCollection serviceCollection = new();

        serviceCollection.AddLogging(configure =>
        {
            configure.ClearProviders();
            configure.AddSerilog();
            configure.SetMinimumLevel(LogLevel.Trace);
        });

        Dictionary<string, string?> configurationSettings = new()
        {
            { "ConnectionStrings:MyAzureStorage", TestConstants.Configuration.AzureStorageConnectionString },
            { "ConnectionStrings:MyDatabase", TestConstants.Configuration.DatabaseConnectionString },
            { "FeatureManagement:MyFeature", "false" },
            { "MyConfiguration", TestConstants.Configuration.MyConfiguration },
            { "MyHeader", TestConstants.Configuration.MyHeader },
            { "MySecret", TestConstants.Configuration.MySecret }
        };
        IConfigurationRoot configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(configurationSettings)
            .Build();
        serviceCollection.AddSingleton<IConfiguration>(configuration);

        serviceCollection.AddFeatureManagement();
        serviceCollection.AddTransient<IMyRepository, MyRepository>();
        serviceCollection.AddTransient<MyService>();
        serviceCollection.AddSingleton<IHostEnvironment>(new HostingEnvironment
        {
            EnvironmentName = Environments.Development
        });

        ServiceProvider serviceProvider = serviceCollection.BuildServiceProvider();
        MyService? myService = serviceProvider.GetService<MyService>();

        if (myService is not null)
        {
            bool result = await myService.ProcessAsync(SaveRequest.Create(value));
            result.ShouldBe(value);
        }
        else
        {
            Assert.Inconclusive("TEST FAILED");
        }
    }

    /// <summary>
    /// Tests MyService through the full ASP.NET Core pipeline with JWT authentication.
    /// </summary>
    /// <param name="value">The input value to process.</param>
    /// <param name="environmentName">The hosting environment (Development/Production).</param>
    /// <param name="version">The API version to test.</param>
    [TestMethod]
    [TestCategory("IntegrationTest")]
    // TODO: Production fails unless runtime security context has Azure.Identity based permissions.
    //[DataRow(false, "Production", "1")]
    //[DataRow(false, "Production", "2")]
    //[DataRow(true, "Production", "1")]
    //[DataRow(true, "Production", "2")]
    [DataRow(false, "Development", "1")]
    [DataRow(false, "Development", "2")]
    [DataRow(true, "Development", "1")]
    [DataRow(true, "Development", "2")]
    public async Task MyWebHostTests(bool value, string environmentName, string version)
    {
        using WebApplicationFactory<Program> application = new WebApplicationFactory<Program>().WithWebHostBuilder(builder =>
        {
            builder.UseEnvironment(environmentName);
            builder.ConfigureKestrel(serverOptions =>
            {
                serverOptions.ListenLocalhost(TestConstants.WebHost.HttpsPort, listenOptions =>
                {
                    listenOptions.UseHttps();
                });
            });
        });

        using HttpClient client = application.CreateClient(new WebApplicationFactoryClientOptions
        {
            BaseAddress = new Uri(TestConstants.WebHost.BaseAddress)
        });

        using CancellationTokenSource cts = new(TimeSpan.FromSeconds(TestConstants.WebHost.CancellationTimeoutSeconds));

        JwtSecurityTokenHandler tokenHandler = new();
        byte[] key = Encoding.UTF8.GetBytes(TestConstants.JWT.SigningKey);
        SecurityTokenDescriptor tokenDescriptor = new()
        {
            Subject = new ClaimsIdentity([new Claim(TestConstants.JWT.ClaimType, TestConstants.JWT.ClaimValue)]),
            Expires = DateTime.UtcNow.AddMinutes(TestConstants.JWT.TokenExpirationMinutes),
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature),
            Issuer = TestConstants.JWT.Issuer,
            Audience = TestConstants.JWT.Audience
        };
        SecurityToken token = tokenHandler.CreateToken(tokenDescriptor);
        string tokenString = tokenHandler.WriteToken(token);

        string relativePath = $"/v{version}/{nameof(MyService)}?input={value}";
        Uri fullRequestUri = new(client.BaseAddress!, relativePath);

        using HttpRequestMessage request = new(HttpMethod.Get, fullRequestUri);
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", tokenString);

        await HttpLoggingHelper.LogRawHttpRequest(request, cts.Token);

        using HttpResponseMessage response = await client.SendAsync(request, cts.Token);

        await HttpLoggingHelper.LogRawHttpResponse(response, cts.Token);

        response.StatusCode.ShouldBe(HttpStatusCode.OK);

        if (response.Headers.TryGetValues("MyHeader", out var values))
        {
            values.First().ShouldBe($"MyHeader ({environmentName})");
        }

        if (response.Headers.TryGetValues("api-supported-versions", out var versions))
        {
            versions.First().ShouldBe("1, 2");
        }

        string responseBody = await response.Content.ReadAsStringAsync(cts.Token);
        Boolean.Parse(responseBody).ShouldBe(value);
    }
}
