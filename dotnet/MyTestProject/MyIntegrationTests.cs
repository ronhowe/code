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
using Serilog.Events;
using System.Diagnostics;
using System.IdentityModel.Tokens.Jwt;
using System.Net;
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
        const string _outputTemplate = "[{Level:u3}] [{SourceContext}] {Message}{NewLine}{Exception}";
        const string _sourceContext = nameof(MyTests);

        Log.Logger = new LoggerConfiguration()
            .MinimumLevel.Verbose()
            .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
            .Enrich.FromLogContext()
            .Enrich.WithMachineName()
            .WriteTo.Console(outputTemplate: _outputTemplate)
            .CreateLogger();

        Log.ForContext("SourceContext", _sourceContext).Verbose("POST (1 of 6) => Verbose Logging ON");
        Log.ForContext("SourceContext", _sourceContext).Debug("POST (2 of 6) => Debug Logging ON");
        Log.ForContext("SourceContext", _sourceContext).Information("POST (3 of 6) => Information Logging ON");
        Log.ForContext("SourceContext", _sourceContext).Warning("POST (4 of 6) => Warning Logging ON");
        Log.ForContext("SourceContext", _sourceContext).Error("POST (5 of 6) => Error Logging ON");
        Log.ForContext("SourceContext", _sourceContext).Fatal("POST (6 of 6) => Fatal Logging ON");
        Log.ForContext("SourceContext", _sourceContext).Information("{now} (LOCAL)", DateTime.Now);
        Log.ForContext("SourceContext", _sourceContext).Information("{utcNow} (UTC)", DateTime.UtcNow);

        Log.ForContext("SourceContext", _sourceContext).Debug("Creating Service Collection");
        var serviceCollection = new ServiceCollection();

        Log.ForContext("SourceContext", _sourceContext).Debug("Adding Logging");
        serviceCollection.AddLogging(configure =>
        {
            Log.ForContext("SourceContext", _sourceContext).Debug("Clearing Log Providers");
            configure.ClearProviders();

            Log.ForContext("SourceContext", _sourceContext).Debug("Adding Serilog");
            configure.AddSerilog();

            var logLevel = LogLevel.Trace;
            Log.ForContext("SourceContext", _sourceContext).Debug("Setting Minimum Log Level = {logLevel}", logLevel);
            configure.SetMinimumLevel(logLevel);
        });

        Log.ForContext("SourceContext", _sourceContext).Debug("Adding Configuration");
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

        Log.ForContext("SourceContext", _sourceContext).Debug("Adding Feature Management");
        serviceCollection.AddFeatureManagement();

        Log.ForContext("SourceContext", _sourceContext).Debug("Adding {name}", nameof(MyRepository));
        serviceCollection.AddTransient<IMyRepository, MyRepository>();

        Log.ForContext("SourceContext", _sourceContext).Debug("Adding {name}", nameof(MyService));
        serviceCollection.AddTransient<MyService>();

        Log.ForContext("SourceContext", _sourceContext).Debug("Building Service Provider");
        var serviceProvider = serviceCollection.BuildServiceProvider();

        Log.ForContext("SourceContext", _sourceContext).Debug("Getting {name}", nameof(MyService));
        var myService = serviceProvider.GetService<MyService>();

        Log.ForContext("SourceContext", _sourceContext).Debug("Calling {name} With {value}", nameof(MyService), value);
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
        Debug.WriteLine("Building Web Host");
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

        Debug.WriteLine("Creating Client");
        using var client = application.CreateClient(new WebApplicationFactoryClientOptions
        {
            BaseAddress = new Uri("https://localhost:5001")
        });

        Debug.WriteLine("Generating Bearer Token");
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.UTF8.GetBytes($"/{new string('*', 4096 / 8)}");
        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity([new Claim("sub", "testuser")]),
            Expires = DateTime.UtcNow.AddMinutes(30),
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature),
            Issuer = "yourIssuer",
            Audience = "yourAudience"
        };

        // TODO: Decide on naming standard for variables, fields, etc.
        var _token = tokenHandler.CreateToken(tokenDescriptor);
        var _tokenString = tokenHandler.WriteToken(_token);
        Debug.WriteLine(_tokenString);

        Debug.WriteLine($"Sending GET Request With {value}");
        client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _tokenString);
        using var response = await client.GetAsync($"/v{version}/{nameof(MyService)}?input={value}");

        Debug.WriteLine($"Asserting HTTP Status Code Is {HttpStatusCode.OK}");
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        foreach (var header in response.Headers)
        {
            Debug.WriteLine($"{header.Key}: {string.Join(", ", header.Value)}");
        }

        Debug.WriteLine("Asserting Header");
        if (response.Headers.TryGetValues("MyHeader", out var values))
        {
            values.First().Should<string>().Be($"MyHeader ({environmentName})");
        }

        Debug.WriteLine("Asserting API Supported Versions Header");
        if (response.Headers.TryGetValues("api-supported-versions", out var values2))
        {
            values2.First().Should<string>().Be("1, 2");
        }

        Debug.WriteLine($"Asserting Result Is {value}");
        Boolean.Parse(response.Content.ReadAsStringAsync().Result).Should().Be(value);
    }
}
