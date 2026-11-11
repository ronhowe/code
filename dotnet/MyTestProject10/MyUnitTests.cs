using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.FeatureManagement;
using Moq;
using MyClassLibrary10;
using Shouldly;
using System.Diagnostics;

namespace MyTestProject10;

/// <summary>
/// Unit tests for MyService business logic with mocked dependencies.
/// </summary>
[TestClass]
public sealed class MyUnitTests : TestBase
{
    /// <summary>
    /// Tests MyService.ProcessAsync with various input values.
    /// </summary>
    /// <param name="value">The input value to process.</param>
    [TestMethod]
    [TestCategory("UnitTest")]
    [DataRow(false)]
    [DataRow(true)]
    public async Task MyServiceTests(bool value)
    {
        Mock<ILogger<MyService>> mockLogger = new();
        mockLogger.Setup(l => l.IsEnabled(It.IsAny<LogLevel>())).Returns(true);

        Mock<IConfiguration> mockConfiguration = new();
        mockConfiguration.Setup(x => x["ConnectionStrings.MyDatabase"]).Returns("MYMOCKDATABASECONNECTIONSTRING");
        mockConfiguration.Setup(x => x["ConnectionStrings.MyAzureStorage"]).Returns("MYMOCKAZURESTORAGECONNECTIONSTRING;");
        mockConfiguration.Setup(x => x["MySecret"]).Returns("MYMOCKSECRET");

        Mock<IFeatureManager> mockFeatureManager = new();
        mockFeatureManager.Setup(x => x.IsEnabledAsync(AppConstants.Features.MySaveFeature)).ReturnsAsync(value);

        Mock<IMyRepository> mockRepository = new();

        MyService myService = new(
            mockLogger.Object,
            mockConfiguration.Object,
            mockFeatureManager.Object,
            mockRepository.Object
        );

        bool result = await myService.ProcessAsync(SaveRequest.Create(value));

        result.ShouldBe(value);
        mockLogger.VerifyLogMessage($"Entering {nameof(MyService)}", LogLevel.Information);
        mockLogger.VerifyLogMessage($"Exiting {nameof(MyService)}", LogLevel.Information);
    }
}
