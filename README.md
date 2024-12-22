# [https://github.com/ronhowe](https://github.com/ronhowe)

`Code I wrote.  Free for public use.`

# Exploring Ideas

- AI (Copilot)
- Architecture (ASP.NET Minimal Web API, Async/Await, Dependency Injection)
- Branching (dev, issue, main)
- Compute (App Service, Docker, Function App, IIS, Kestrel)
- Cost (Licenses, Hardware, Serverless)
- Dependencies (Dependabot, nuget.org, PowerShell Gallery)
- DevOps (Actions, Azure DevOps, GitHub, Issues, Pipelines)
- Discoverability (Application Insights, Open API)
- Engineering (Docker, NCrunch, Visual Studio, Visual Studio Code, WSL)
- Logging (LogLevel, Serilog, Sinks, Standard Filters, Structured Logs)
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

# Repo Structure

- Azure (azure)
- .NET (dotnet)
- PowerShell (powershell)
- Roll20 (roll20)
- SQL (sql)

# Logging Strategy

## Mapping Logging Levels

    .NET            Serilog         PowerShell          Style
    -----------     -----------     -------------       -----------------------------
    Trace           Verbose         Write-Debug         metrics
    Debug           Debug           Write-Debug         var = var
    Information     Information     Write-Verbose       Doing Something
    Warning         Warning         Write-Warning       Skipping Something Unexpected
    Error           Error           Write-Error         Something Failed Because
    Critical        Fatal           Write-Error         CRITICAL ERROR / FATAL ERROR

- TODO: Stylize metrics.
- TODO: Document default visibility for Production and Development.
- NOTE: Write-Output should be resolved for results and pipeline data.
- NOTE: Write-Debug and Write-Information unsupproted in Azure Automation.  Use local debugging to solve.
- NOTE: Don't ever log secrets.  Use remote debugging to solve.

## Logging Power-On Self-Tests

    app.Logger.LogTrace("POST (1 of 6) => Trace Logging ON");
    app.Logger.LogDebug("POST (2 of 6) => Debug Logging ON");
    app.Logger.LogInformation("POST (3 of 6) => Information Logging ON");
    app.Logger.LogWarning("POST (4 of 6) => Warning Logging ON");
    app.Logger.LogError("POST (5 of 6) => Error Logging ON");
    app.Logger.LogCritical("POST (6 of 6) => Critical Logging ON");
    app.Logger.LogInformation("{now} (LOCAL)", DateTime.Now);
    app.Logger.LogInformation("{utcNow} (UTC)", DateTime.UtcNow);

    Log.ForContext("SourceContext", _sourceContext).Verbose("POST (1 of 6) => Verbose Logging ON");
    Log.ForContext("SourceContext", _sourceContext).Debug("POST (2 of 6) => Debug Logging ON");
    Log.ForContext("SourceContext", _sourceContext).Information("POST (3 of 6) => Information Logging ON");
    Log.ForContext("SourceContext", _sourceContext).Warning("POST (4 of 6) => Warning Logging ON");
    Log.ForContext("SourceContext", _sourceContext).Error("POST (5 of 6) => Error Logging ON");
    Log.ForContext("SourceContext", _sourceContext).Fatal("POST (6 of 6) => Fatal Logging ON");
    Log.ForContext("SourceContext", _sourceContext).Information("{now} (LOCAL)", DateTime.Now);
    Log.ForContext("SourceContext", _sourceContext).Information("{utcNow} (UTC)", DateTime.UtcNow);

## Logging Methods

    logger.LogInformation("Entering {name}", nameof(MyRepository));
    logger.LogInformation("Exiting {name}", nameof(MyRepository));

    Write-Verbose "Beginning $($MyInvocation.MyCommand.Name)"
    Write-Verbose "Processing $($MyInvocation.MyCommand.Name)"
    Write-Verbose "Ending $($MyInvocation.MyCommand.Name)"

## Logging Variables

    Write-Debug "`$$($_.Name) = $($_.Value)"

# Credits

- TODO: Replace links with friendly names.
- TODO: Add links to all open source PowerShell module dependencies.

## Content

Please support all these wonderful content creators.

- [Nick Chapsas - The New ID To Replace GUIDs and Integers in .NET](https://www.youtube.com/watch?v=nJ1ppFayHOk&t=276s)
- [Nick Chapsas - Implementing Modern API Versioning in .NET](https://www.youtube.com/watch?v=8Asq7ymF1R8)

## Home Pages

- [https://github.com/Azure](https://github.com/Azure)
- [https://benchmarkdotnet.org/](https://benchmarkdotnet.org/)
- [https://semver.org/](https://semver.org/)
- [https://thepollyproject.org/](https://thepollyproject.org/)
- [https://github.com/adamdriscoll/pspolly](https://github.com/adamdriscoll/pspolly)
- [https://github.com/PoShLog/PoShLog](https://github.com/PoShLog/PoShLog)

# Technical Documentation

- [Build, test, and deploy .NET Core apps](https://learn.microsoft.com/en-us/azure/devops/pipelines/ecosystems/dotnet-core?view=azure-devops&tabs=yaml-editor)
- [PowerShell@2 - PowerShell v2 task](https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/reference/powershell-v2?view=azure-pipelines)
