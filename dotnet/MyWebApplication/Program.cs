using Asp.Versioning;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Mvc;
using Microsoft.FeatureManagement;
using Microsoft.IdentityModel.Tokens;
using MyClassLibrary;
using MyWebApplication;
using Serilog;
using Serilog.Events;
using System.Text;

// TODO: Update for production release.
// const string _outputTemplate = "[{Timestamp:yyyy-MM-dd @ HH:mm:ss.fff}] [{Level:u3}] [{MachineName}] [{SourceContext}] {Message}{NewLine}{Exception}";
const string _outputTemplate = "[{Level:u3}] [{MachineName}] [{SourceContext}] {Message}{NewLine}{Exception}";
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

    Log.ForContext("SourceContext", _sourceContext).Information("Adding API Versioning");
    builder.Services.AddApiVersioning(options =>
    {
        // TODO: Learn how these work with v{version:apiVersion} in the MapGet calls.
        //options.DefaultApiVersion = new ApiVersion(1);
        //options.AssumeDefaultVersionWhenUnspecified = true;
        options.ApiVersionReader = new UrlSegmentApiVersionReader();
    });

    Log.ForContext("SourceContext", _sourceContext).Information("Adding {name}", nameof(MyRepository));
    // TODO: Learn the difference between AddSingleton and AddTransient.
    builder.Services.AddSingleton<IMyRepository, MyRepository>();

    Log.ForContext("SourceContext", _sourceContext).Information("Adding {name}", nameof(MyService));
    // TODO: Learn the difference between AddSingleton and AddTransient.
    builder.Services.AddSingleton<IMyService, MyService>();

    Log.ForContext("SourceContext", _sourceContext).Information("Adding Authentication");
    builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
        .AddJwtBearer(options =>
        {
            var _key = $"/{new string('*', 512)}";
            options.TokenValidationParameters = new TokenValidationParameters
            {
                ValidateIssuer = true,
                ValidateAudience = true,
                ValidateLifetime = true,
                ValidateIssuerSigningKey = true,
                ValidIssuer = "yourIssuer",
                ValidAudience = "yourAudience",
                IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_key))
            };
        });

    Log.ForContext("SourceContext", _sourceContext).Information("Adding Authorization");
    builder.Services.AddAuthorization();

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

    app.Logger.LogInformation("Using Custom Header");
    app.Use(async (context, next) =>
    {
        AddCustomHeader(context, app);
        await next();
    });

    app.Logger.LogInformation("Using Authentication Middleware");
    app.UseAuthentication();

    app.Use(async (context, next) =>
    {
        var claims = context.User.Claims.Select(c => new { c.Type, c.Value }).ToList();
        app.Logger.LogDebug("User Claims: {@Claims}", claims);
        await next.Invoke();
    });

    app.Logger.LogInformation("Using Authorization Middleware");
    app.UseAuthorization();

    var versionSet = app.NewApiVersionSet()
        .HasApiVersion(new ApiVersion(1))
        .HasApiVersion(new ApiVersion(2))
        .ReportApiVersions()
        .Build();

    // TODO: Use better {tokens} for better queryability.  e.g. {serviceName} instead of {name}.

    const int _v1 = 1;
    app.Logger.LogInformation("Mapping Version {version} GET Requests To {name}", _v1, nameof(MyService));
    app.MapGet($"/v{{version:apiVersion}}/{{nameof(MyService)}}", (bool input, [FromServices] IMyService myService, HttpContext context) =>
    {
        var apiVersion = context.GetRequestedApiVersion();
        app.Logger.LogInformation("Calling Version {apiVersion} Of {name} With {input}", apiVersion, nameof(MyService), input);
        return myService.MyMethod(input);
    })
        .WithApiVersionSet(versionSet)
        .MapToApiVersion(_v1);

    const int _v2 = 2;
    app.Logger.LogInformation("Mapping Version {version} GET Requests To {name}", _v2, nameof(MyService));
    app.MapGet($"/v{{version:apiVersion}}/{{nameof(MyService)}}", (bool input, [FromServices] IMyService myService, HttpContext context) =>
    {
        var apiVersion = context.GetRequestedApiVersion();

        app.Logger.LogInformation("Calling Version {apiVersion} Of {name} With {input}", apiVersion, nameof(MyService), input);
        return myService.MyMethod(input);
    })
        .WithApiVersionSet(versionSet)
        .MapToApiVersion(_v2)
        .RequireAuthorization();

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

static void AddCustomHeader(HttpContext context, WebApplication app)
{
    app.Logger.LogDebug("Adding Custom Header");

    const string headerKey = "CustomHeader";
    var headerValue = "MyCustomHeader";// app.Configuration.GetSection(headerKey).Value;

    app.Logger.LogDebug("Logging Custom Header");
    app.Logger.LogTrace("$headerKey = {headerKey} ; $headerValue = {headerValue}", headerKey, headerValue);

    context.Response.Headers.Append(headerKey, headerValue);
}
