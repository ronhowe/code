/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using FluentAssertions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.FeatureManagement;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using MyClassLibrary;
using System.Diagnostics;

namespace MyTestProject;

[TestClass]
public sealed class MyUnitTests : TestBase
{
    [TestMethod]
    [TestCategory("UnitTest")]
    [DataTestMethod]
    [DataRow(false)]
    [DataRow(true)]
    public void MyServiceTests(bool value)
    {
        Debug.WriteLine($"Mocking {nameof(ILogger<MyService>)}");
        var mockLogger = new Mock<ILogger<MyService>>();

        Debug.WriteLine($"Mocking {nameof(IConfiguration)}");
        var mockConfiguration = new Mock<IConfiguration>();
        mockConfiguration.Setup(x => x["ConnectionStrings.MyDatabase"]).Returns("MYMOCKDATABASECONNECTIONSTRING");
        mockConfiguration.Setup(x => x["ConnectionStrings.MyAzureStorage"]).Returns("MYMOCKAZURESTORAGECONNECTIONSTRING;");
        mockConfiguration.Setup(x => x["MySecret"]).Returns("MYMOCKSECRET");

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

        Debug.WriteLine($"Calling {nameof(MyService)} With {value}");
        bool result = myService.MyMethod(value);

        Debug.WriteLine($"Asserting Result Is {value}");
        result.Should().Be(value);

        Debug.WriteLine($"Asserting Log Message Exists For Enter");
        mockLogger.VerifyLogMessage($"Entering {nameof(MyService)}", LogLevel.Debug);

        Debug.WriteLine($"Asserting Log Message Exists For Input");
        mockLogger.VerifyLogMessage($"input = {value}", LogLevel.Trace);

        Debug.WriteLine($"Asserting Log Message Exists For Returning");
        mockLogger.VerifyLogMessage($"Returning {value}", LogLevel.Information);

        Debug.WriteLine($"Asserting Log Message Exists For Exiting");
        mockLogger.VerifyLogMessage($"Exiting {nameof(MyService)}", LogLevel.Debug);
    }
}
