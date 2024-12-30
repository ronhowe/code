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

Good.  Not perfect.

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

https://azure.microsoft.com/en-us/pricing/calculator/

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
    2024-12-29 13:37:53.491 (LOCAL)
    2024-12-29 18:37:53.491 (UTC)
    Initializing Test
    Building Web Host
    Creating Client
    [2024-12-29 18:37:53.493] [VRB] [DEATHSTAR] [Program] POST (1 of 6) => Verbose Logging ON
    [2024-12-29 18:37:53.494] [DBG] [DEATHSTAR] [Program] POST (2 of 6) => Debug Logging ON
    [2024-12-29 18:37:53.495] [INF] [DEATHSTAR] [Program] POST (3 of 6) => Information Logging ON
    [2024-12-29 18:37:53.496] [WRN] [DEATHSTAR] [Program] POST (4 of 6) => Warning Logging ON
    [2024-12-29 18:37:53.497] [ERR] [DEATHSTAR] [Program] POST (5 of 6) => Error Logging ON
    [2024-12-29 18:37:53.498] [FTL] [DEATHSTAR] [Program] POST (6 of 6) => Fatal Logging ON
    [2024-12-29 18:37:53.500] [INF] [DEATHSTAR] [Program] 12/29/2024 13:37:53 (LOCAL)
    [2024-12-29 18:37:53.501] [INF] [DEATHSTAR] [Program] 12/29/2024 18:37:53 (UTC)
    [2024-12-29 18:37:53.503] [INF] [DEATHSTAR] [Program] Creating Web Application Builder
    [2024-12-29 18:37:53.507] [INF] [DEATHSTAR] [Program] Logging Environment Name
    [2024-12-29 18:37:53.509] [DBG] [DEATHSTAR] [Program] _environmentName = "Development"
    [2024-12-29 18:37:53.510] [INF] [DEATHSTAR] [Program] Using Serilog
    [2024-12-29 18:37:53.511] [INF] [DEATHSTAR] [Program] Configuring Application Insights Connection String
    [2024-12-29 18:37:53.512] [DBG] [DEATHSTAR] [Program] _aiConnectionString = ""
    [2024-12-29 18:37:53.514] [INF] [DEATHSTAR] [Program] Adding Application Insights Telemetry
    [2024-12-29 18:37:53.515] [INF] [DEATHSTAR] [Program] Adding Feature Management Services
    [2024-12-29 18:37:53.517] [INF] [DEATHSTAR] [Program] Adding Health Check Services
    [2024-12-29 18:37:53.518] [INF] [DEATHSTAR] [Program] Adding API Versioning Services
    [2024-12-29 18:37:53.520] [INF] [DEATHSTAR] [Program] Adding Open API ServicesServices
    [2024-12-29 18:37:53.521] [INF] [DEATHSTAR] [Program] Adding "MyRepository" Services
    [2024-12-29 18:37:53.522] [INF] [DEATHSTAR] [Program] Adding "MyService" Services
    [2024-12-29 18:37:53.524] [INF] [DEATHSTAR] [Program] Adding Authentication Services
    [2024-12-29 18:37:53.525] [INF] [DEATHSTAR] [Program] Adding Authorization Services
    [2024-12-29 18:37:53.526] [INF] [DEATHSTAR] [Program] Building Web Application
    [2024-12-29 18:37:53.540] [VRB] [DEATHSTAR] [MyWebApplication] POST (1 of 6) => Trace Logging ON
    [2024-12-29 18:37:53.557] [DBG] [DEATHSTAR] [MyWebApplication] POST (2 of 6) => Debug Logging ON
    [2024-12-29 18:37:53.558] [INF] [DEATHSTAR] [MyWebApplication] POST (3 of 6) => Information Logging ON
    [2024-12-29 18:37:53.559] [WRN] [DEATHSTAR] [MyWebApplication] POST (4 of 6) => Warning Logging ON
    [2024-12-29 18:37:53.560] [ERR] [DEATHSTAR] [MyWebApplication] POST (5 of 6) => Error Logging ON
    [2024-12-29 18:37:53.563] [FTL] [DEATHSTAR] [MyWebApplication] POST (6 of 6) => Critical Logging ON
    [2024-12-29 18:37:53.565] [INF] [DEATHSTAR] [MyWebApplication] 12/29/2024 13:37:53 (LOCAL)
    [2024-12-29 18:37:53.566] [INF] [DEATHSTAR] [MyWebApplication] 12/29/2024 18:37:53 (UTC)
    [2024-12-29 18:37:53.568] [INF] [DEATHSTAR] [MyWebApplication] Using Request Logging Middleware
    [2024-12-29 18:37:53.569] [INF] [DEATHSTAR] [MyWebApplication] Mapping Open API
    [2024-12-29 18:37:53.571] [INF] [DEATHSTAR] [MyWebApplication] Using HTTPS Redirection Middleware
    [2024-12-29 18:37:53.572] [INF] [DEATHSTAR] [MyWebApplication] Using Serilog Request Logging Middleware
    [2024-12-29 18:37:53.573] [INF] [DEATHSTAR] [MyWebApplication] Using Header Middleware
    [2024-12-29 18:37:53.574] [INF] [DEATHSTAR] [MyWebApplication] Using Health Check Middleware
    [2024-12-29 18:37:53.576] [INF] [DEATHSTAR] [MyWebApplication] Using Authentication Middleware
    [2024-12-29 18:37:53.578] [INF] [DEATHSTAR] [MyWebApplication] Using Claims Logger Middleware
    [2024-12-29 18:37:53.579] [INF] [DEATHSTAR] [MyWebApplication] Using Authorization Middleware
    [2024-12-29 18:37:53.580] [INF] [DEATHSTAR] [MyWebApplication] Mapping Version 1 GET Requests To "MyService"
    [2024-12-29 18:37:53.582] [INF] [DEATHSTAR] [MyWebApplication] Mapping Version 2 GET Requests To "MyService"
    Generating Bearer Token
    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJNeUNsYWltVHlwZSI6Ik15Q2xhaW1WYWx1ZSIsIm5iZiI6MTczNTQ5NzQ3MywiZXhwIjoxNzM1NDk5MjczLCJpYXQiOjE3MzU0OTc0NzMsImlzcyI6InlvdXJJc3N1ZXIiLCJhdWQiOiJ5b3VyQXVkaWVuY2UifQ.GJ1QaE2aAqq6HVG-pSCfeNDtwZRPOgyLZVsf8MnXP5I
    Sending GET Request With True
    [2024-12-29 18:37:53.718] [INF] [DEATHSTAR] [MyWebApplication.RequestLoggingMiddleware] Incoming HTTP Request
    [2024-12-29 18:37:53.719] [INF] [DEATHSTAR] [MyWebApplication] Configuring Header
    [2024-12-29 18:37:53.720] [DBG] [DEATHSTAR] [MyWebApplication] _myHeaderValue = "MyHeader (Development)"
    [2024-12-29 18:37:53.721] [INF] [DEATHSTAR] [MyWebApplication] Appending Header
    [2024-12-29 18:37:53.724] [INF] [DEATHSTAR] [MyWebApplication] Selecting Claims From Context
    [2024-12-29 18:37:53.725] [DBG] [DEATHSTAR] [MyWebApplication] _claims = [{Type="MyClaimType", Value="MyClaimValue"}, {Type="nbf", Value="1735497473"}, {Type="exp", Value="1735499273"}, {Type="iat", Value="1735497473"}, {Type="iss", Value="yourIssuer"}, {Type="aud", Value="yourAudience"}]
    [2024-12-29 18:37:53.734] [INF] [DEATHSTAR] [MyWebApplication] Calling Version "2" Of "MyService" With True
    [2024-12-29 18:37:53.736] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Entering "MyService"
    [2024-12-29 18:37:53.737] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] myInput = True
    [2024-12-29 18:37:53.738] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Configuring MyConfiguration
    [2024-12-29 18:37:53.739] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] _myConfiguration = "MyWebApplication (Development)"
    [2024-12-29 18:37:53.740] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Configuring MySecret
    [2024-12-29 18:37:53.741] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] _mySecret = "MyWebApplication"
    [2024-12-29 18:37:53.743] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Configuring MyFeature
    [2024-12-29 18:37:53.744] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] _myFeature = True
    [2024-12-29 18:37:53.745] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Saving Input To Repository
    [2024-12-29 18:37:53.746] [INF] [DEATHSTAR] [MyClassLibrary.MyRepository] Entering "MyRepository"
    [2024-12-29 18:37:53.748] [DBG] [DEATHSTAR] [MyClassLibrary.MyRepository] myInput = True
    [2024-12-29 18:37:53.750] [INF] [DEATHSTAR] [MyClassLibrary.MyRepository] Configuring Database Connection String
    [2024-12-29 18:37:53.751] [DBG] [DEATHSTAR] [MyClassLibrary.MyRepository] _dbConnectionString = "Server=localhost;Database=MyDatabase;Integrated Security=True;Application Name=MyWebApplication (Development);Encrypt=False;Connect Timeout=1;Command Timeout=0;"
    [2024-12-29 18:37:53.752] [INF] [DEATHSTAR] [MyClassLibrary.MyRepository] Configuring Azure Storage Connection String
    [2024-12-29 18:37:53.753] [DBG] [DEATHSTAR] [MyClassLibrary.MyRepository] _azConnectionString = "UseDevelopmentStorage=true;"
    [2024-12-29 18:37:53.755] [INF] [DEATHSTAR] [MyClassLibrary.MyRepository] Generating Row Key
    [2024-12-29 18:37:53.756] [INF] [DEATHSTAR] [MyClassLibrary.MyRepository] Saving "019413b5-dedc-7ed2-b8fb-b4c17ccff7f4"
    [2024-12-29 18:37:53.757] [INF] [DEATHSTAR] [MyClassLibrary.MyRepository] Creating Retry Policy
    [2024-12-29 18:37:53.759] [DBG] [DEATHSTAR] [MyClassLibrary.MyRepository] Executing With Retry Policy
    [2024-12-29 18:37:53.760] [INF] [DEATHSTAR] [MyClassLibrary.MyRepository] Saving To Database
    [2024-12-29 18:37:53.761] [INF] [DEATHSTAR] [MyClassLibrary.MyRepository] Opening Connection
    [2024-12-29 18:37:53.762] [INF] [DEATHSTAR] [MyClassLibrary.MyRepository] Executing Command
    [2024-12-29 18:37:53.765] [INF] [DEATHSTAR] [MyClassLibrary.MyRepository] Save To Database Succeeded
    [2024-12-29 18:37:53.766] [INF] [DEATHSTAR] [MyClassLibrary.MyRepository] Saving To Azure Storage
    [2024-12-29 18:37:53.767] [INF] [DEATHSTAR] [MyClassLibrary.MyRepository] Creating Table
    [2024-12-29 18:37:53.776] [INF] [DEATHSTAR] [MyClassLibrary.MyRepository] Adding Entity
    [2024-12-29 18:37:53.800] [INF] [DEATHSTAR] [MyClassLibrary.MyRepository] Save To Azure Storage Succeeded
    [2024-12-29 18:37:53.802] [INF] [DEATHSTAR] [MyClassLibrary.MyRepository] Exiting "MyRepository"
    [2024-12-29 18:37:53.803] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Returning True
    [2024-12-29 18:37:53.804] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Exiting "MyService"
    [2024-12-29 18:37:53.806] [INF] [DEATHSTAR] [MyWebApplication.RequestLoggingMiddleware] Outgoing HTTP Response
    Asserting HTTP Status Code Is OK
    MyHeader: MyHeader (Development)
    api-supported-versions: 1, 2
    Asserting Header
    Asserting API Supported Versions Header
    Asserting Result Is True
    Cleaning Test

# Shell Menu

    - Applications
        Cat Fact
        Weather
        MyService
    - Azure
        Connect
        Disconnect
        Show
        Switch
        Share
    - DevOps
        - .NET
            Measure
            Pipeline
        - Notepad
            Open
            New
            Zip
            Email
            Publish
        - Pester
            API
            Module
            Resources
    - Games
        Solitaire
    - Streaming
        Start
        Stop
        Ping
        Transcode
    - Help
        About
        Commands
        - Configuration
            New
            Edit
            Import
            Show
        Debug
        - Dependencies
            Install
            Test
        - Profile
            Auto Run Off
            Auto Run On
    Clock

# Getting Started

-- TODO: Add steps to enlist the repo, profile and Shell.
