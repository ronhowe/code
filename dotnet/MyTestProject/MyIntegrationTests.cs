using FluentAssertions;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.FeatureManagement;
using Microsoft.IdentityModel.Tokens;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using MyClassLibrary;
using Serilog;
using System.Diagnostics;
using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;

namespace MyTestProject;

[TestClass]
public sealed class MyIntegrationTests : TestBase
{
    [TestMethod]
    [TestCategory("IntegrationTest")]
    [DataTestMethod]
    [DataRow(false)]
    [DataRow(true)]
    public void DebugHostTests(bool value)
    {
        Debug.WriteLine($"Creating Service Collection");
        var serviceCollection = new ServiceCollection();

        Debug.WriteLine($"Adding Logging");
        serviceCollection.AddLogging(configure =>
        {
            Debug.WriteLine($"Clearing Log Providers");
            configure.ClearProviders();

            Debug.WriteLine($"Adding Serilog");
            configure.AddSerilog();

            var _logLevel = LogLevel.Trace;
            Debug.WriteLine($"Setting Minimum Log Level = {_logLevel}");
            configure.SetMinimumLevel(_logLevel);
        });

        Debug.WriteLine($"Adding Configuration");
        var configurationSettings = new Dictionary<string, string?>
        {
            { "ConnectionStrings:MyAzureStorage", "UseDevelopmentStorage=true;" },
            { "ConnectionStrings:MyDatabase", "Server=LOCALHOST;Database=MyDatabase;Integrated Security=True;Application Name=MyTestProject;Encrypt=False;Connect Timeout=1;Command Timeout=0;" },
            { "FeatureManagement:MyFeature", $"{value}" },
            { "MyConfiguration", "MyTestProject" },
            { "MyHeader", "MyHeader" },
            { "MySecret", "MyTestProject" }
        };
        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(configurationSettings)
            .Build();
        serviceCollection.AddSingleton<IConfiguration>(configuration);

        Debug.WriteLine($"Adding Feature Management");
        serviceCollection.AddFeatureManagement();

        Debug.WriteLine($"Adding {nameof(MyRepository)}");
        serviceCollection.AddTransient<IMyRepository, MyRepository>();

        Debug.WriteLine($"Adding {nameof(MyService)}");
        serviceCollection.AddTransient<MyService>();

        Debug.WriteLine($"Building Service Provider");
        var serviceProvider = serviceCollection.BuildServiceProvider();

        Debug.WriteLine($"Getting {nameof(MyService)}");
        var myService = serviceProvider.GetService<MyService>();

        Debug.WriteLine($"Calling {nameof(MyService)} With {value}");
        var result = myService?.MyMethod(value);

        Debug.WriteLine($"Asserting Result Is {value}");
        result.Should().Be(value);
    }

    [TestMethod]
    [TestCategory("IntegrationTest")]
    [DataTestMethod]
    [DataRow(false, "Development", "1")]
    [DataRow(false, "Development", "2")]
    [DataRow(false, "Production", "1")]
    [DataRow(false, "Production", "2")]
    [DataRow(true, "Development", "1")]
    [DataRow(true, "Development", "2")]
    [DataRow(true, "Production", "1")]
    [DataRow(true, "Production", "2")]
    public async Task WebHostTests(bool value, string environmentName, string version)
    {
        Debug.WriteLine($"Building Web Host");
        using var application = new WebApplicationFactory<Program>().WithWebHostBuilder(builder =>
        {
            builder.UseEnvironment(environmentName);
            builder.ConfigureKestrel(serverOptions =>
            {
                serverOptions.ListenLocalhost(5001, listenOptions =>
                {
                    listenOptions.UseHttps();
                });
            });
        });

        Debug.WriteLine($"Creating Client");
        using var client = application.CreateClient(new WebApplicationFactoryClientOptions
        {
            BaseAddress = new Uri("https://localhost:5001")
        });

        // TODO: Decide on naming standard for variables, fields, etc.
        Debug.WriteLine($"Generating Bearer Token");
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.UTF8.GetBytes($"/{new string('*', 4096 / 8)}");
        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity([new Claim("MyClaimType", "MyClaimValue")]),
            Expires = DateTime.UtcNow.AddMinutes(30),
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature),
            Issuer = "yourIssuer",
            Audience = "yourAudience"
        };
        var _token = tokenHandler.CreateToken(tokenDescriptor);
        var _tokenString = tokenHandler.WriteToken(_token);
        Debug.WriteLine(_tokenString);

        Debug.WriteLine($"Sending GET Request With {value}");
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", _tokenString);
        using var response = await client.GetAsync($"/v{version}/{nameof(MyService)}?input={value}");

        Debug.WriteLine($"Asserting HTTP Status Code Is {HttpStatusCode.OK}");
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        foreach (var header in response.Headers)
        {
            Debug.WriteLine($"{header.Key}: {string.Join(", ", header.Value)}");
        }

        Debug.WriteLine($"Asserting Header");
        if (response.Headers.TryGetValues("MyHeader", out var values))
        {
            values.First().Should<string>().Be($"MyHeader ({environmentName})");
        }

        Debug.WriteLine($"Asserting API Supported Versions Header");
        if (response.Headers.TryGetValues("api-supported-versions", out var values2))
        {
            values2.First().Should<string>().Be("1, 2");
        }

        Debug.WriteLine($"Asserting Result Is {value}");
        Boolean.Parse(response.Content.ReadAsStringAsync().Result).Should().Be(value);
    }
}
