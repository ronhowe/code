/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using FluentAssertions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.FeatureManagement;
using Moq;
using MyClassLibrary;
using Serilog;
using Serilog.Events;
using System.Diagnostics;

namespace MyTestProject;

[TestClass]
public sealed class MyTest
{
    [TestMethod]
    [TestCategory("IntegrationTest")]
    public void IntegrationTest()
    {
        /*******************************************************************************
        POST
        *******************************************************************************/

        const string _sourceContext = nameof(MyTest);
        const string _outputTemplate = "{Message}{NewLine}{Exception}";
        //const string _outputTemplate = "[{Timestamp:yyyy-MM-dd @ HH:mm:ss.fff}] [{Level:u3}] [{MachineName}] [{SourceContext}] {Message}{NewLine}{Exception}"

        Log.Logger = new LoggerConfiguration()
            //.MinimumLevel.Verbose()
            .MinimumLevel.Debug()
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

        Log.ForContext("SourceContext", _sourceContext).Debug("Creating Service Collection");
        var serviceCollection = new ServiceCollection();

        /*******************************************************************************
        LOGGING
        *******************************************************************************/

        Log.ForContext("SourceContext", _sourceContext).Debug("Adding Logging");
        serviceCollection.AddLogging(configure =>
        {
            Log.ForContext("SourceContext", _sourceContext).Debug("Clearing Log Providers");
            configure.ClearProviders();

            Log.ForContext("SourceContext", _sourceContext).Debug("Adding Serilog");
            configure.AddSerilog();

            var logLevel = LogLevel.Trace;
            Log.ForContext("SourceContext", _sourceContext).Debug($"Setting Minimum Log Level = {logLevel}");
            configure.SetMinimumLevel(logLevel);
        });

        /*******************************************************************************
        CONFIGURATION
        *******************************************************************************/

        Log.ForContext("SourceContext", _sourceContext).Debug("Adding Configuration");
        var configurationSettings = new Dictionary<string, string?>
        {
            { "MyMessage", "OK" },
            { "ConnectionStrings:MyDatabase", "Application Name=MyTestProject;Server=localhost;Database=MyDatabase;Connect Timeout=1;Trusted_Connection=True;Encrypt=Optional;" },
            { "FeatureManagement:MyFeature", "true" }
        };
        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(configurationSettings)
            .Build();
        serviceCollection.AddSingleton<IConfiguration>(configuration);

        /*******************************************************************************
        FEATURE MANAGEMENT
        *******************************************************************************/

        Log.ForContext("SourceContext", _sourceContext).Debug("Adding Feature Management");
        serviceCollection.AddFeatureManagement();

        /*******************************************************************************
        REPOSITORY
        *******************************************************************************/

        Log.ForContext("SourceContext", _sourceContext).Debug("Adding MyRepository");
        serviceCollection.AddTransient<IMyRepository, MyRepository>();

        /*******************************************************************************
        SERVICE
        *******************************************************************************/

        Log.ForContext("SourceContext", _sourceContext).Debug("Adding MyService");
        serviceCollection.AddTransient<MyService>();

        /*******************************************************************************
        APPLICATION
        *******************************************************************************/

        Log.ForContext("SourceContext", _sourceContext).Debug("Building Service Provider");
        var serviceProvider = serviceCollection.BuildServiceProvider();

        Log.ForContext("SourceContext", _sourceContext).Debug("Getting MyService");
        var myService = serviceProvider.GetService<MyService>();

        Log.ForContext("SourceContext", _sourceContext).Debug("Calling MyService");
        myService?.MyMethod(true).Should().BeTrue();
    }

    [TestMethod]
    [TestCategory("UnitTest")]
    [DataTestMethod]
    [DataRow(true)]
    [DataRow(false)]
    public void UnitTest(bool value)
    {
        Debug.WriteLine("Mocking Logger");
        var mockLogger = new Mock<ILogger<MyService>>();

        Debug.WriteLine("Mocking Configuration");
        var mockConfiguration = new Mock<IConfiguration>();
        mockConfiguration.Setup(x => x["ConnectionStrings.MyDatabase"]).Returns("MOCK_CONNECTION_STRING");

        Debug.WriteLine("Mocking Featurer Manager");
        var mockFeatureManager = new Mock<IFeatureManager>();
        mockFeatureManager.Setup(x => x.IsEnabledAsync("MyFeature").Result).Returns(value);

        Debug.WriteLine("Mocking Repository");
        var mockRepository = new Mock<IMyRepository>();

        Debug.WriteLine("Creating MyService");
        var myService = new MyService(
            mockLogger.Object,
            mockConfiguration.Object,
            mockFeatureManager.Object,
            mockRepository.Object
        );

        Debug.WriteLine($"Calling MyService with {value}");
        bool result = myService.MyMethod(value);

        Debug.WriteLine($"Asserting Result of {value}");
        result.Should().Be(value);

        Debug.WriteLine("Asserting Enter Log Message");
        mockLogger.VerifyLogMessage($"Entering {nameof(MyService)}", LogLevel.Debug);

        Debug.WriteLine("Asserting Input Log Message");
        mockLogger.VerifyLogMessage($"$input = {value}", LogLevel.Trace);

        Debug.WriteLine("Asserting Returning Log Message");
        mockLogger.VerifyLogMessage($"Returning {value}", LogLevel.Information);

        Debug.WriteLine("Asserting Exiting Log Message");
        mockLogger.VerifyLogMessage($"Exiting {nameof(MyService)}", LogLevel.Debug);
    }

    [TestCleanup]
    public void TestCleanup()
    {
        Debug.WriteLine("Cleaning Test");
    }

    [TestInitialize]
    public void TestInitialize()
    {
        Debug.WriteLine("Initializing Test");
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
