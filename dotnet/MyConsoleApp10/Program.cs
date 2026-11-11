using BenchmarkDotNet.Attributes;
using BenchmarkDotNet.Configs;
using BenchmarkDotNet.Jobs;
using BenchmarkDotNet.Running;
using Shouldly;
using System.Diagnostics;
using System.Net;

namespace MyConsoleApp10;

/// <summary>
/// Simple console application for health checking a remote endpoint with optional benchmarking.
/// </summary>
public class Program
{
    private static bool _benchmark;
    private static bool _clear;
    private static bool _nocolor;
    private static bool _noHeaders;

    /// <summary>
    /// Main entry point. Continuously polls a health check endpoint and displays the results.
    /// </summary>
    /// <param name="args">Command-line arguments: URI (optional), --benchmark, --clear, --nocolor, --noheaders</param>
    static async Task Main(string[] args)
    {
        if (args.Length == 0 || !Uri.TryCreate(args[0], UriKind.Absolute, out Uri? uri))
        {
            uri = new Uri("https://localhost:444/healthcheck");
        }

        _benchmark = args.Contains("--benchmark");
        _clear = args.Contains("--clear");
        _nocolor = args.Contains("--nocolor");
        _noHeaders = args.Contains("--noheaders");

        var background = Console.BackgroundColor;
        Console.CancelKeyPress += (sender, e) =>
        {
            Console.BackgroundColor = background;
            if (_clear)
            {
                Console.Clear();
            }
        };

        if (_benchmark)
        {
            // TODO: Resolve .sln reference error during benchmark run.
            var config = ManualConfig
                .Create(DefaultConfig.Instance)
                .WithOptions(ConfigOptions.DisableOptimizationsValidator)
                .AddJob(Job.Dry.WithIterationCount(1).WithWarmupCount(1));

            Console.WriteLine("Running Benchmark");
            var summary = BenchmarkRunner.Run<MyBenchmark>(config);
        }

        Stopwatch stopwatch = new();

        // Create HttpClient once for reuse
        HttpClientHandler handler = new()
        {
            // NOTE: Needed for localhost and lab environments with untrusted, self-signed certificates.
            ServerCertificateCustomValidationCallback = HttpClientHandler.DangerousAcceptAnyServerCertificateValidator
        };

        using HttpClient client = new(handler);

        while (true)
        {
            stopwatch.Start();

            try
            {
                var response = await client.GetAsync(uri);
                response.StatusCode.ShouldBe(HttpStatusCode.OK);

                Refresh("OK", stopwatch.ElapsedMilliseconds, uri, ConsoleColor.DarkGreen);

                foreach (var header in response.Headers)
                {
                    if (!_noHeaders)
                    {
                        Console.WriteLine($"{header.Key} = {header.Value.FirstOrDefault()}");
                    }
                }
            }
            catch (Exception e)
            {
                Refresh(e.Message, stopwatch.ElapsedMilliseconds, uri, ConsoleColor.DarkRed);
            }
            finally
            {
                stopwatch.Stop();
                stopwatch.Reset();
            }

            await Task.Delay(1000);
        }
    }

    /// <summary>
    /// Refreshes the console display with the health check result.
    /// </summary>
    /// <param name="message">Status message to display.</param>
    /// <param name="duration">Time in milliseconds the operation took.</param>
    /// <param name="uri">The URI being checked.</param>
    /// <param name="color">The background color to use.</param>
    private static void Refresh(string message, long duration, Uri uri, ConsoleColor color)
    {
        if (!_nocolor)
        {
            Console.BackgroundColor = color;
        }
        if (_clear)
        {
            Console.Clear();
        }
        Console.WriteLine($"{DateTime.UtcNow} - {uri} - {message} - {duration} ms");
    }
}

/// <summary>
/// Benchmark test for measuring performance.
/// </summary>
public class MyBenchmark
{
    private readonly bool input;

    /// <summary>
    /// Initializes a new instance of the MyBenchmark class.
    /// </summary>
    public MyBenchmark() { input = false; }

    /// <summary>
    /// Benchmark method that outputs a message.
    /// </summary>
    [Benchmark]
    public void MyBenchmarkMethod() => Console.WriteLine($"Benchmarking {input}");
}
