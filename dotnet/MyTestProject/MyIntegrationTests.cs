/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using FluentAssertions;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.FeatureManagement;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using MyClassLibrary;
using Serilog;
using Serilog.Events;
using System.Diagnostics;
using System.Net;

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
            { "MySecret", "MyTestProject" }
        };
        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(configurationSettings)
            .Build();
        serviceCollection.AddSingleton<IConfiguration>(configuration);

        Log.ForContext("SourceContext", _sourceContext).Debug("Adding Feature Management");
        serviceCollection.AddFeatureManagement();

        Log.ForContext("SourceContext", _sourceContext).Debug("Adding {name}", nameof(MyRepository));
        // TODO: Learn the difference between AddSingleton and AddTransient.
        serviceCollection.AddTransient<IMyRepository, MyRepository>();

        Log.ForContext("SourceContext", _sourceContext).Debug("Adding {name}", nameof(MyService));
        // TODO: Learn the difference between AddSingleton and AddTransient.
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
    [DataRow(false, "Development")]
    [DataRow(true, "Development")]
    [DataRow(false, "Production")]
    [DataRow(true, "Production")]
    public async Task WebHostTests(bool value, string environmentName)
    {
        Debug.WriteLine("Building Web Host");
        using var application = new WebApplicationFactory<Program>().WithWebHostBuilder(builder =>
        {
            builder.UseEnvironment(environmentName);
        });

        Debug.WriteLine("Creating Client");
        using var client = application.CreateClient();

        Debug.WriteLine($"Sending GET Request With {value}");
        using var response = await client.GetAsync($"/api/{nameof(MyService)}?input={value}");

        Debug.WriteLine($"Asserting HTTP Status Code Is {HttpStatusCode.OK}");
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        Debug.WriteLine($"Asserting Result Is {value}");
        Boolean.Parse(response.Content.ReadAsStringAsync().Result).Should().Be(value);
    }
}
