/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using FluentAssertions;
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
        Debug.WriteLine("Initializing Test");
    }

    [TestMethod]
    public void IntegrationTest()
    {
        Debug.WriteLine($"Creating Service Collection");
        var serviceCollection = new ServiceCollection();

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
                options.UseUtcTimestamp = true;
                options.TimestampFormat = "yyyy-MM-dd HH:mm:ss ";
            });

            var logLevel = LogLevel.Trace;
            Debug.WriteLine($"Setting Minimum Log Level = {logLevel}");
            configure.SetMinimumLevel(logLevel);

        })
        .AddTransient<MyService>();

        Debug.WriteLine("Building Service Provider");
        var serviceProvider = serviceCollection.BuildServiceProvider();

        Debug.WriteLine("Getting MyService");
        var myService = serviceProvider.GetService<MyService>();

        Debug.WriteLine($"Calling MyService");
        myService?.MyMethod(true).Should().BeTrue();
    }

    [TestMethod]
    public void MyMethodLogsEntryMessage()
    {
        var mockLogger = new Mock<ILogger<MyService>>();
        var myService = new MyService(mockLogger.Object);

        myService.MyMethod(false);

        mockLogger.VerifyLogDebug($"Entering {nameof(MyService)}");
    }

    [TestMethod]
    public void MyMethodLogsExitMessage()
    {
        var mockLogger = new Mock<ILogger<MyService>>();
        var myService = new MyService(mockLogger.Object);

        myService.MyMethod(false);

        mockLogger.VerifyLogDebug($"Exiting {nameof(MyService)}");
    }

    [TestMethod]
    public void MyMethodLogsInputMessage()
    {
        var mockLogger = new Mock<ILogger<MyService>>();
        var myService = new MyService(mockLogger.Object);

        myService.MyMethod(false);

        mockLogger.VerifyLogTrace($"input = {Boolean.FalseString}");
    }

    [TestMethod]
    public void MyMethodLogsOKMessage()
    {
        var mockLogger = new Mock<ILogger<MyService>>();
        var myService = new MyService(mockLogger.Object);

        myService.MyMethod(false);

        mockLogger.VerifyLogInformation($"OK");
    }

    [TestMethod]
    public void MyMethodReturnsFalseFromFalseInput()
    {
        var myService = TestHelper.CreateMyServiceWithMockDependencies();

        myService.MyMethod(false).Should().BeFalse();
    }

    [TestMethod]
    public void MyMethodReturnsTrueFromTrueInput()
    {
        var myService = TestHelper.CreateMyServiceWithMockDependencies();

        myService.MyMethod(true).Should().BeTrue();
    }
}
