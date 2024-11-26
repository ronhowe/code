/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using FluentAssertions;
using Microsoft.Extensions.Logging;
using Moq;
using Serilog;

namespace MyClassLibrary.Tests;

[TestClass]
public sealed class MyClassTests : TestBase
{
    [TestMethod]
    public void POST()
    {
        Log.ForContext("SourceContext", _sourceContext).Debug("Power-On Self-Test");
    }

    [TestMethod]
    public void MyMethodLogsEntryMessage()
    {
        var mockLogger = new Mock<ILogger<MyClass>>();

        var myClass = new MyClass(
            mockLogger.Object
        );

        myClass.MyMethod(false);

        mockLogger.VerifyLogDebug($"Entering {nameof(MyClass)}");
    }

    [TestMethod]
    public void MyMethodLogsExitMessage()
    {
        var mockLogger = new Mock<ILogger<MyClass>>();

        var myClass = new MyClass(
            mockLogger.Object
        );

        myClass.MyMethod(false);

        mockLogger.VerifyLogDebug($"Exiting {nameof(MyClass)}");
    }

    [TestMethod]
    public void MyMethodLogsInputParameters()
    {
        var mockLogger = new Mock<ILogger<MyClass>>();

        var myClass = new MyClass(
            mockLogger.Object
        );

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
