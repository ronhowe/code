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
    2024-12-23 14:26:31.182 (LOCAL)
    2024-12-23 19:26:31.182 (UTC)
    Initializing Test
    Building Web Host
    Creating Client
    [2024-12-23 19:26:31.183] [VRB] [DEATHSTAR] [Program] POST (1 of 6) => Verbose Logging ON
    [2024-12-23 19:26:31.184] [DBG] [DEATHSTAR] [Program] POST (2 of 6) => Debug Logging ON
    [2024-12-23 19:26:31.186] [INF] [DEATHSTAR] [Program] POST (3 of 6) => Information Logging ON
    [2024-12-23 19:26:31.187] [WRN] [DEATHSTAR] [Program] POST (4 of 6) => Warning Logging ON
    [2024-12-23 19:26:31.188] [ERR] [DEATHSTAR] [Program] POST (5 of 6) => Error Logging ON
    [2024-12-23 19:26:31.189] [FTL] [DEATHSTAR] [Program] POST (6 of 6) => Fatal Logging ON
    [2024-12-23 19:26:31.190] [INF] [DEATHSTAR] [Program] 12/23/2024 14:26:31 (LOCAL)
    [2024-12-23 19:26:31.191] [INF] [DEATHSTAR] [Program] 12/23/2024 19:26:31 (UTC)
    [2024-12-23 19:26:31.193] [INF] [DEATHSTAR] [Program] Creating Web Application Builder
    [2024-12-23 19:26:31.197] [INF] [DEATHSTAR] [Program] Getting Environment Name From Environment
    [2024-12-23 19:26:31.198] [DBG] [DEATHSTAR] [Program] environmentName = "Development"
    [2024-12-23 19:26:31.199] [INF] [DEATHSTAR] [Program] Using Serilog
    [2024-12-23 19:26:31.200] [INF] [DEATHSTAR] [Program] Getting Application Insights Connection String
    [2024-12-23 19:26:31.202] [DBG] [DEATHSTAR] [Program] _aiConnectionString = ""
    [2024-12-23 19:26:31.203] [INF] [DEATHSTAR] [Program] Adding Application Insights Telemetry
    [2024-12-23 19:26:31.204] [INF] [DEATHSTAR] [Program] Adding Feature Management Services
    [2024-12-23 19:26:31.205] [INF] [DEATHSTAR] [Program] Adding Health Check Services
    [2024-12-23 19:26:31.206] [INF] [DEATHSTAR] [Program] Adding API Versioning Services
    [2024-12-23 19:26:31.208] [INF] [DEATHSTAR] [Program] Adding "MyRepository" Services
    [2024-12-23 19:26:31.209] [INF] [DEATHSTAR] [Program] Adding "MyService" Services
    [2024-12-23 19:26:31.210] [INF] [DEATHSTAR] [Program] Adding Authentication Services
    [2024-12-23 19:26:31.211] [INF] [DEATHSTAR] [Program] Adding Authorization Services
    [2024-12-23 19:26:31.213] [INF] [DEATHSTAR] [Program] Building Web Application
    [2024-12-23 19:26:31.228] [VRB] [DEATHSTAR] [MyWebApplication] POST (1 of 6) => Trace Logging ON
    [2024-12-23 19:26:31.241] [DBG] [DEATHSTAR] [MyWebApplication] POST (2 of 6) => Debug Logging ON
    [2024-12-23 19:26:31.242] [INF] [DEATHSTAR] [MyWebApplication] POST (3 of 6) => Information Logging ON
    [2024-12-23 19:26:31.243] [WRN] [DEATHSTAR] [MyWebApplication] POST (4 of 6) => Warning Logging ON
    [2024-12-23 19:26:31.244] [ERR] [DEATHSTAR] [MyWebApplication] POST (5 of 6) => Error Logging ON
    [2024-12-23 19:26:31.245] [FTL] [DEATHSTAR] [MyWebApplication] POST (6 of 6) => Critical Logging ON
    [2024-12-23 19:26:31.247] [INF] [DEATHSTAR] [MyWebApplication] 12/23/2024 14:26:31 (LOCAL)
    [2024-12-23 19:26:31.248] [INF] [DEATHSTAR] [MyWebApplication] 12/23/2024 19:26:31 (UTC)
    [2024-12-23 19:26:31.249] [INF] [DEATHSTAR] [MyWebApplication] Using Request Logging Middleware
    [2024-12-23 19:26:31.251] [INF] [DEATHSTAR] [MyWebApplication] Mapping Open API
    [2024-12-23 19:26:31.252] [INF] [DEATHSTAR] [MyWebApplication] Using HTTPS Redirection Middleware
    [2024-12-23 19:26:31.254] [INF] [DEATHSTAR] [MyWebApplication] Using Serilog Request Logging Middleware
    [2024-12-23 19:26:31.255] [INF] [DEATHSTAR] [MyWebApplication] Using Header Middleware
    [2024-12-23 19:26:31.256] [INF] [DEATHSTAR] [MyWebApplication] Using Health Check Middleware
    [2024-12-23 19:26:31.258] [INF] [DEATHSTAR] [MyWebApplication] Using Authentication Middleware
    [2024-12-23 19:26:31.259] [INF] [DEATHSTAR] [MyWebApplication] Using Claims Logger Middleware
    [2024-12-23 19:26:31.261] [INF] [DEATHSTAR] [MyWebApplication] Using Authorization Middleware
    [2024-12-23 19:26:31.262] [INF] [DEATHSTAR] [MyWebApplication] Mapping Version 1 GET Requests To "MyService"
    [2024-12-23 19:26:31.264] [INF] [DEATHSTAR] [MyWebApplication] Mapping Version 2 GET Requests To "MyService"
    Generating Bearer Token
    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJNeUNsYWltVHlwZSI6Ik15Q2xhaW1WYWx1ZSIsIm5iZiI6MTczNDk4MTk5MSwiZXhwIjoxNzM0OTgzNzkxLCJpYXQiOjE3MzQ5ODE5OTEsImlzcyI6InlvdXJJc3N1ZXIiLCJhdWQiOiJ5b3VyQXVkaWVuY2UifQ.SBYtN_oja363idQrjZILXY2BxLt7tpteVMcGBlGF0Yg
    Sending GET Request With True
    [2024-12-23 19:26:31.387] [INF] [DEATHSTAR] [MyWebApplication.RequestLoggingMiddleware] Incoming HTTP Request
    [2024-12-23 19:26:31.388] [INF] [DEATHSTAR] [MyWebApplication] Getting Header From Configuration.
    [2024-12-23 19:26:31.389] [DBG] [DEATHSTAR] [MyWebApplication] myHeader = "MyHeader (Development)"
    [2024-12-23 19:26:31.391] [INF] [DEATHSTAR] [MyWebApplication] Appending Header
    [2024-12-23 19:26:31.393] [INF] [DEATHSTAR] [MyWebApplication] Selecting Claims From Context
    [2024-12-23 19:26:31.394] [DBG] [DEATHSTAR] [MyWebApplication] claims = [{Type="MyClaimType", Value="MyClaimValue"}, {Type="nbf", Value="1734981991"}, {Type="exp", Value="1734983791"}, {Type="iat", Value="1734981991"}, {Type="iss", Value="yourIssuer"}, {Type="aud", Value="yourAudience"}]
    [2024-12-23 19:26:31.402] [INF] [DEATHSTAR] [MyWebApplication] Calling Version "2" Of "MyService" With True
    [2024-12-23 19:26:31.404] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Entering "MyService"
    [2024-12-23 19:26:31.405] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] myInput = True
    [2024-12-23 19:26:31.407] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Getting MyConfiguration From Configuration
    [2024-12-23 19:26:31.408] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] myConfiguration = "MyWebApplication (Development)"
    [2024-12-23 19:26:31.409] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Getting MySecret From Configuration
    [2024-12-23 19:26:31.411] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] mySecret = "MyWebApplication"
    [2024-12-23 19:26:31.412] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Getting MyFeature From Configuration
    [2024-12-23 19:26:31.413] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] myFeature = True
    [2024-12-23 19:26:31.415] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Saving Input To Repository
    [2024-12-23 19:26:31.417] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Entering "MyRepository"
    [2024-12-23 19:26:31.418] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] myInput = True
    [2024-12-23 19:26:31.419] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Getting Database Connection String From Configuration
    [2024-12-23 19:26:31.420] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] dbConnectionString = "Server=localhost;Database=MyDatabase;Integrated Security=True;Application Name=MyWebApplication (Development);Encrypt=False;Connect Timeout=1;Command Timeout=0;"
    [2024-12-23 19:26:31.422] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Getting Azure Storage Connection String From Configuration
    [2024-12-23 19:26:31.423] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] azConnectionString = "UseDevelopmentStorage=true;"
    [2024-12-23 19:26:31.424] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Generating Row Key
    [2024-12-23 19:26:31.426] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Saving "0193f4fc-3c02-7f4c-a277-d89116eb0fd6"
    [2024-12-23 19:26:31.427] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Creating Retry Policy
    [2024-12-23 19:26:31.428] [DBG] [DEATHSTAR] [MyClassLibrary.MyService] Executing With Retry Policy
    [2024-12-23 19:26:31.429] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Saving To Database
    [2024-12-23 19:26:31.431] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Opening Connection
    [2024-12-23 19:26:31.432] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Executing Command
    [2024-12-23 19:26:31.434] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Save To Database Succeeded
    [2024-12-23 19:26:31.435] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Saving To Azure Storage
    [2024-12-23 19:26:31.436] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Creating Table
    [2024-12-23 19:26:31.447] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Adding Entity
    [2024-12-23 19:26:31.463] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Save To Azure Storage Succeeded
    [2024-12-23 19:26:31.465] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Exiting "MyRepository"
    [2024-12-23 19:26:31.466] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Returning True
    [2024-12-23 19:26:31.467] [INF] [DEATHSTAR] [MyClassLibrary.MyService] Exiting "MyService"
    [2024-12-23 19:26:31.469] [INF] [DEATHSTAR] [MyWebApplication.RequestLoggingMiddleware] Outgoing HTTP Response
    Asserting HTTP Status Code Is OK
    MyHeader: MyHeader (Development)
    api-supported-versions: 1, 2
    Asserting Header
    Asserting API Supported Versions Header
    Asserting Result Is True
    Cleaning Test
