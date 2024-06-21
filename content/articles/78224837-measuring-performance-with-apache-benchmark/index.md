---
title: "Measuring performance with Apache Benchmark"
date: 2022-03-15T18:49:00+02:00
draft: false
summary: "I made a script to easily take consistent measurements using Apache Benchmark. It includes an easy way to compare multiple measurements in a visual way."
types: ['project']
subjects: ['performance', 'opensource', 'javascript']
params:
  outdated_warning: false
resources:
  - name: ab-runner-comparison
    src: 'ab-runner-comparison.png'
    title: "Comparison plot of 2 ab-runner tests"
    params:
      alt: "Comparison of 2 benchmark tests. The cached version of the website is faster with a mean of 148ms, compared to a mean of 199ms for the uncached versio"
---
There are a couple of plans I have to improve the performance of this blog. Among other things, I want to try enabling [opcache preloading](https://www.php.net/manual/en/opcache.preloading).

But, if you want to find out _how well_ this works, you have to measure the performance before and after.

Over the past couple of weeks, I've thought about many different approaches. Turns out it is very hard to come up with 1 way to "measure performance".

In the end, I made the decision that it is more important to be consistent than to optimize the performance test itself.

So, I've come up with a script that measures the performance of a webpage. You can run it easily and it stores all necessary data. It also contains some nice ways to compare performance across measurements.

## Measuring performance with Apache Benchmark

So, my way of measuring performance is now stored in the [ab-runner repository](https://github.com/barryvanveen/ab-runner).

A simple test can be executed by running `./abrunner.js measure -u https://localhost.test/ -o results/foo`.

By default, the `measure` command does the following:
- Using Apache Benchmark, it makes 500 requests with a concurrency of 10.
- It repeats that test 10 times, with 5 minutes of waiting time between each test.
- It combines the results and plots the data so you can visually inspect it.

As mentioned before, I believe that a consistent approach is the most important thing here. As long as all measurements are taken in a similar way, they give comparable results.

Still, the default values have some reasoning behind them.

The number of requests and concurrency should not be too high. My goal is not to overload the server. Instead, I'm curious what the "normal performance" of the website is.

Performance tests can be influenced by outside factors. Maybe my server is busy running a cronjob. Maybe my internet connection is temporarily slow. To account for these outliers, the script takes multiple measurements that are spaced out over time.

If you go over to the [ab runner repository](https://github.com/barryvanveen/ab-runner), you can see how to run the script yourself and change the default values.

## Comparing performance

Of course, this whole thing is set up so you can easily test your website before and after a change and see the difference.

Comparing multiple measurements is as easy as running `./abrunner.js compare` with a set in input files, labels, and an output directory. You can compare 2 or more measurements.

The `compare` command results in a plot like this:

{{< figure src="ab-runner-comparison" >}}

Besides that, it also creates a file with some information about the mean, median, min, and max values for all input files.

If you are unsure how to interpret this value, I recommend you read this excellent mathbootcamps.com article on [how to read a boxplot](https://www.mathbootcamps.com/how-to-read-a-boxplot/).

## Conclusion

Using these scripts it should be quick and easy to measure and compare the performance of different configurations. If you are interested, please head over to the [ab-runner](https://github.com/barryvanveen/ab-runner) repository and try it out for yourself.

If you do give it a try, I would love to hear your feedback!