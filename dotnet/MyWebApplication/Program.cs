
/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Microsoft.AspNetCore.Mvc;
using Microsoft.FeatureManagement;
using MyClassLibrary;
using MyWebApplication;
using Serilog;
using Serilog.Events;

const string _sourceContext = nameof(Program);
const string _outputTemplate = "[{Timestamp:yyyy-MM-dd @ HH:mm:ss.fff}] [{Level:u3}] [{SourceContext}] [{MachineName}] {Message}{NewLine}{Exception}";

Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Debug()
    .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
    .Enrich.FromLogContext()
    .Enrich.WithMachineName()
    .WriteTo.Console(outputTemplate: _outputTemplate)
    .CreateLogger();

#region post

/******************************************************************************

                    _
 _ __    ___   ___ | |_
| '_ \  / _ \ / __|| __|
| |_) || (_) |\__ \| |_
| .__/  \___/ |___/ \__|
|_|

******************************************************************************/

Log.ForContext("SourceContext", _sourceContext).Debug("Power-On Self-Test (1 of 5) => Debug Logging ON");
Log.ForContext("SourceContext", _sourceContext).Information("Power-On Self-Test (2 of 5) => Information Logging ON");
Log.ForContext("SourceContext", _sourceContext).Warning("Power-On Self-Test (3 of 5) => Warning Logging ON");
Log.ForContext("SourceContext", _sourceContext).Error("Power-On Self-Test (4 of 5) => Error Logging ON");
Log.ForContext("SourceContext", _sourceContext).Fatal("Power-On Self-Test (5 of 5) => Fatal Logging ON");

#endregion post

Log.ForContext("SourceContext", _sourceContext).Information("Program Running");

try
{
    Log.ForContext("SourceContext", _sourceContext).Information("Creating Web Application Builder");
    var builder = WebApplication.CreateBuilder(args);

    var environmentName = builder.Environment.EnvironmentName;
    Log.ForContext("SourceContext", _sourceContext).Debug("Logging Environment Name");
    Log.ForContext("SourceContext", _sourceContext).Debug("environmentName = {environmentName}", environmentName);

    /*******************************************************************************
    LOGGERS
    *******************************************************************************/

    Log.ForContext("SourceContext", _sourceContext).Information("Using Serilog");
    builder.Host.UseSerilog((hostContext, loggerConfiguration) =>
    {
        loggerConfiguration.ReadFrom.Configuration(hostContext.Configuration);
    });

    /*******************************************************************************
    FEATURES
    *******************************************************************************/

    Log.ForContext("SourceContext", _sourceContext).Information("Adding Feature Management");
    builder.Services.AddFeatureManagement();

    /*******************************************************************************
    SERVICES
    *******************************************************************************/

    Log.ForContext("SourceContext", _sourceContext).Information("Adding {0}", nameof(MyService));
    builder.Services.AddSingleton<IMyService, MyService>();

    //builder.Services.AddOpenApi();

    /*******************************************************************************
    BUILD
    *******************************************************************************/

    Log.ForContext("SourceContext", _sourceContext).Information("Building Web Application");
    var app = builder.Build();

    app.Logger.LogInformation("Using Request Logging Middleware");
    app.UseMiddleware<RequestLoggingMiddleware>();

    app.Logger.LogDebug("Power-On Self-Test (1 of 5) => Debug Logging ON");
    app.Logger.LogInformation("Power-On Self-Test (2 of 5) => Information Logging ON");
    app.Logger.LogWarning("Power-On Self-Test (3 of 5) => Warning Logging ON");
    app.Logger.LogError("Power-On Self-Test (4 of 5) => Error Logging ON");
    app.Logger.LogCritical("Power-On Self-Test (5 of 5) => Fatal Logging ON");

    app.Logger.LogInformation("Web Application Running");

    //if (app.Environment.IsDevelopment())
    //{
    //    app.MapOpenApi();
    //}

    app.UseHttpsRedirection();

    app.Logger.LogInformation("Using Serilog Request Logging");
    app.UseSerilogRequestLogging();

    /*******************************************************************************
    ROUTES
    *******************************************************************************/

    app.MapGet($"/api/{nameof(MyService)}", (/*[FromRoute]*/ bool input, [FromServices] IMyService myService) =>
    {
        app.Logger.LogInformation("Entering MyService");
        return myService.MyMethod(input);
    });

    await app.RunAsync();
}
catch (Exception ex)
{
    Log.Fatal(ex, "Program Exception");
}
finally
{
    Log.CloseAndFlush();
}
