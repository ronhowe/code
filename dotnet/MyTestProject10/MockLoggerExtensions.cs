using Microsoft.Extensions.Logging;
using Moq;

namespace MyTestProject10;

/// <summary>
/// Extension methods for verifying log messages in mock loggers.
/// </summary>
internal static class MockLoggerExtensions
{
    /// <summary>
    /// Verifies that a log message with the specified level was written.
    /// </summary>
    /// <typeparam name="T">The logger type.</typeparam>
    /// <param name="logger">The mock logger.</param>
    /// <param name="expectedMessage">The expected log message text.</param>
    /// <param name="expectedLogLevel">The expected log level.</param>
    /// <returns>The mock logger for chaining.</returns>
    internal static Mock<ILogger<T>> VerifyLogMessage<T>(this Mock<ILogger<T>> logger, string expectedMessage, LogLevel expectedLogLevel)
    {
        ArgumentNullException.ThrowIfNull(expectedMessage);

        Func<object?, Type, bool> state = (v, t) => v?.ToString()?.CompareTo(expectedMessage) == 0;

#pragma warning disable CA1873 // Avoid potentially expensive logging
        logger.Verify(
            x => x.Log(
                It.Is<LogLevel>(l => l == expectedLogLevel),
                It.IsAny<EventId>(),
                It.Is<It.IsAnyType>((v, t) => state(v, t)),
                It.IsAny<Exception>(),
                It.Is<Func<It.IsAnyType, Exception?, string>>((v, t) => true)));
#pragma warning restore CA1873 // Avoid potentially expensive logging

        return logger;
    }
}
