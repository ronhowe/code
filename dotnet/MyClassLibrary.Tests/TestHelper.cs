/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Microsoft.Extensions.Logging;
using Moq;

namespace MyClassLibrary.Tests;

internal static class TestHelper
{
    //internal static IConfiguration CreateMockConfiguration(bool value)
    //{
    //    //link - https://adamstorr.azurewebsites.net/blog/mocking-ilogger-with-moq
    //    var mockConfigurationSection = new Mock<IConfigurationSection>();
    //    mockConfigurationSection.Setup(x => x.Value).Returns(value.ToString());

    //    var mockConfiguration = new Mock<IConfiguration>();
    //    mockConfiguration.Setup(x => x.GetSection(nameof(Service1Feature.MockService1PermanentExceptionToggle))).Returns(mockConfigurationSection.Object);
    //    mockConfiguration.Setup(x => x.GetSection(nameof(Service1Feature.MockService1TransientExceptionToggle))).Returns(mockConfigurationSection.Object);

    //    return mockConfiguration.Object;
    //}

    //internal static IDateTimeService CreateMockDateTimeService(bool even)
    //{
    //    long ticks = even ? (DateTime.UtcNow.Ticks / 2) * 2 : ((DateTime.UtcNow.Ticks / 2) * 2) + 1;
    //    DateTime dateTime = new(ticks);

    //    var mockDateTimeService = new Mock<IDateTimeService>();
    //    mockDateTimeService.Setup(x => x.UtcNow).Returns(dateTime);

    //    return mockDateTimeService.Object;
    //}

    //internal static IFeatureManager CreateMockFeatureManager(string name, bool value)
    //{
    //    var mockFeatureManager = new Mock<IFeatureManager>();
    //    mockFeatureManager.Setup(x => x.IsEnabledAsync(name).Result).Returns(value);

    //    return mockFeatureManager.Object;
    //}

    //internal static IHealthCheck CreateMockHealthCheck()
    //{
    //    var mockHealthCheck = new Mock<IHealthCheck>();

    //    return mockHealthCheck.Object;
    //}

    internal static ILogger<MyService> CreateMockLogger()
    {
        var mockLogger = new Mock<ILogger<MyService>>();

        return mockLogger.Object;
    }

    public static Mock<ILogger<T>> VerifyLogDebug<T>(this Mock<ILogger<T>> logger, string expectedMessage)
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

    public static Mock<ILogger<T>> VerifyLogInformation<T>(this Mock<ILogger<T>> logger, string expectedMessage)
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

    internal static MyService CreateMyClassWithMockDependencies()
    {
        var service = new MyService(
            CreateMockLogger()
        );

        return service;
    }
}
