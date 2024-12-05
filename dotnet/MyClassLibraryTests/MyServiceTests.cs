/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using FluentAssertions;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Moq;
using MyClassLibrary;
using Serilog;
using Serilog.Events;
using System.Diagnostics;

namespace MyClassLibraryTests;

[TestClass]
public sealed class MyServiceTests
{
    internal readonly string _outputTemplate = "[{Timestamp:yyyy-MM-dd @ HH:mm:ss.fff}] [{Level:u3}] [{SourceContext}] [{MachineName}] {Message}{NewLine}{Exception}";
    internal readonly string _sourceContext = nameof(MyServiceTests);

    [TestInitialize]
    public void TestInitialize()
    {
        Debug.WriteLine("Power-On Self-Test");

        Debug.WriteLine("Configuring Logger");

        Log.Logger = new LoggerConfiguration()
            .MinimumLevel.Debug()
            .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
            .Enrich.FromLogContext()
            .Enrich.WithMachineName()
            .WriteTo.Console(outputTemplate: _outputTemplate)
            .CreateLogger();

        Log.ForContext("SourceContext", _sourceContext).Debug("Power-On Self-Test");
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
    public void MyMethodLogsInputParameters()
    {
        var mockLogger = new Mock<ILogger<MyService>>();
        var myService = new MyService(mockLogger.Object);

        myService.MyMethod(false);

        mockLogger.VerifyLogDebug($"$input = {Boolean.FalseString}");
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

    [TestMethod]
    public void MyMethodIntegrationTest()
    {
        var serviceCollection = new ServiceCollection();
        ConfigureServices(serviceCollection);

        var serviceProvider = serviceCollection.BuildServiceProvider();

        var myService = serviceProvider.GetService<MyService>();
        myService?.MyMethod(true).Should().BeTrue();
    }

    private static void ConfigureServices(IServiceCollection services)
    {
        services
            .AddLogging(configure =>
            {
                configure.AddSimpleConsole();
                configure.SetMinimumLevel(LogLevel.Debug);
            })
            .AddTransient<MyService>();
    }

    [TestMethod]
    public void PowerOnSelfTest()
    {
        //todo
    }
}
