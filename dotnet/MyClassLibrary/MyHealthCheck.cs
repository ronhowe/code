using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Logging;

namespace MyClassLibrary;

public class MyHealthCheck(ILogger<MyService> logger, IMyService myService) : IHealthCheck
{
    public Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = default)
    {
        logger.LogDebug("Entering {name}", nameof(MyHealthCheck));

        HealthCheckResult _result;

        try
        {
            logger.LogDebug("Calling MyService.MyMethod(false)");
            myService.MyMethod(false);
            _result = HealthCheckResult.Healthy("HEALTHY");
        }
        catch (Exception ex)
        {
            logger.LogError("Error Calling MyService.MyMethod(false) Because {message}", ex.Message);
            _result = new HealthCheckResult(context.Registration.FailureStatus, "UNHEALTHY");
        }

        logger.LogTrace("_result = {_result}", _result);

        logger.LogDebug("Exiting {name}", nameof(MyHealthCheck));

        return Task.FromResult(_result);
    }
}
