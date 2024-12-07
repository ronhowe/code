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

namespace MyClassLibraryTests;

[TestClass]
public sealed class MyServiceTests
{
    [TestMethod]
    [TestCategory("IntegrationTest")]
    public void MyServiceTest()
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
    public void MyMethodTest(bool value)
    {
        var mockLogger = new Mock<ILogger<MyService>>();
        var mockConfiguration = MockHelpers.CreateMockConfiguration();
        var mockFeatureManager = MockHelpers.CreateMockFeatureManager("MyFeature", false);
        var myService = new MyService(mockLogger.Object, mockConfiguration, mockFeatureManager);

        myService.MyMethod(value).Should().Be(value);
        mockLogger.VerifyLogDebug($"Entering {nameof(MyService)}");
        mockLogger.VerifyLogTrace($"input = {value}");
        mockLogger.VerifyLogInformation($"Returning {value}");
        mockLogger.VerifyLogDebug($"Exiting {nameof(MyService)}");
    }

    [TestCleanup]
    public void TestCleanup()
    {
        Debug.WriteLine("Exiting Test");
    }

    [TestInitialize]
    public void TestInitialize()
    {
        Debug.WriteLine("Entering Test");
    }
}

internal static class MockHelpers
{
    internal static IConfiguration CreateMockConfiguration()
    {
        var mockConfiguration = new Mock<IConfiguration>();

        mockConfiguration.Setup(x => x["MyCommand"]).Returns("INSERT [dbo].[MyTable] ([Value]) VALUES (@Value);");
        mockConfiguration.Setup(x => x["ConnectionStrings:MyDatabase"]).Returns("Application Name=MyClassLibraryTests;Server=localhost;Database=MyDatabase;Connect Timeout=1;Trusted_Connection=True;Encrypt=Optional;");
        return mockConfiguration.Object;
    }

    internal static IFeatureManager CreateMockFeatureManager(string name, bool value)
    {
        var mockFeatureManager = new Mock<IFeatureManager>();
        mockFeatureManager.Setup(x => x.IsEnabledAsync(name).Result).Returns(value);

        return mockFeatureManager.Object;
    }

    internal static ILogger<MyService> CreateMockLogger()
    {
        var mockLogger = new Mock<ILogger<MyService>>();

        return mockLogger.Object;
    }

    internal static MyService CreateMyServiceWithMockDependencies()
    {
        var service = new MyService(
            CreateMockLogger(),
            CreateMockConfiguration(),
            CreateMockFeatureManager("MyFeature", false)
        );

        return service;
    }

    internal static Mock<ILogger<T>> VerifyLogDebug<T>(this Mock<ILogger<T>> logger, string expectedMessage)
    {
        ArgumentNullException.ThrowIfNull(expectedMessage);

        Func<object, Type, bool> state = (v, t) => v?.ToString()?.CompareTo(expectedMessage) == 0;

        logger.Verify(
            x => x.Log(
                It.Is<LogLevel>(l => l == LogLevel.Debug),
                It.IsAny<EventId>(),
                It.Is<It.IsAnyType>((v, t) => state(v, t)),
                It.IsAny<Exception>(),
                It.Is<Func<It.IsAnyType, Exception?, string>>((v, t) => true)));

        return logger;
    }

    internal static Mock<ILogger<T>> VerifyLogInformation<T>(this Mock<ILogger<T>> logger, string expectedMessage)
    {
        ArgumentNullException.ThrowIfNull(expectedMessage);

        Func<object, Type, bool> state = (v, t) => v?.ToString()?.CompareTo(expectedMessage) == 0;

        logger.Verify(
            x => x.Log(
                It.Is<LogLevel>(l => l == LogLevel.Information),
                It.IsAny<EventId>(),
                It.Is<It.IsAnyType>((v, t) => state(v, t)),
                It.IsAny<Exception>(),
                It.Is<Func<It.IsAnyType, Exception?, string>>((v, t) => true)));

        return logger;
    }

    internal static Mock<ILogger<T>> VerifyLogTrace<T>(this Mock<ILogger<T>> logger, string expectedMessage)
    {
        ArgumentNullException.ThrowIfNull(expectedMessage);

        Func<object, Type, bool> state = (v, t) => v?.ToString()?.CompareTo(expectedMessage) == 0;

        logger.Verify(
            x => x.Log(
                It.Is<LogLevel>(l => l == LogLevel.Trace),
                It.IsAny<EventId>(),
                It.Is<It.IsAnyType>((v, t) => state(v, t)),
                It.IsAny<Exception>(),
                It.Is<Func<It.IsAnyType, Exception?, string>>((v, t) => true)));

        return logger;
    }
}
