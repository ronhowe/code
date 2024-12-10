/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Microsoft.AspNetCore.Mvc;
using Microsoft.FeatureManagement;
using MyClassLibrary;
using MyWebApplication;
using Serilog;
using Serilog.Events;

/*******************************************************************************
POST
*******************************************************************************/

const string _sourceContext = nameof(Program);
const string _outputTemplate = "[{Level:u3}] {Message}{NewLine}{Exception}";

Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Verbose()
    .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
    .Enrich.FromLogContext()
    .Enrich.WithMachineName()
    .WriteTo.Console(outputTemplate: _outputTemplate)
    .CreateLogger();

Log.ForContext("SourceContext", _sourceContext).Verbose($"POST (1 of 6) => Verbose Logging ON");
Log.ForContext("SourceContext", _sourceContext).Debug($"POST (2 of 6) => Debug Logging ON");
Log.ForContext("SourceContext", _sourceContext).Information($"POST (3 of 6) => Information Logging ON");
Log.ForContext("SourceContext", _sourceContext).Warning($"POST (4 of 6) => Warning Logging ON");
Log.ForContext("SourceContext", _sourceContext).Error($"POST (5 of 6) => Error Logging ON");
Log.ForContext("SourceContext", _sourceContext).Fatal($"POST (6 of 6) => Fatal Logging ON");

Log.ForContext("SourceContext", _sourceContext).Information($"{DateTime.UtcNow}");
Log.ForContext("SourceContext", _sourceContext).Information($"OK");

try
{
    Log.ForContext("SourceContext", _sourceContext).Information($"Creating Web Application Builder");
    var builder = WebApplication.CreateBuilder(args);

    /*******************************************************************************
    LOGGING
    *******************************************************************************/

    Log.ForContext("SourceContext", _sourceContext).Information($"Using Serilog");
    builder.Host.UseSerilog((hostContext, loggerConfiguration) =>
    {
        loggerConfiguration.ReadFrom.Configuration(hostContext.Configuration);
    });

    /*******************************************************************************
    CONFIGURATION
    *******************************************************************************/

    Log.ForContext("SourceContext", _sourceContext).Debug($"Getting Environment Name from Environment");
    var environmentName = builder.Environment.EnvironmentName;
    Log.ForContext("SourceContext", _sourceContext).Debug($"environmentName = {environmentName}");

    /*******************************************************************************
    FEATURE MANAGEMENT
    *******************************************************************************/

    Log.ForContext("SourceContext", _sourceContext).Information("Adding Feature Management");
    builder.Services.AddFeatureManagement();

    /*******************************************************************************
    REPOSITORY
    *******************************************************************************/

    Log.ForContext("SourceContext", _sourceContext).Information($"Adding {nameof(MyRepository)}");
    builder.Services.AddSingleton<IMyRepository, MyRepository>();

    /*******************************************************************************
    SERVICE
    *******************************************************************************/

    Log.ForContext("SourceContext", _sourceContext).Information($"Adding {nameof(MyService)}");
    builder.Services.AddSingleton<IMyService, MyService>();

    /*******************************************************************************
    APPLICATION
    *******************************************************************************/

    Log.ForContext("SourceContext", _sourceContext).Information($"Building Web Application");
    var app = builder.Build();

    app.Logger.LogTrace("POST (1 of 6) => Trace Logging ON");
    app.Logger.LogDebug("POST (2 of 6) => Debug Logging ON");
    app.Logger.LogInformation("POST (3 of 6) => Information Logging ON");
    app.Logger.LogWarning("POST (4 of 6) => Warning Logging ON");
    app.Logger.LogError("POST (5 of 6) => Error Logging ON");
    app.Logger.LogCritical("POST (6 of 6) => Critical Logging ON");

    app.Logger.LogInformation("{now}", DateTime.UtcNow);
    app.Logger.LogInformation("OK");

    app.Logger.LogInformation("Using Request Logging Middleware");
    app.UseMiddleware<RequestLoggingMiddleware>();

    app.Logger.LogInformation("Using HTTPS Redirection");
    app.UseHttpsRedirection();

    app.Logger.LogInformation("Using Serilog Request Logging");
    app.UseSerilogRequestLogging();

    app.Logger.LogInformation("Mapping Get Route to {name}", nameof(MyService));
    app.MapGet($"/api/{nameof(MyService)}", (bool input, [FromServices] IMyService myService) =>
    {
        app.Logger.LogInformation("Routing to {name}", nameof(MyService));
        return myService.MyMethod(input);
    });

    await app.RunAsync();
}
catch (Exception ex)
{
    Log.Fatal(ex, $"Program Failed =(");
}
finally
{
    Log.CloseAndFlush();
}
