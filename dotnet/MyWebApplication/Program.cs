
/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using Microsoft.AspNetCore.Mvc;
using Microsoft.FeatureManagement;
using MyClassLibrary;
using MyWebApplication;
using Serilog;
using Serilog.Events;

#region post

/*******************************************************************************
POST
*******************************************************************************/

const string _sourceContext = nameof(Program);
const string _outputTemplate = "{Message}{NewLine}{Exception}";
//const string _outputTemplate = "[{Timestamp:yyyy-MM-dd @ HH:mm:ss.fff}] [{Level:u3}] [{SourceContext}] [{MachineName}]\n     {Message}{NewLine}{Exception}";

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

    app.Logger.LogDebug("POST (1 of 5) => Debug Logging ON");
    app.Logger.LogInformation("POST (2 of 5) => Information Logging ON");
    app.Logger.LogWarning("POST (3 of 5) => Warning Logging ON");
    app.Logger.LogError("POST (4 of 5) => Error Logging ON");
    app.Logger.LogCritical("POST (5 of 5) => Fatal Logging ON");

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
