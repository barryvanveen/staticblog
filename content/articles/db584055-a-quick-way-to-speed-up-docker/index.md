---
title: "A quick way to speed up Docker"
date: 2022-10-15T13:19:06+01:00
draft: false
summary: "I've heard many devs working on MacOS that their Docker development environment is slow. Enabling these experimental features can be a quick and easy improvement."
types: ['tutorial']
subjects: ['tools', 'performance', 'docker']
resources:
  - name: docker-settings
    src: 'docker-settings.png'
    title:
    params:
      alt: "Screenshot of Docker (version 4.12.0) settings screen with experimental features enabled"
  - name: ab-runner-comparison
    src: 'ab-runner-comparison.png'
    title: "Comparison plot of 3 ab-runner tests"
    params:
      alt: "Comparison of 3 benchmark tests. When Docker\'s experimental features are enabled, response times drop from a mean of 785ms to a mean of 232ms."
---

I've heard many devs working on MacOS that their Docker development environment is slow. Enabling these experimental features can be a quick and easy improvement.

## Experimental features

In Docker Desktop, go to Settings and then to Experimental features.

Enable "Use the new Virtualization framework" and "Enable VirtioFS accelerator directory sharing".

Press "Apply & Restart".

{{< figure src="docker-settings" >}}

## Performance

Apache Benchmark can be used to test the performance increase of these features. Using my recently created [ab-runner](https://github.com/barryvanveen/ab-runner) tool simplifies the process.

For each setup, the script made 500 requests to the about page of this blog (running locally on Docker, of course). Response times are averaged over all runs. Docker is running version 4.12.0, MacOS is on version 12.6.

The first run (left) was done with default settings. For the second run (middle) only the new Virtualization framework feature was enabled. The third run (right) also enabled the VirtioFS feature.

{{< figure src="ab-runner-comparison" >}}

<figure>
  <a href="/images/db584055-ab-runner-comparison-original.png" title="View the full sized image" target="_blank">
    <img src="/images/db584055-ab-runner-comparison-750.png"
         srcset="/images/db584055-ab-runner-comparison-320.png 320w, /images/db584055-ab-runner-comparison-480.png 480w, /images/db584055-ab-runner-comparison-750.png 750w"
         sizes="(max-width: 320px) 320px, (max-width: 480px) 480px, 750px"
         alt="Comparison of 3 benchmark tests. When Docker's experimental features are enabled, response times drop from a mean of 785ms to a mean of 232ms."
         loading="lazy">
  </a>
  <figcaption>Comparison plot of 3 ab-runner tests</figcaption>
</figure>

The results are very clear: response times went down from 785 ms to 232 ms. That is more than 3 times as fast as before!

Naturally, your milage may very, depending on your project and on your machine.

Just give it a go. It takes less 5 minutes to change and might make your developer experience a lot better.