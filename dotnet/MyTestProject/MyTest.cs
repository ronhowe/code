/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.FeatureManagement;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using MyClassLibrary;
using Serilog;
using Serilog.Events;
using System.Diagnostics;
using System.Net;

namespace MyTestProject;

[TestClass]
public sealed class MyTest
{
    [TestMethod]
    [TestCategory("IntegrationTest")]
    public void TestProjectHostTests()
    {
        /*******************************************************************************
        POST
        *******************************************************************************/

        const string _sourceContext = nameof(MyTest);
        const string _outputTemplate = "[{Level:u3}] {Message}{NewLine}{Exception}";

        Log.Logger = new LoggerConfiguration()
            .MinimumLevel.Verbose()
            .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
            .Enrich.FromLogContext()
            .Enrich.WithMachineName()
            .WriteTo.Console(outputTemplate: _outputTemplate)
            .CreateLogger();

        Log.ForContext("SourceContext", _sourceContext).Verbose($"POST (1 of 6) => Verbose Logging ON");
        Log.ForContext("SourceContext", _sourceContext).Debug($"POST (2 of 6) => Debug Logging ON");
        Log.ForContext("SourceContext", _sourceContext).Information($"POST (3 of 6) => Information Logging ON");
        Log.ForContext("SourceContext", _sourceContext).Warning($"POST (4 of 6) => Warning Logging ON");
        Log.ForContext("SourceContext", _sourceContext).Error($"POST (5 of 6) => Error Logging ON");
        Log.ForContext("SourceContext", _sourceContext).Fatal($"POST (6 of 6) => Fatal Logging ON");

        Log.ForContext("SourceContext", _sourceContext).Information($"OK");
        Log.ForContext("SourceContext", _sourceContext).Information($"{DateTime.Now} LOCAL");
        Log.ForContext("SourceContext", _sourceContext).Information($"{DateTime.UtcNow} UTC");

        Log.ForContext("SourceContext", _sourceContext).Debug($"Creating Service Collection");
        var serviceCollection = new ServiceCollection();

        /*******************************************************************************
        LOGGING
        *******************************************************************************/

        Log.ForContext("SourceContext", _sourceContext).Debug($"Adding Logging");
        serviceCollection.AddLogging(configure =>
        {
            Log.ForContext("SourceContext", _sourceContext).Debug($"Clearing Log Providers");
            configure.ClearProviders();

            Log.ForContext("SourceContext", _sourceContext).Debug($"Adding Serilog");
            configure.AddSerilog();

            var logLevel = LogLevel.Trace;
            Log.ForContext("SourceContext", _sourceContext).Debug($"Setting Minimum Log Level = {logLevel}");
            configure.SetMinimumLevel(logLevel);
        });

        /*******************************************************************************
        CONFIGURATION
        *******************************************************************************/

        Log.ForContext("SourceContext", _sourceContext).Debug($"Adding Configuration");
        var configurationSettings = new Dictionary<string, string?>
        {
            { "ConnectionStrings:MyDatabase", "Application Name=TestProjectHost;Server=localhost;Database=MyDatabase;Connect Timeout=1;Trusted_Connection=True;Encrypt=Optional;" },
            { "FeatureManagement:MyFeature", "true" },
            { "MyConfiguration", "TestProjectHost" },
            { "MySecret", "TestProjectHost" }
        };
        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(configurationSettings)
            .Build();
        serviceCollection.AddSingleton<IConfiguration>(configuration);

        /*******************************************************************************
        FEATURE MANAGEMENT
        *******************************************************************************/

        Log.ForContext("SourceContext", _sourceContext).Debug($"Adding Feature Management");
        serviceCollection.AddFeatureManagement();

        /*******************************************************************************
        REPOSITORY
        *******************************************************************************/

        Log.ForContext("SourceContext", _sourceContext).Debug($"Adding {nameof(MyRepository)}");
        serviceCollection.AddTransient<IMyRepository, MyRepository>();

        /*******************************************************************************
        SERVICE
        *******************************************************************************/

        Log.ForContext("SourceContext", _sourceContext).Debug($"Adding {nameof(MyService)}");
        serviceCollection.AddTransient<MyService>();

        /*******************************************************************************
        APPLICATION
        *******************************************************************************/

        Log.ForContext("SourceContext", _sourceContext).Debug($"Building Service Provider");
        var serviceProvider = serviceCollection.BuildServiceProvider();

        Log.ForContext("SourceContext", _sourceContext).Debug($"Getting {nameof(MyService)}");
        var myService = serviceProvider.GetService<MyService>();

        Log.ForContext("SourceContext", _sourceContext).Debug($"Calling {nameof(MyService)} with {Boolean.TrueString}");
        var result = myService?.MyMethod(true);

        Debug.WriteLine($"Asserting Result is {Boolean.TrueString}");
        result.Should().BeTrue();
    }

    [TestMethod]
    [TestCategory("IntegrationTest")]
    public async Task WebApplicationHostTests()
    {
        Debug.WriteLine($"Building Configuration");
        //var configurationSettings = new Dictionary<string, string?>
        //{
        //    { "ConnectionStrings:MyDatabase", "Application Name=WebApplicationHost;Server=localhost;Database=MyDatabase;Connect Timeout=1;Trusted_Connection=True;Encrypt=Optional;" },
        //    { "FeatureManagement:MyFeature", "true" },
        //    { "MyConfiguration", "WebApplicationHost" },
        //    { "MySecret", "WebApplicationHost" }
        //};

        Debug.WriteLine($"Building Web Application");
        using var application = new WebApplicationFactory<Program>().WithWebHostBuilder(builder =>
        {
            //builder.ConfigureAppConfiguration((context, configBuilder) =>
            //{
            //    configBuilder.AddInMemoryCollection(configurationSettings);
            //});
        });

        Debug.WriteLine($"Creating Web Application Client");
        using var client = application.CreateClient();

        Debug.WriteLine($"Calling Web Application with {Boolean.TrueString}");
        using var response = await client.GetAsync($"/api/{nameof(MyService)}?input={Boolean.TrueString}");

        Debug.WriteLine($"Asserting Response Status Code is {HttpStatusCode.OK}");
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        Debug.WriteLine($"Asserting Result is {Boolean.TrueString}");
        Boolean.Parse(response.Content.ReadAsStringAsync().Result).Should().BeTrue();
    }

    [TestMethod]
    [TestCategory("UnitTest")]
    [DataTestMethod]
    [DataRow(true)]
    [DataRow(false)]
    public void MockHostTests(bool value)
    {
        Debug.WriteLine($"Mocking {nameof(ILogger<MyService>)}");
        var mockLogger = new Mock<ILogger<MyService>>();

        Debug.WriteLine($"Mocking {nameof(IConfiguration)}");
        var mockConfiguration = new Mock<IConfiguration>();
        mockConfiguration.Setup(x => x["ConnectionStrings.MyDatabase"]).Returns("_MOCK_CONNECTION_STRING_");
        mockConfiguration.Setup(x => x["MySecret"]).Returns("_MOCK_SECRET_");

        Debug.WriteLine($"Mocking {nameof(IFeatureManager)}");
        var mockFeatureManager = new Mock<IFeatureManager>();
        mockFeatureManager.Setup(x => x.IsEnabledAsync("MyFeature").Result).Returns(value);

        Debug.WriteLine($"Mocking {nameof(IMyRepository)}");
        var mockRepository = new Mock<IMyRepository>();

        Debug.WriteLine($"Creating {nameof(MyService)}");
        var myService = new MyService(
            mockLogger.Object,
            mockConfiguration.Object,
            mockFeatureManager.Object,
            mockRepository.Object
        );

        Debug.WriteLine($"Calling {nameof(MyService)} with {value}");
        bool result = myService.MyMethod(value);

        Debug.WriteLine($"Asserting Result is {value}");
        result.Should().Be(value);

        Debug.WriteLine($"Asserting Log Message Exists for Enter");
        mockLogger.VerifyLogMessage($"Entering {nameof(MyService)}", LogLevel.Debug);

        Debug.WriteLine($"Asserting Log Message Exists for Input");
        mockLogger.VerifyLogMessage($"input = {value}", LogLevel.Trace);

        Debug.WriteLine($"Asserting Log Message Exists for Returning");
        mockLogger.VerifyLogMessage($"Returning {value}", LogLevel.Information);

        Debug.WriteLine($"Asserting Log Message Exists for Exiting");
        mockLogger.VerifyLogMessage($"Exiting {nameof(MyService)}", LogLevel.Debug);
    }

    [TestCleanup]
    public void TestCleanup()
    {
        Debug.WriteLine($"Cleaning Test");
        Debug.WriteLine($"{new string('*', 79)}/ ");
    }

    [TestInitialize]
    public void TestInitialize()
    {
        Debug.WriteLine($"/{new string('*', 79)}");
        Debug.WriteLine($"OK");
        Debug.WriteLine($"{DateTime.Now} LOCAL");
        Debug.WriteLine($"{DateTime.UtcNow} UTC");
        Debug.WriteLine($"Initializing Test");
    }
}

internal static class MockLoggerExtensions
{
    internal static Mock<ILogger<T>> VerifyLogMessage<T>(this Mock<ILogger<T>> logger, string expectedMessage, LogLevel expectedLogLevel)
    {
        ArgumentNullException.ThrowIfNull(expectedMessage);

        Func<object, Type, bool> state = (v, t) => v?.ToString()?.CompareTo(expectedMessage) == 0;

        logger.Verify(
            x => x.Log(
                It.Is<LogLevel>(l => l == expectedLogLevel),
                It.IsAny<EventId>(),
                It.Is<It.IsAnyType>((v, t) => state(v, t)),
                It.IsAny<Exception>(),
                It.Is<Func<It.IsAnyType, Exception?, string>>((v, t) => true)));

        return logger;
    }
}
