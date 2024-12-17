/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Microsoft.AspNetCore.Mvc;
using Microsoft.FeatureManagement;
using MyClassLibrary;
using MyWebApplication;
using Serilog;
using Serilog.Events;

const string _outputTemplate = "[{Timestamp:yyyy-MM-dd @ HH:mm:ss.fff}] [{Level:u3}] [{MachineName}] [{SourceContext}] {Message}{NewLine}{Exception}";
const string _sourceContext = nameof(Program);

Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Verbose()
    .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
    .Enrich.FromLogContext()
    .Enrich.WithMachineName()
    .WriteTo.Console(outputTemplate: _outputTemplate)
    .CreateLogger();

Log.ForContext("SourceContext", _sourceContext).Verbose("POST (1 of 6) => Verbose Logging ON");
Log.ForContext("SourceContext", _sourceContext).Debug("POST (2 of 6) => Debug Logging ON");
Log.ForContext("SourceContext", _sourceContext).Information("POST (3 of 6) => Information Logging ON");
Log.ForContext("SourceContext", _sourceContext).Warning("POST (4 of 6) => Warning Logging ON");
Log.ForContext("SourceContext", _sourceContext).Error("POST (5 of 6) => Error Logging ON");
Log.ForContext("SourceContext", _sourceContext).Fatal("POST (6 of 6) => Fatal Logging ON");
Log.ForContext("SourceContext", _sourceContext).Information("{now} (LOCAL)", DateTime.Now);
Log.ForContext("SourceContext", _sourceContext).Information("{utcNow} (UTC)", DateTime.UtcNow);

try
{
    Log.ForContext("SourceContext", _sourceContext).Information("Creating Web Application Builder");
    var builder = WebApplication.CreateBuilder(args);

    Log.ForContext("SourceContext", _sourceContext).Information("Using Serilog");
    builder.Host.UseSerilog((hostContext, loggerConfiguration) =>
    {
        loggerConfiguration.ReadFrom.Configuration(hostContext.Configuration);
    });

    Log.ForContext("SourceContext", _sourceContext).Debug("Getting Environment Name From Environment");
    var environmentName = builder.Environment.EnvironmentName;
    Log.ForContext("SourceContext", _sourceContext).Debug("environmentName = {environmentName}", environmentName);

    Log.ForContext("SourceContext", _sourceContext).Information("Adding Feature Management");
    builder.Services.AddFeatureManagement();

    Log.ForContext("SourceContext", _sourceContext).Information("Adding {name}", nameof(MyRepository));
    // TODO: Learn the difference between AddSingleton and AddTransient.
    builder.Services.AddSingleton<IMyRepository, MyRepository>();

    Log.ForContext("SourceContext", _sourceContext).Information("Adding {name}", nameof(MyService));
    // TODO: Learn the difference between AddSingleton and AddTransient.
    builder.Services.AddSingleton<IMyService, MyService>();

    Log.ForContext("SourceContext", _sourceContext).Information("Building Web Application");
    var app = builder.Build();

    app.Logger.LogTrace("POST (1 of 6) => Trace Logging ON");
    app.Logger.LogDebug("POST (2 of 6) => Debug Logging ON");
    app.Logger.LogInformation("POST (3 of 6) => Information Logging ON");
    app.Logger.LogWarning("POST (4 of 6) => Warning Logging ON");
    app.Logger.LogError("POST (5 of 6) => Error Logging ON");
    app.Logger.LogCritical("POST (6 of 6) => Critical Logging ON");
    app.Logger.LogInformation("{now} (LOCAL)", DateTime.Now);
    app.Logger.LogInformation("{utcNow} (UTC)", DateTime.UtcNow);

    app.Logger.LogInformation("Using Request Logging Middleware");
    app.UseMiddleware<RequestLoggingMiddleware>();

    app.Logger.LogInformation("Using HTTPS Redirection");
    app.UseHttpsRedirection();

    app.Logger.LogInformation("Using Serilog Request Logging");
    app.UseSerilogRequestLogging();

    app.Logger.LogInformation("Mapping GET Requests To {name}", nameof(MyService));
    app.MapGet($"/api/{nameof(MyService)}", (bool input, [FromServices] IMyService myService) =>
    {
        app.Logger.LogInformation("Calling {name} With {input}", nameof(MyService), input);
        return myService.MyMethod(input);
    });

    await app.RunAsync();
}
catch (Exception ex)
{
    Log.Error("Program Failed Because {message}", ex.Message);
    Log.Fatal(ex, "FATAL ERROR");
}
finally
{
    Log.CloseAndFlush();
}
