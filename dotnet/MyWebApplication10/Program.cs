using Asp.Versioning;
using Asp.Versioning.Builder;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Mvc;
using Microsoft.FeatureManagement;
using Microsoft.IdentityModel.Tokens;
using MyClassLibrary10;
using MyWebApplication10;
using Serilog;
using Serilog.Events;
using SerilogEnricherCollection.Enricher;
using System.Text;

const string _myClaimPolicy = "MyClaimPolicy";
const string _myHeaderKey = "MyHeader";
//const string _outputTemplate = "[{UtcTimestamp:yyyy-MM-dd HH:mm:ss.fff}] [{Level:u3}] [{MachineName}] [{SourceContext}] {Message}{NewLine}{Exception}";
const string _outputTemplate = "[{UtcTimestamp:yyyy-MM-dd HH:mm:ss.fff}] [{Level:u3}] [{SourceContext}] {Message}{NewLine}{Exception}";
const string _sourceContext = nameof(Program);

Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Verbose()
    .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
    .Enrich.FromLogContext()
    .Enrich.WithMachineName()
    .Enrich.WithUtcTimestamp()
    .WriteTo.Console(outputTemplate: _outputTemplate)
    .CreateLogger();

Serilog.ILogger _logger = Log.ForContext("SourceContext", _sourceContext);

try
{
    _logger.Information("Creating Web Application Builder");
    WebApplicationBuilder _builder = WebApplication.CreateBuilder(args);

    _logger.Information("Logging Environment Name");
    string _environmentName = _builder.Environment.EnvironmentName;
    _logger.Debug("_environmentName = {_environmentName}", _environmentName);

    _logger.Information("Using Serilog");
    _builder.Host.UseSerilog((hostContext, loggerConfiguration) =>
    {
        loggerConfiguration.ReadFrom.Configuration(hostContext.Configuration);
        loggerConfiguration.Enrich.WithUtcTimestamp();
    });

    _logger.Information("Configuring Application Insights Connection String");
    var _aiConnectionString = _builder.Configuration["ConnectionStrings:ApplicationInsights"];
    _logger.Debug("_aiConnectionString = {_aiConnectionString}", _aiConnectionString);

    if (!string.IsNullOrWhiteSpace(_aiConnectionString))
    {
        _logger.Information("Adding Application Insights Telemetry");
        _builder.Services.AddApplicationInsightsTelemetry(options =>
        {
            options.ConnectionString = _aiConnectionString;
        });
    }

    _logger.Information("Adding Feature Management Services");
    _builder.Services.AddFeatureManagement();

    _logger.Information("Adding Health Check Services");
    _builder.Services.AddHealthChecks().AddCheck<MyHealthCheck>("MyHealthCheck");

    _logger.Information("Adding API Versioning Services");
    _builder.Services.AddApiVersioning(options =>
    {
        // TODO: Assert versionless route works.
        options.ApiVersionReader = new UrlSegmentApiVersionReader();
    });

    //_logger.Information("Adding Open API ServicesServices");
    //_builder.Services.AddOpenApi();

    // TODO: Learn the difference between AddSingleton and AddTransient.
    _logger.Information("Adding {name} Services", nameof(MyRepository));
    _builder.Services.AddSingleton<IMyRepository, MyRepository>();

    _logger.Information("Adding {name} Services", nameof(MyService));
    _builder.Services.AddSingleton<IMyService, MyService>();

    _logger.Information("Adding Authentication Services");
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
                ValidIssuer = "myIssuer",
                ValidAudience = "myAudience",
                IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_key))
            };
        });

    _logger.Information("Adding Authorization Services");
    _builder.Services.AddAuthorizationBuilder()
        .AddPolicy(_myClaimPolicy, policy =>
            policy.RequireClaim("MyClaimType", "MyClaimValue"));

    _logger.Information("Building Web Application");
    WebApplication _app = _builder.Build();

    // NOTE: Order matters. (e.g. Swagger before Authentication)

    _app.Logger.LogInformation("Using Request Logging Middleware");
    _app.UseMiddleware<RequestLoggingMiddleware>();

    if (!_app.Environment.IsDevelopment())
    {
        _app.Logger.LogInformation("Using Exception Handling Middleware");
        _app.UseExceptionHandler("/error");
    }

    //_app.Logger.LogInformation("Mapping Open API");
    //_app.MapOpenApi();

    _app.Logger.LogInformation("Using HTTPS Redirection Middleware");
    _app.UseHttpsRedirection();

    _app.Logger.LogInformation("Using Serilog Request Logging Middleware");
    _app.UseSerilogRequestLogging();

    _app.Logger.LogInformation("Using Header Middleware");
    _app.Use(async (context, next) =>
    {
        string? _myHeaderValue = _app.Configuration.GetSection(_myHeaderKey).Value;
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
    _app.MapGet($"/v{{version:apiVersion}}/{{nameof(MyService)}}", (bool input, [FromServices] IMyService myService, HttpContext context, CancellationToken cancellationToken) =>
    {
        var apiVersion = context.RequestedApiVersion;
        if (_app.Logger.IsEnabled(LogLevel.Information))
        {
            _app.Logger.LogInformation("Calling API {name} Version {apiVersion} With Input = {input}", nameof(MyService), apiVersion, input);
        }
        return myService.ProcessAsync(SaveRequest.Create(input), cancellationToken);
    })
        .WithApiVersionSet(_versionSet)
        .MapToApiVersion(_version1)
        .RequireAuthorization(_myClaimPolicy);

    const int _version2 = 2;
    _app.MapGet($"/v{{version:apiVersion}}/{{nameof(MyService)}}", (bool input, [FromServices] IMyService myService, HttpContext context, CancellationToken cancellationToken) =>
    {
        var apiVersion = context.RequestedApiVersion;

        if (_app.Logger.IsEnabled(LogLevel.Information))
        {
            _app.Logger.LogInformation("Calling API {name} Version {apiVersion} With Input = {input}", nameof(MyService), apiVersion, input);
        }
        return myService.ProcessAsync(SaveRequest.Create(input), cancellationToken);
    })
        .WithApiVersionSet(_versionSet)
        .MapToApiVersion(_version2)
        .RequireAuthorization(_myClaimPolicy);

    await _app.RunAsync();
}
catch (Exception ex)
{
    _logger.Fatal(ex, "Program Failed");
}
finally
{
    Log.CloseAndFlush();
}
