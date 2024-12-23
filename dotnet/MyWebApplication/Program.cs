using Asp.Versioning;
using Asp.Versioning.Builder;
using Microsoft.ApplicationInsights.AspNetCore.Extensions;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Mvc;
using Microsoft.FeatureManagement;
using Microsoft.IdentityModel.Tokens;
using MyClassLibrary;
using MyWebApplication;
using Serilog;
using Serilog.Events;
using SerilogEnricherCollection.Enricher;
using System.Text;

const string _outputTemplate = "[{UtcTimestamp:yyyy-MM-dd HH:mm:ss.fff}] [{Level:u3}] [{MachineName}] [{SourceContext}] {Message}{NewLine}{Exception}";
const string _sourceContext = nameof(Program);

Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Verbose()
    .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
    .Enrich.FromLogContext()
    .Enrich.WithMachineName()
    .Enrich.WithUtcTimestamp()
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
    WebApplicationBuilder _builder = WebApplication.CreateBuilder(args);

    Log.ForContext("SourceContext", _sourceContext).Information("Logging Environment Name");
    string _environmentName = _builder.Environment.EnvironmentName;
    Log.ForContext("SourceContext", _sourceContext).Debug("_environmentName = {_environmentName}", _environmentName);

    Log.ForContext("SourceContext", _sourceContext).Information("Using Serilog");
    _builder.Host.UseSerilog((hostContext, loggerConfiguration) =>
    {
        loggerConfiguration.ReadFrom.Configuration(hostContext.Configuration);
        loggerConfiguration.Enrich.WithUtcTimestamp();
    });

    Log.ForContext("SourceContext", _sourceContext).Information("Configuring Application Insights Connection String");
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

    Log.ForContext("SourceContext", _sourceContext).Information("Adding Open API ServicesServices");
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
            string _key = $"/{new string('*', 4096 / 8)}";
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

    const string _myClaimPolicy = "MyClaimPolicy";

    Log.ForContext("SourceContext", _sourceContext).Information("Adding Authorization Services");
    _builder.Services.AddAuthorizationBuilder()
        .AddPolicy(_myClaimPolicy, policy =>
            policy.RequireClaim("MyClaimType", "MyClaimValue"));

    Log.ForContext("SourceContext", _sourceContext).Information("Building Web Application");
    WebApplication _app = _builder.Build();

    _app.Logger.LogTrace("POST (1 of 6) => Trace Logging ON");
    _app.Logger.LogDebug("POST (2 of 6) => Debug Logging ON");
    _app.Logger.LogInformation("POST (3 of 6) => Information Logging ON");
    _app.Logger.LogWarning("POST (4 of 6) => Warning Logging ON");
    _app.Logger.LogError("POST (5 of 6) => Error Logging ON");
    _app.Logger.LogCritical("POST (6 of 6) => Critical Logging ON");
    _app.Logger.LogInformation("{now} (LOCAL)", DateTime.Now);
    _app.Logger.LogInformation("{utcNow} (UTC)", DateTime.UtcNow);

    // NOTE: Order matters. (e.g. Swagger before Authentication)

    _app.Logger.LogInformation("Using Request Logging Middleware");
    _app.UseMiddleware<RequestLoggingMiddleware>();

    if (!_app.Environment.IsDevelopment())
    {
        _app.Logger.LogInformation("Using Exception Handling Middleware");
        _app.UseExceptionHandler("/error");
    }

    _app.Logger.LogInformation("Mapping Open API");
    _app.MapOpenApi();

    _app.Logger.LogInformation("Using HTTPS Redirection Middleware");
    _app.UseHttpsRedirection();

    _app.Logger.LogInformation("Using Serilog Request Logging Middleware");
    _app.UseSerilogRequestLogging();

    _app.Logger.LogInformation("Using Header Middleware");
    _app.Use(async (context, next) =>
    {
        const string _myHeaderKey = "MyHeader";

        _app.Logger.LogInformation("Configuring Header");
        string? _myHeaderValue = _app.Configuration.GetSection(_myHeaderKey).Value;
        _app.Logger.LogDebug("_myHeaderValue = {_myHeaderValue}", _myHeaderValue);

        _app.Logger.LogInformation("Appending Header");
        context.Response.Headers.Append(_myHeaderKey, _myHeaderValue);

        await next();
    });

    _app.Logger.LogInformation("Using Health Check Middleware");
    _app.UseHealthChecks("/healthcheck");

    _app.Logger.LogInformation("Using Authentication Middleware");
    _app.UseAuthentication();

    _app.Logger.LogInformation("Using Claims Logger Middleware");
    _app.Use(async (context, next) =>
    {
        _app.Logger.LogInformation("Selecting Claims From Context");
        _app.Logger.LogDebug("_claims = {@_claims}", context.User.Claims.Select(c => new { c.Type, c.Value }).ToList());
        await next.Invoke();
    });

    _app.Logger.LogInformation("Using Authorization Middleware");
    _app.UseAuthorization();

    ApiVersionSet _versionSet = _app.NewApiVersionSet()
        .HasApiVersion(new ApiVersion(1))
        .HasApiVersion(new ApiVersion(2))
        .ReportApiVersions()
        .Build();

    // TODO: Use better {tokens} for better discoverability.

    const int _version1 = 1;
    _app.Logger.LogInformation("Mapping Version {version} GET Requests To {name}", _version1, nameof(MyService));
    _app.MapGet($"/v{{version:apiVersion}}/{{nameof(MyService)}}", (bool input, [FromServices] IMyService myService, HttpContext context) =>
    {
        var apiVersion = context.GetRequestedApiVersion();
        _app.Logger.LogInformation("Calling Version {apiVersion} Of {name} With {input}", apiVersion, nameof(MyService), input);
        return myService.MyMethodAsync(input);
    })
        .WithApiVersionSet(_versionSet)
        .MapToApiVersion(_version1)
        .RequireAuthorization(_myClaimPolicy);

    const int _version2 = 2;
    _app.Logger.LogInformation("Mapping Version {version} GET Requests To {name}", _version2, nameof(MyService));
    _app.MapGet($"/v{{version:apiVersion}}/{{nameof(MyService)}}", (bool input, [FromServices] IMyService myService, HttpContext context) =>
    {
        ApiVersion? _apiVersion = context.GetRequestedApiVersion();

        _app.Logger.LogInformation("Calling Version {_apiVersion} Of {name} With {input}", _apiVersion, nameof(MyService), input);
        return myService.MyMethodAsync(input);
    })
        .WithApiVersionSet(_versionSet)
        .MapToApiVersion(_version2)
        .RequireAuthorization(_myClaimPolicy);

    await _app.RunAsync();
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
