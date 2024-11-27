/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using FluentAssertions;
using Microsoft.Extensions.Logging;
using Moq;
using Serilog;

namespace MyClassLibrary.Tests;

[TestClass]
public sealed class MyServiceTests : TestBase
{
    [TestMethod]
    public void POST()
    {
        Log.ForContext("SourceContext", _sourceContext).Debug("Power-On Self-Test");
    }

    [TestMethod]
    public void MyMethodLogsEntryMessage()
    {
        var mockLogger = new Mock<ILogger<MyService>>();
        var myClass = new MyService(mockLogger.Object);

        myClass.MyMethod(false);

        mockLogger.VerifyLogDebug($"Entering {nameof(MyService)}");
    }

    [TestMethod]
    public void MyMethodLogsExitMessage()
    {
        var mockLogger = new Mock<ILogger<MyService>>();
        var myClass = new MyService(mockLogger.Object);

        myClass.MyMethod(false);

        mockLogger.VerifyLogDebug($"Exiting {nameof(MyService)}");
    }

    [TestMethod]
    public void MyMethodLogsInputParameters()
    {
        var mockLogger = new Mock<ILogger<MyService>>();
        var myClass = new MyService(mockLogger.Object);

        myClass.MyMethod(false);

        mockLogger.VerifyLogDebug($"$input = {Boolean.FalseString}");
    }

    [TestMethod]
    public void MyMethodReturnsFalseFromFalseInput()
    {
        var myClass = TestHelper.CreateMyClassWithMockDependencies();

        myClass.MyMethod(false).Should().BeFalse();
    }

    [TestMethod]
    public void MyMethodReturnsTrueFromTrueInput()
    {
        var myClass = TestHelper.CreateMyClassWithMockDependencies();

        myClass.MyMethod(true).Should().BeTrue();
    }
}
