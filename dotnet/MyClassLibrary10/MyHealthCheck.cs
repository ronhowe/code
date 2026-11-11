using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Logging;

namespace MyClassLibrary10;

public class MyHealthCheck(ILogger<MyService> logger, IMyService myService) : IHealthCheck
{
    public async Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = default)
    {
        if (logger.IsEnabled(LogLevel.Information))
        {
            logger.LogInformation("Entering {name}", nameof(MyHealthCheck));
        }

        HealthCheckResult _result;

        try
        {
            if (logger.IsEnabled(LogLevel.Information))
            {
                logger.LogInformation("Calling MyService.ProcessAsync");
            }

            await myService.ProcessAsync(SaveRequest.CreateDisabled(), cancellationToken);

            _result = HealthCheckResult.Healthy("HEALTHY");
        }
        catch (Exception ex)
        {
            if (logger.IsEnabled(LogLevel.Error))
            {
                logger.LogError(ex, "Error calling MyService.ProcessAsync");
            }

            _result = new HealthCheckResult(context.Registration.FailureStatus, "UNHEALTHY");
        }

        if (logger.IsEnabled(LogLevel.Information))
        {
            logger.LogInformation("Exiting {name}", nameof(MyHealthCheck));
        }

        return _result;
    }
}
