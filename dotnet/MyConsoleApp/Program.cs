/*******************************************************************************
https://github.com/ronhowe
*******************************************************************************/

using BenchmarkDotNet.Attributes;
using BenchmarkDotNet.Configs;
using BenchmarkDotNet.Jobs;
using BenchmarkDotNet.Loggers;
using BenchmarkDotNet.Running;
using FluentAssertions;
using System.Diagnostics;
using System.Net;

namespace MyConsoleApp;

public class Program
{
    private static bool _noBenchmark;
    private static bool _noClear;
    private static bool _noColor;

    static void Main(string[] args)
    {
        if (args.Length == 0 || !Uri.TryCreate(args[0], UriKind.Absolute, out Uri? uri))
        {
            uri = new Uri("https://LOCALHOST:444/api/MyService?input=false");
        }

        _noBenchmark = args.Contains("--nobenchmark");
        _noClear = args.Contains("--noclear");
        _noColor = args.Contains("--nocolor");

        var background = Console.BackgroundColor;
        Console.CancelKeyPress += (sender, e) =>
        {
            Console.BackgroundColor = background;
            if (!_noClear)
            {
                Console.Clear();
            }
        };

        Stopwatch stopwatch = new();

        while (true)
        {
            HttpClient client = new();

            stopwatch.Start();

            try
            {
                var response = client.GetAsync(uri).Result;
                response.StatusCode.Should().Be(HttpStatusCode.OK);

                Refresh("OK", stopwatch.ElapsedMilliseconds, uri, ConsoleColor.DarkGreen);

                foreach (var header in response.Headers)
                {
                    if (header.Key == "CustomHeader")
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
                client.Dispose();
            }

            if (!_noBenchmark)
            {
                var config = ManualConfig
                    .Create(DefaultConfig.Instance)
                    .WithOptions(ConfigOptions.DisableOptimizationsValidator)
                    .AddJob(Job.Dry.WithIterationCount(1).WithWarmupCount(1));

                // TODO: Resolve .sln reference error.
                var summary = BenchmarkRunner.Run<MyBenchmark>(config);
            }

            Thread.Sleep(1000);
        }
    }

    private static void Refresh(string message, long duration, Uri uri, ConsoleColor color)
    {
        if (!_noColor)
        {
            Console.BackgroundColor = color;
        }
        if (!_noClear)
        {
            Console.Clear();
        }
        Console.WriteLine($"{DateTime.UtcNow} - {uri} - {message} - {duration} ms");
    }
}

public class MyBenchmark
{
    private readonly bool input;

    MyBenchmark() { input = false; }

    [Benchmark]
    public void MyBenchmarkMethod() => Console.WriteLine($"Benchmarking {input}");
}
