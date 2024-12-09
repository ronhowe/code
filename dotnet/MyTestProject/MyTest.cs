/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using FluentAssertions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Console;
using Microsoft.FeatureManagement;
using Moq;
using MyClassLibrary;
using System.Diagnostics;

namespace MyTestProject;

[TestClass]
public sealed class MyTest
{
    [TestMethod]
    [TestCategory("IntegrationTest")]
    public void IntegrationTest()
    {
        Debug.WriteLine($"Creating Service Collection");
        var serviceCollection = new ServiceCollection();

        /*******************************************************************************
        LOGGERS
        *******************************************************************************/

        Debug.WriteLine($"Adding Logging");
        serviceCollection.AddLogging(configure =>
        {
            Debug.WriteLine($"Clearing Log Providers");
            configure.ClearProviders();

            Debug.WriteLine($"Adding Simple Console Logger");
            configure.AddSimpleConsole(options =>
            {
                options.ColorBehavior = LoggerColorBehavior.Disabled;
                options.SingleLine = true;
                options.TimestampFormat = "yyyy-MM-dd HH:mm:ss ";
                options.UseUtcTimestamp = true;
            });

            var logLevel = LogLevel.Trace;
            Debug.WriteLine($"Setting Minimum Log Level = {logLevel}");
            configure.SetMinimumLevel(logLevel);

        });

        /*******************************************************************************
        CONFIGURATIONS
        *******************************************************************************/

        Debug.WriteLine($"Adding Configuration");
        var configurationSettings = new Dictionary<string, string?>
        {
            { "ConnectionStrings:MyDatabase", "Application Name=MyClassLibraryTests;Server=localhost;Database=MyDatabase;Connect Timeout=1;Trusted_Connection=True;Encrypt=Optional;" },
            { "MyCommand", "INSERT [dbo].[MyTable] ([Value]) VALUES (@Value);" },
            { "FeatureManagement:MyFeature", "true" }
        };
        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(configurationSettings)
            .Build();

        serviceCollection.AddSingleton<IConfiguration>(configuration);

        /*******************************************************************************
        FEATURES
        *******************************************************************************/

        Debug.WriteLine($"Adding Features");
        serviceCollection.AddFeatureManagement();

        /*******************************************************************************
        SERVICES
        *******************************************************************************/

        Debug.WriteLine($"Adding Service");
        serviceCollection.AddTransient<MyService>();

        Debug.WriteLine("Building Service Provider");
        var serviceProvider = serviceCollection.BuildServiceProvider();

        Debug.WriteLine("Getting MyService");
        var myService = serviceProvider.GetService<MyService>();

        Debug.WriteLine($"Calling MyService");
        myService?.MyMethod(true).Should().BeTrue();
    }

    [TestMethod]
    [TestCategory("UnitTest")]
    [DataTestMethod]
    [DataRow(true)]
    [DataRow(false)]
    public void UnitTest(bool value)
    {
        var mockLogger = new Mock<ILogger<MyService>>();
        var mockConfiguration = new Mock<IConfiguration>();
        var mockFeatureManager = new Mock<IFeatureManager>();
        mockFeatureManager.Setup(x => x.IsEnabledAsync("MyFeature").Result).Returns(value);
        var myService = new MyService(mockLogger.Object, mockConfiguration.Object, mockFeatureManager.Object);

        myService.MyMethod(value).Should().Be(value);
        mockLogger.VerifyLogMessage($"Entering {nameof(MyService)}", LogLevel.Debug);
        mockLogger.VerifyLogMessage($"input = {value}", LogLevel.Trace);
        mockLogger.VerifyLogMessage($"Returning {value}", LogLevel.Information);
        mockLogger.VerifyLogMessage($"Exiting {nameof(MyService)}", LogLevel.Debug);
    }

    [TestCleanup]
    public void TestCleanup()
    {
        Debug.WriteLine("Exiting Test");
        Debug.WriteLine(new string('*', 80));
    }

    [TestInitialize]
    public void TestInitialize()
    {
        Debug.WriteLine(new string('*', 80));
        Debug.WriteLine("Entering Test");
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
