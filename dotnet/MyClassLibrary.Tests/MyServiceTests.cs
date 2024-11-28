/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using FluentAssertions;
using Microsoft.Extensions.Logging;
using Moq;
using Serilog;
using System.Diagnostics;

namespace MyClassLibrary.Tests;

[TestClass]
public sealed class MyServiceTests : TestBase
{
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
}
