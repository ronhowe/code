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

Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Verbose()
    .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
    .Enrich.FromLogContext()
    .Enrich.WithMachineName()
    .Enrich.WithUtcTimestamp()
    .WriteTo.Console(outputTemplate: WebConstants.Logging.OutputTemplate)
    .CreateLogger();

Serilog.ILogger logger = Log.ForContext("SourceContext", WebConstants.Logging.SourceContext);

logger.Information("Creating Web Application Builder");
WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

logger.Information("Logging Environment Name");
string environmentName = builder.Environment.EnvironmentName;
logger.Debug("environmentName = {environmentName}", environmentName);

logger.Information("Using Serilog");
builder.Host.UseSerilog((hostContext, loggerConfiguration) =>
{
    loggerConfiguration.ReadFrom.Configuration(hostContext.Configuration);
    loggerConfiguration.Enrich.WithUtcTimestamp();
});

logger.Information("Configuring Application Insights Connection String");
var aiConnectionString = builder.Configuration["ConnectionStrings:ApplicationInsights"];
logger.Debug("aiConnectionString = {aiConnectionString}", aiConnectionString);

if (!string.IsNullOrWhiteSpace(aiConnectionString))
{
    logger.Information("Adding Application Insights Telemetry");
    builder.Services.AddApplicationInsightsTelemetry(options =>
    {
        options.ConnectionString = aiConnectionString;
    });
}

logger.Information("Adding Feature Management Services");
builder.Services.AddFeatureManagement();

logger.Information("Adding Health Check Services");
builder.Services.AddHealthChecks().AddCheck<MyHealthCheck>("MyHealthCheck");

logger.Information("Adding API Versioning Services");
builder.Services.AddApiVersioning(options =>
{
    options.ApiVersionReader = new UrlSegmentApiVersionReader();
});

logger.Information("Adding Retry Configuration Services");
var retryConfigSection = builder.Configuration.GetSection("RetrySettings");
if (retryConfigSection.Exists())
{
    builder.Services.Configure<RetrySettings>(retryConfigSection);
}
else
{
    builder.Services.Configure<RetrySettings>(options =>
    {
        options.MaxRetries = 3;
        options.RetryMilliseconds = 1000;
    });
}

logger.Information("Adding {name} Services", nameof(MyRepository));
builder.Services.AddSingleton<IMyRepository, MyRepository>();

logger.Information("Adding {name} Services", nameof(MyService));
builder.Services.AddSingleton<IMyService, MyService>();

logger.Information("Adding Authentication Services");
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        string jwtKey = builder.Configuration["Jwt:Key"] ?? $"/{new string('*', 4096 / 8)}";
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["Jwt:Issuer"] ?? WebConstants.JWT.DefaultIssuer,
            ValidAudience = builder.Configuration["Jwt:Audience"] ?? WebConstants.JWT.DefaultAudience,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey))
        };
    });

logger.Information("Adding Authorization Services");
builder.Services.AddAuthorizationBuilder()
    .AddPolicy(WebConstants.Policies.MyClaimPolicy, policy =>
        policy.RequireClaim(WebConstants.Claims.MyClaimType, WebConstants.Claims.MyClaimValue));

logger.Information("Building Web Application");
WebApplication app = builder.Build();

if (app.Logger.IsEnabled(LogLevel.Information))
{
    app.Logger.LogInformation("Using Request Logging Middleware");
}
app.UseMiddleware<RequestLoggingMiddleware>();

if (!app.Environment.IsDevelopment())
{
    if (app.Logger.IsEnabled(LogLevel.Information))
    {
        app.Logger.LogInformation("Using Exception Handling Middleware");
    }
    app.UseExceptionHandler(WebConstants.Routes.Error);
}

if (app.Logger.IsEnabled(LogLevel.Information))
{
    app.Logger.LogInformation("Using HTTPS Redirection Middleware");
}
app.UseHttpsRedirection();

if (app.Logger.IsEnabled(LogLevel.Information))
{
    app.Logger.LogInformation("Using Serilog Request Logging Middleware");
}
app.UseSerilogRequestLogging();

if (app.Logger.IsEnabled(LogLevel.Information))
{
    app.Logger.LogInformation("Using Header Middleware");
}
app.Use(async (context, next) =>
{
    string headerValue = app.Configuration.GetSection(WebConstants.Headers.MyHeader).Value ?? $"{WebConstants.Headers.MyHeader} (Unknown)";
    context.Response.Headers.Append(WebConstants.Headers.MyHeader, headerValue);
    await next();
});

if (app.Logger.IsEnabled(LogLevel.Information))
{
    app.Logger.LogInformation("Using Health Check Middleware");
}
app.UseHealthChecks(WebConstants.Routes.HealthCheck);

if (app.Logger.IsEnabled(LogLevel.Information))
{
    app.Logger.LogInformation("Using Authentication Middleware");
}
app.UseAuthentication();

if (app.Logger.IsEnabled(LogLevel.Information))
{
    app.Logger.LogInformation("Using Authorization Middleware");
}
app.UseAuthorization();

ApiVersionSet versionSet = app.NewApiVersionSet()
    .HasApiVersion(new ApiVersion(1))
    .HasApiVersion(new ApiVersion(2))
    .ReportApiVersions()
    .Build();

app.MapGet($"/v{{version:apiVersion}}/{{nameof(MyService)}}", (bool input, [FromServices] IMyService myService, HttpContext context, CancellationToken cancellationToken) =>
{
    var apiVersion = context.RequestedApiVersion;
    if (app.Logger.IsEnabled(LogLevel.Information))
    {
        app.Logger.LogInformation("Calling API {name} Version {apiVersion} With Input = {input}", nameof(MyService), apiVersion, input);
    }
    return myService.ProcessAsync(SaveRequest.Create(input), cancellationToken);
})
    .WithApiVersionSet(versionSet)
    .MapToApiVersion(new ApiVersion(1))
    .RequireAuthorization(WebConstants.Policies.MyClaimPolicy);

app.MapGet($"/v{{version:apiVersion}}/{{nameof(MyService)}}", (bool input, [FromServices] IMyService myService, HttpContext context, CancellationToken cancellationToken) =>
{
    var apiVersion = context.RequestedApiVersion;
    if (app.Logger.IsEnabled(LogLevel.Information))
    {
        app.Logger.LogInformation("Calling API {name} Version {apiVersion} With Input = {input}", nameof(MyService), apiVersion, input);
    }
    return myService.ProcessAsync(SaveRequest.Create(input), cancellationToken);
})
    .WithApiVersionSet(versionSet)
    .MapToApiVersion(new ApiVersion(2))
    .RequireAuthorization(WebConstants.Policies.MyClaimPolicy);

await app.RunAsync();
