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
- Resources (DSC, LOCALHOST vs Hyper-V vs Azure)
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
