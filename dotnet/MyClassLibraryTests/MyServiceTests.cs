/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using FluentAssertions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Console;
using Moq;
using MyClassLibrary;
using System.Diagnostics;

namespace MyClassLibraryTests;

[TestClass]
public sealed class MyServiceTests
{
    [TestInitialize]
    public void TestInitialize()
    {
        Debug.WriteLine("Entering Test");
    }

    [TestCleanup]
    public void TestCleanup()
    {
        Debug.WriteLine("Exiting Test");
    }

    [TestMethod]
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
            { "MyCommand", "INSERT [dbo].[MyTable] ([Value]) VALUES (@Value);" }
        };
        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(configurationSettings)
            .Build();
        serviceCollection.AddSingleton<IConfiguration>(configuration);

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
    public void MyMethodLogsEntry()
    {
        var mockLogger = new Mock<ILogger<MyService>>();
        var mockConfiguration = MockHelpers.CreateMockConfiguration();
        var myService = new MyService(mockLogger.Object, mockConfiguration);

        myService.MyMethod(false);

        mockLogger.VerifyLogDebug($"Entering {nameof(MyService)}");
    }

    [TestMethod]
    public void MyMethodLogsExit()
    {
        var mockLogger = new Mock<ILogger<MyService>>();
        var mockConfiguration = MockHelpers.CreateMockConfiguration();
        var myService = new MyService(mockLogger.Object, mockConfiguration);

        myService.MyMethod(false);

        mockLogger.VerifyLogDebug($"Exiting {nameof(MyService)}");
    }

    [TestMethod]
    public void MyMethodLogsInput()
    {
        var mockLogger = new Mock<ILogger<MyService>>();
        var mockConfiguration = MockHelpers.CreateMockConfiguration();
        var myService = new MyService(mockLogger.Object, mockConfiguration);

        myService.MyMethod(false);

        mockLogger.VerifyLogTrace($"input = {Boolean.FalseString}");
    }

    [TestMethod]
    public void MyMethodLogsResult()
    {
        var mockLogger = new Mock<ILogger<MyService>>();
        var mockConfiguration = MockHelpers.CreateMockConfiguration();
        var myService = new MyService(mockLogger.Object, mockConfiguration);

        myService.MyMethod(false);

        mockLogger.VerifyLogInformation($"Returning {false}");
    }

    [TestMethod]
    public void MyMethodReturnsFalse()
    {
        var myService = MockHelpers.CreateMyServiceWithMockDependencies();

        myService.MyMethod(false).Should().BeFalse();
    }

    [TestMethod]
    public void MyMethodReturnsTrue()
    {
        var myService = MockHelpers.CreateMyServiceWithMockDependencies();

        myService.MyMethod(true).Should().BeTrue();
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

    internal static ILogger<MyService> CreateMockLogger()
    {
        var mockLogger = new Mock<ILogger<MyService>>();

        return mockLogger.Object;
    }

    internal static MyService CreateMyServiceWithMockDependencies()
    {
        var service = new MyService(
            CreateMockLogger(),
            CreateMockConfiguration()
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
