using Asp.Versioning;
using Microsoft.ApplicationInsights.AspNetCore.Extensions;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Mvc;
using Microsoft.FeatureManagement;
using Microsoft.IdentityModel.Tokens;
using MyClassLibrary;
using MyWebApplication;
using Serilog;
using Serilog.Events;
using System.Text;

const string _outputTemplate = "[{Timestamp:yyyy-MM-dd HH:mm:ss.fff}] [{Level:u3}] [{MachineName}] [{SourceContext}] {Message}{NewLine}{Exception}";
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
    var _builder = WebApplication.CreateBuilder(args);

    Log.ForContext("SourceContext", _sourceContext).Information("Getting Environment Name From Environment");
    var _environmentName = _builder.Environment.EnvironmentName;
    Log.ForContext("SourceContext", _sourceContext).Debug("environmentName = {environmentName}", _environmentName);

    Log.ForContext("SourceContext", _sourceContext).Information("Using Serilog");
    _builder.Host.UseSerilog((hostContext, loggerConfiguration) =>
    {
        loggerConfiguration.ReadFrom.Configuration(hostContext.Configuration);
    });

    Log.ForContext("SourceContext", _sourceContext).Information("Getting Application Insights Connection String");
    var _aiConnectionString = _builder.Configuration["ConnectionStrings:ApplicationInsights"];
#if DEBUG
    Log.ForContext("SourceContext", _sourceContext).Debug("_aiConnectionString = {_aiConnectionString}", _aiConnectionString);
#endif

    Log.ForContext("SourceContext", _sourceContext).Information("Adding Application Insights Telemetry");
    _builder.Services.AddApplicationInsightsTelemetry(new ApplicationInsightsServiceOptions
    {
        ConnectionString = _aiConnectionString
    });

    Log.ForContext("SourceContext", _sourceContext).Information("Adding Feature Management Services");
    _builder.Services.AddFeatureManagement();

    Log.ForContext("SourceContext", _sourceContext).Information("Adding Health Check Services");
    _builder.Services.AddHealthChecks().AddCheck<MyHealthCheck>("MyHealthCheck");

    Log.ForContext("SourceContext", _sourceContext).Information("Adding API Versioning Services");
    _builder.Services.AddApiVersioning(options =>
    {
        // TODO: Assert versionless route works.
        options.DefaultApiVersion = new ApiVersion(1);
        options.AssumeDefaultVersionWhenUnspecified = true;
        options.ApiVersionReader = new UrlSegmentApiVersionReader();
    });

    _builder.Services.AddOpenApi();

    Log.ForContext("SourceContext", _sourceContext).Information("Adding {name} Services", nameof(MyRepository));
    // TODO: Learn the difference between AddSingleton and AddTransient.
    _builder.Services.AddSingleton<IMyRepository, MyRepository>();

    Log.ForContext("SourceContext", _sourceContext).Information("Adding {name} Services", nameof(MyService));
    _builder.Services.AddSingleton<IMyService, MyService>();

    Log.ForContext("SourceContext", _sourceContext).Information("Adding Authentication Services");
    _builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
        .AddJwtBearer(options =>
        {
            var _key = $"/{new string('*', 4096 / 8)}";
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

    Log.ForContext("SourceContext", _sourceContext).Information("Adding Authorization Services");
    _builder.Services.AddAuthorizationBuilder()
        .AddPolicy("MyClaimPolicy", policy =>
            policy.RequireClaim("MyClaimType", "MyClaimValue"));

    Log.ForContext("SourceContext", _sourceContext).Information("Building Web Application");
    var app = _builder.Build();

    app.Logger.LogTrace("POST (1 of 6) => Trace Logging ON");
    app.Logger.LogDebug("POST (2 of 6) => Debug Logging ON");
    app.Logger.LogInformation("POST (3 of 6) => Information Logging ON");
    app.Logger.LogWarning("POST (4 of 6) => Warning Logging ON");
    app.Logger.LogError("POST (5 of 6) => Error Logging ON");
    app.Logger.LogCritical("POST (6 of 6) => Critical Logging ON");
    app.Logger.LogInformation("{now} (LOCAL)", DateTime.Now);
    app.Logger.LogInformation("{utcNow} (UTC)", DateTime.UtcNow);

    // NOTE: Order matters. (e.g. Swagger before Authentication)

    app.Logger.LogInformation("Using Request Logging Middleware");
    app.UseMiddleware<RequestLoggingMiddleware>();

    if (!app.Environment.IsDevelopment())
    {
        app.Logger.LogInformation("Using Exception Handling Middleware");
        app.UseExceptionHandler("/error");
    }

    app.Logger.LogInformation("Mapping Open API");
    app.MapOpenApi();

    app.Logger.LogInformation("Using HTTPS Redirection Middleware");
    app.UseHttpsRedirection();

    app.Logger.LogInformation("Using Serilog Request Logging Middleware");
    app.UseSerilogRequestLogging();

    app.Logger.LogInformation("Using Header Middleware");
    app.Use(async (context, next) =>
    {
        const string _myHeader = "MyHeader";

        app.Logger.LogInformation("Getting Header From Configuration.");
        var myHeader = app.Configuration.GetSection(_myHeader).Value;
        app.Logger.LogDebug("myHeader = {myHeader}", myHeader);

        app.Logger.LogInformation("Appending Header");
        context.Response.Headers.Append(_myHeader, myHeader);

        await next();
    });

    app.Logger.LogInformation("Using HealthCheck");
    app.UseHealthChecks("/healthcheck");

    app.Logger.LogInformation("Using Authentication Middleware");
    app.UseAuthentication();

    app.Logger.LogInformation("Using Claims Logger Middleware");
    app.Use(async (context, next) =>
    {
        app.Logger.LogInformation("Selecting Claims From Context");
        var claims = context.User.Claims.Select(c => new { c.Type, c.Value }).ToList();
        app.Logger.LogDebug("claims = {@claims}", claims);

        await next.Invoke();
    });

    app.Logger.LogInformation("Using Authorization Middleware");
    app.UseAuthorization();

    var versionSet = app.NewApiVersionSet()
        .HasApiVersion(new ApiVersion(1))
        .HasApiVersion(new ApiVersion(2))
        .ReportApiVersions()
        .Build();

    // TODO: Use better {tokens} for better discoverability.

    const int _v1 = 1;
    app.Logger.LogInformation("Mapping Version {version} GET Requests To {name}", _v1, nameof(MyService));
    app.MapGet($"/v{{version:apiVersion}}/{{nameof(MyService)}}", (bool input, [FromServices] IMyService myService, HttpContext context) =>
    {
        var apiVersion = context.GetRequestedApiVersion();
        app.Logger.LogInformation("Calling Version {apiVersion} Of {name} With {input}", apiVersion, nameof(MyService), input);
        return myService.MyMethod(input);
    })
        .WithApiVersionSet(versionSet)
        .MapToApiVersion(_v1)
        .RequireAuthorization("MyClaimPolicy");

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
        .RequireAuthorization("MyClaimPolicy");

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
