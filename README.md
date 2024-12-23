# [https://github.com/ronhowe](https://github.com/ronhowe)

`Code I wrote.  Free for public use.`

## Table of Contents
1. [Mission](#mission)
2. [Ideas](#ideas)
3. [Repo](#repo)
4. [Costs](#costs)
5. [Credits](#credits)
6. [Logging](#logging)

# Mission

Good, not perfect.

# Ideas

- AI (Copilot)
- Architecture (ASP.NET Minimal Web API, Async/Await, Dependency Injection)
- Branching (dev, issue, main)
- Compute (App Service, Docker, Function App, IIS, Kestrel)
- Cost (Licenses, Hardware, Serverless, Software)
- Dependencies (Dependabot, nuget.org, PowerShell Gallery)
- DevOps (Actions, Azure DevOps, GitHub, Issues, Pipelines)
- Discoverability (Application Insights, Open API)
- Engineering (Docker, NCrunch, Visual Studio, Visual Studio Code, WSL)
- Logging (LogLevel, Serilog, Sinks, Standard Filters, Structured Logs, Universal Time Coordinated)
- Maintainability (Dashboards, Runbooks)
- Monitoring (Application Insights, Console App, PerfMon, Pester, SQL Profiler, Visual Studio)
- Operations (az, azdo, gh, git, pwsh)
- Performance (Benchmark.NET, Dashboards, Indexes, IO, JMeter, PKI, RowKey)
- Platform (Azure, Linux, .NET, PowerShell, SQL Server, Windows)
- Publishing (Azure Artifacts, NuGet)
- Reliability (Failover, Healthchecks, Redundancy)
- Resilience (Chaos, Polly)
- Resources (DSC, localhost vs Hyper-V vs Azure)
- Scalability (Containers, Dynamic Scaling Up/Down vs In/Out, PartitionKey)
- Security (AuthN/AuthZ, WAF, Secrets, Certificates, SSL)
- Socials (E-mail, GitHub, LinkedIn, Patreon, X, Twitch, YouTube)
- Standards (Style, Comments, Log Levels, Markdown, Tags)
- Storage (Azure Storage Tables, SQL Server)
- Testing (Code Coverage, Debug vs Unit vs Integration, dotnet test, Moq, NCrunch, TDD)
- UX (Swagger)
- Versioning (1.0.0 vs 1.0.0.0, v1 vs v2)

# Repo

- Azure (azure)
  - Bicep for deploying [Azure](https://portal.azure.com/) resources.
- .NET (dotnet)
  - C# for building an [ASP.NET Core](https://dotnet.microsoft.com/en-us/apps/aspnet) Minimal API.
- PowerShell (powershell)
  - Scripts for automating everything.
- Roll20 (roll20)
  - Macros for playing [Dungeons & Dragons](https://www.dndbeyond.com/) on [Roll20](https://roll20.net/).
- SQL (sql)
  - Scripts for operating [Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server/).

# Costs

- [Azure](https://azure.microsoft.com/en-us)
  - App Service - $54.75 per month / $1.80 per day / $657 per year
    - Basic Tier B1
    - Windows
    - 1 Core(s)
    - 1.75 GB RAM
    - 10 GB Storage
  - App Configuration - $36.06 per month / $1.26 per day / $460 per year
    - Standard Tier
  - Azure SQL Database - $14.72 per month / $0.48 per day / $175 per year
    - Standard Tier, S0
    - 10 DTUs
    - 250 GB included storage
- [GitHub Copilot](https://github.com/features/copilot/) - $10 per month / $120 per year
  - Pro - For developers who want unlimited access to GitHub Copilot.
  - First 30 days free.
- GoDaddy
  - DNS [ronhowe.net](https://ronhowe.net) - $24.99 per year
  - Single Domain DV SSL - $99.99 per year
- [NCrunch](https://www.ncrunch.net/) - $159 once
  - A single user license.
  - Includes 1 year of updates.
  - $79/year for updates after that.

# Credits

Please support these creators and communities.

- [BenchmarkDotNet ](https://benchmarkdotnet.org/)
- [Nick Chapsas](https://www.youtube.com/@nickchapsas)
    - [The New ID To Replace GUIDs and Integers in .NET](https://www.youtube.com/watch?v=nJ1ppFayHOk)
    - [Implementing Modern API Versioning in .NET](https://www.youtube.com/watch?v=8Asq7ymF1R8)
- [PoShLog](https://github.com/PoShLog/PoShLog/)
- [PSPolly](https://github.com/adamdriscoll/pspolly/)
- [The Polly Project](https://thepollyproject.org/)

# Logging

[Cascadia Mono PL](https://github.com/microsoft/cascadia-code) 14 pt

## Mapping Logging Levels

    .NET            Serilog         PowerShell          Style
    -----------     -----------     -------------       -----------------------------
    Trace           Verbose         Write-Debug         metrics
    Debug           Debug           Write-Debug         var = var
    Information     Information     Write-Verbose       Doing Something
    Warning         Warning         Write-Warning       Skipping Something Unexpected
    Error           Error           Write-Error         Something Failed Because
    Critical        Fatal           Write-Error         CRITICAL ERROR / FATAL ERROR

    -- TODO: Stylize metrics.
    -- TODO: Document default visibility for Production and Development.
    -- NOTE: Write-Output should be reserved for results and pipeline data.
    -- NOTE: Avoid Write-Host as it is not logged in Azure Automation.
    -- NOTE: Write-Debug and Write-Information are unsupproted in Azure Automation.  Use local debugging to solve.
    -- NOTE: Avoid logging secrets.  Wrap log writes with #if DEBUG.  Use remote debugging to solve.

## Power-On Self-Tests

    // C# (.NET)
    app.Logger.LogTrace("POST (1 of 6) => Trace Logging ON");
    app.Logger.LogDebug("POST (2 of 6) => Debug Logging ON");
    app.Logger.LogInformation("POST (3 of 6) => Information Logging ON");
    app.Logger.LogWarning("POST (4 of 6) => Warning Logging ON");
    app.Logger.LogError("POST (5 of 6) => Error Logging ON");
    app.Logger.LogCritical("POST (6 of 6) => Critical Logging ON");
    app.Logger.LogInformation("{now} (LOCAL)", DateTime.Now);
    app.Logger.LogInformation("{utcNow} (UTC)", DateTime.UtcNow);

    // C# (Serilog)
    Log.ForContext("SourceContext", _sourceContext).Verbose("POST (1 of 6) => Verbose Logging ON");
    Log.ForContext("SourceContext", _sourceContext).Debug("POST (2 of 6) => Debug Logging ON");
    Log.ForContext("SourceContext", _sourceContext).Information("POST (3 of 6) => Information Logging ON");
    Log.ForContext("SourceContext", _sourceContext).Warning("POST (4 of 6) => Warning Logging ON");
    Log.ForContext("SourceContext", _sourceContext).Error("POST (5 of 6) => Error Logging ON");
    Log.ForContext("SourceContext", _sourceContext).Fatal("POST (6 of 6) => Fatal Logging ON");
    Log.ForContext("SourceContext", _sourceContext).Information("{now} (LOCAL)", DateTime.Now);
    Log.ForContext("SourceContext", _sourceContext).Information("{utcNow} (UTC)", DateTime.UtcNow);

## Methods

    // C#
    logger.LogInformation("Entering {name}", nameof(MyClass));
    logger.LogInformation("Exiting {name}", nameof(MyClass));

    ## PowerShell
    Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"
    Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"

## Variables

    // C#
    logger.LogDebug("myVariable = {myVariable}", myVariable);

    ## PowerShell
    Write-Debug "`$myVariable = $myVariable"

## End-To-End Integration Test Log

    ********************************************************************************
    https://github.com/ronhowe
    ********************************************************************************
    2024-12-23 16:02:36.980 (LOCAL)
    2024-12-23 21:02:36.980 (UTC)
    Initializing Test
    Building Web Host
    Creating Client
    [2024-12-23 21:02:36.981] [VRB] [DEATHSTAR] [Program] POST (1 of 6) => Verbose Logging ON
    [2024-12-23 21:02:36.983] [DBG] [DEATHSTAR] [Program] POST (2 of 6) => Debug Logging ON
    [2024-12-23 21:02:36.984] [INF] [DEATHSTAR] [Program] POST (3 of 6) => Information Logging ON
    [2024-12-23 21:02:36.985] [WRN] [DEATHSTAR] [Program] POST (4 of 6) => Warning Logging ON
    [2024-12-23 21:02:36.986] [ERR] [DEATHSTAR] [Program] POST (5 of 6) => Error Logging ON
    [2024-12-23 21:02:36.987] [FTL] [DEATHSTAR] [Program] POST (6 of 6) => Fatal Logging ON
    [2024-12-23 21:02:36.988] [INF] [DEATHSTAR] [Program] 12/23/2024 16:02:36 (LOCAL)
    [2024-12-23 21:02:36.990] [INF] [DEATHSTAR] [Program] 12/23/2024 21:02:36 (UTC)
    [2024-12-23 21:02:36.991] [INF] [DEATHSTAR] [Program] Creating Web Application Builder
    [2024-12-23 21:02:36.996] [INF] [DEATHSTAR] [Program] Logging Environment Name
    [2024-12-23 21:02:36.997] [DBG] [DEATHSTAR] [Program] _environmentName = "Development"
    [2024-12-23 21:02:36.998] [INF] [DEATHSTAR] [Program] Using Serilog
    [2024-12-23 21:02:37.000] [INF] [DEATHSTAR] [Program] Configuring Application Insights Connection String
    [2024-12-23 21:02:37.001] [DBG] [DEATHSTAR] [Program] _aiConnectionString = ""
    [2024-12-23 21:02:37.003] [INF] [DEATHSTAR] [Program] Adding Application Insights Telemetry
    [2024-12-23 21:02:37.004] [INF] [DEATHSTAR] [Program] Adding Feature Management Services
    [2024-12-23 21:02:37.005] [INF] [DEATHSTAR] [Program] Adding Health Check Services
    [2024-12-23 21:02:37.006] [INF] [DEATHSTAR] [Program] Adding API Versioning Services
    [2024-12-23 21:02:37.008] [INF] [DEATHSTAR] [Program] Adding Open API ServicesServices
    [2024-12-23 21:02:37.009] [INF] [DEATHSTAR] [Program] Adding "MyRepository" Services
    [2024-12-23 21:02:37.010] [INF] [DEATHSTAR] [Program] Adding "MyService" Services
    [2024-12-23 21:02:37.012] [INF] [DEATHSTAR] [Program] Adding Authentication Services
    [2024-12-23 21:02:37.013] [INF] [DEATHSTAR] [Program] Adding Authorization Services
    [2024-12-23 21:02:37.014] [INF] [DEATHSTAR] [Program] Building Web Application
    [2024-12-23 21:02:37.027] [VRB] [DEATHSTAR] [MyWebApplication] POST (1 of 6) => Trace Logging ON
    [2024-12-23 21:02:37.040] [DBG] [DEATHSTAR] [MyWebApplication] POST (2 of 6) => Debug Logging ON
    [2024-12-23 21:02:37.041] [INF] [DEATHSTAR] [MyWebApplication] POST (3 of 6) => Information Logging ON
    [2024-12-23 21:02:37.042] [WRN] [DEATHSTAR] [MyWebApplication] POST (4 of 6) => Warning Logging ON
    [2024-12-23 21:02:37.043] [ERR] [DEATHSTAR] [MyWebApplication] POST (5 of 6) => Error Logging ON
    [2024-12-23 21:02:37.045] [FTL] [DEATHSTAR] [MyWebApplication] POST (6 of 6) => Critical Logging ON
    [2024-12-23 21:02:37.046] [INF] [DEATHSTAR] [MyWebApplication] 12/23/2024 16:02:37 (LOCAL)
    [2024-12-23 21:02:37.048] [INF] [DEATHSTAR] [MyWebApplication] 12/23/2024 21:02:37 (UTC)
    [2024-12-23 21:02:37.049] [INF] [DEATHSTAR] [MyWebApplication] Using Request Logging Middleware
    [2024-12-23 21:02:37.051] [INF] [DEATHSTAR] [MyWebApplication] Mapping Open API
    [2024-12-23 21:02:37.052] [INF] [DEATHSTAR] [MyWebApplication] Using HTTPS Redirection Middleware
    [2024-12-23 21:02:37.054] [INF] [DEATHSTAR] [MyWebApplication] Using Serilog Request Logging Middleware
    [2024-12-23 21:02:37.055] [INF] [DEATHSTAR] [MyWebApplication] Using Header Middleware
    [2024-12-23 21:02:37.056] [INF] [DEATHSTAR] [MyWebApplication] Using Health Check Middleware
    [2024-12-23 21:02:37.058] [INF] [DEATHSTAR] [MyWebApplication] Using Authentication Middleware
    [2024-12-23 21:02:37.059] [INF] [DEATHSTAR] [MyWebApplication] Using Claims Logger Middleware
    [2024-12-23 21:02:37.060] [INF] [DEATHSTAR] [MyWebApplication] Using Authorization Middleware
    [2024-12-23 21:02:37.062] [INF] [DEATHSTAR] [MyWebApplication] Mapping Version 1 GET Requests To "MyService"
    [2024-12-23 21:02:37.064] [INF] [DEATHSTAR] [MyWebApplication] Mapping Version 2 GET Requests To "MyService"
    Generating Bearer Token
    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJNeUNsYWltVHlwZSI6Ik15Q2xhaW1WYWx1ZSIsIm5iZiI6MTczNDk4Nzc1NywiZXhwIjoxNzM0OTg5NTU3LCJpYXQiOjE3MzQ5ODc3NTcsImlzcyI6InlvdXJJc3N1ZXIiLCJhdWQiOiJ5b3VyQXVkaWVuY2UifQ.Smd3bgpHkZomWY_zEtr9hRaYB0iOJiszWNe2AT7b4ME
    Sending GET Request With True
    [2024-12-23 21:02:37.177] [INF] [DEATHSTAR] [MyWebApplication.RequestLoggingMiddleware] Incoming HTTP Request
    [2024-12-23 21:02:37.178] [INF] [DEATHSTAR] [MyWebApplication] Configuring Header
    [2024-12-23 21:02:37.180] [DBG] [DEATHSTAR] [MyWebApplication] _myHeaderValue = "MyHeader (Development)"
    [2024-12-23 21:02:37.181] [INF] [DEATHSTAR] [MyWebApplication] Appending Header
    [2024-12-23 21:02:37.183] [INF] [DEATHSTAR] [MyWebApplication] Selecting Claims From Context
    [2024-12-23 21:02:37.185] [DBG] [DEATHSTAR] [MyWebApplication] _claims = [{Type="MyClaimType", Value="MyClaimValue"}, {Type="nbf", Value="1734987757"}, {Type="exp", Value="1734989557"}, {Type="iat", Value="1734987757"}, {Type="iss", Value="yourIssuer"}, {Type="aud", Value="yourAudience"}]
    [2024-12-23 21:02:37.194] [INF] [DEATHSTAR] [MyWebApplication] Calling Version "2" Of "MyService" With True
    [2024-12-23 21:02:37.195] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Entering "MyService"
    [2024-12-23 21:02:37.196] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] myInput = True
    [2024-12-23 21:02:37.198] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Configuring MyConfiguration
    [2024-12-23 21:02:37.199] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] _myConfiguration = "MyWebApplication (Development)"
    [2024-12-23 21:02:37.201] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Configuring MySecret
    [2024-12-23 21:02:37.202] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] _mySecret = "MyWebApplication"
    [2024-12-23 21:02:37.203] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Configuring MyFeature
    [2024-12-23 21:02:37.205] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] _myFeature = True
    [2024-12-23 21:02:37.206] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Saving Input To Repository
    [2024-12-23 21:02:37.207] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Entering "MyRepository"
    [2024-12-23 21:02:37.209] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] myInput = True
    [2024-12-23 21:02:37.210] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Configuring Database Connection String
    [2024-12-23 21:02:37.211] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] _dbConnectionString = "Server=localhost;Database=MyDatabase;Integrated Security=True;Application Name=MyWebApplication (Development);Encrypt=False;Connect Timeout=1;Command Timeout=0;"
    [2024-12-23 21:02:37.213] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Configuring Azure Storage Connection String
    [2024-12-23 21:02:37.214] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] _azConnectionString = "UseDevelopmentStorage=true;"
    [2024-12-23 21:02:37.216] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Generating Row Key
    [2024-12-23 21:02:37.217] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Saving "0193f554-36a1-769b-a032-b9a044fa6242"
    [2024-12-23 21:02:37.218] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Creating Retry Policy
    [2024-12-23 21:02:37.220] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] Executing With Retry Policy
    [2024-12-23 21:02:37.221] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Saving To Database
    [2024-12-23 21:02:37.222] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Opening Connection
    [2024-12-23 21:02:37.224] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Executing Command
    [2024-12-23 21:02:37.226] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Save To Database Succeeded
    [2024-12-23 21:02:37.227] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Saving To Azure Storage
    [2024-12-23 21:02:37.228] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Creating Table
    [2024-12-23 21:02:37.238] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Adding Entity
    [2024-12-23 21:02:37.259] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Save To Azure Storage Succeeded
    [2024-12-23 21:02:37.260] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Exiting "MyRepository"
    [2024-12-23 21:02:37.262] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Returning True
    [2024-12-23 21:02:37.263] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Exiting "MyService"
    [2024-12-23 21:02:37.265] [INF] [DEATHSTAR] [MyWebApplication.RequestLoggingMiddleware] Outgoing HTTP Response
    Asserting HTTP Status Code Is OK
    MyHeader: MyHeader (Development)
    api-supported-versions: 1, 2
    Asserting Header
    Asserting API Supported Versions Header
    Asserting Result Is True
    Cleaning Test
