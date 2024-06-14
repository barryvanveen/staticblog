---
title: "Get notifications about new releases of your dependencies"
date: 2016-10-29T17:00:00+02:00
draft: false
summary: "It's difficult to check if you need to update your dependencies. There are services that can help. This is a review of Gemnasium, VersionEye and Libraries.io, which I've tested for several weeks."
types: ['tutorial']
subjects: ['upgrades', 'devops', 'tools']
params:
  outdated_warning: true
resources:
  - name: composer-outdated-output
    src: 'composer-outdated-output.png'
    title: 'Example of output of the command "composer outdated"'
    params:
      alt: 'Example of output of the command "composer outdated"'
---

It's difficult to check if you need to update your dependencies. There are services that can help. This is a review of Gemnasium, VersionEye and Libraries.io, which I've tested for several weeks.

## Good dependency management
Last week I wrote about good dependency managed. One of the most important things is to update regularly. This makes it easy and fast.

But if you want to update regularly, you ask yourself which packages need to be updated. Finding out can be slow and boring, but luckily some services can do the work for you.

## Manually finding outdated packages
First, there is a manual way to find outdated packages. In the command line, you can run either `composer outdated`, `npm outdated` or `yarn outdated`.

The problem is that these commands also list out-of-date sub-dependencies. In my case, this is really distracting me from the stuff that really matters. 

{{< figure src="composer-outdated-output" >}}

Consider the output shown in the screenshot above. Most of these outdated packages are sub-dependencies from Laravel Framework or other dependencies that I rely on. The only dependencies that I need to update are:
* laravel/framework
* symfony/css-selector
* symfony/dom-crawler.

## Using services
There are some services that keep track of your dependencies and give you a notification when new releases are found. I've tested 3 of these services myself: VersionEye, Libraries.io and Gemnasium.

All 3 services:
* Are easy to configure.
* Track Composer, NPM and Bower dependencies (and more).
* Have a free subscription (mostly for 1 public repository) and a paid subscription for (different numbers of) private repositories.

Here is a little overview of my experiences.

**Libraries.io** [https://libraries.io/](https://libraries.io/)

Cons:
* Cluttered overview: sub-dependencies and dependencies in one overview.
* Out-of-date data: still shows Bower dependencies which I have migrated to npm.
* No settings to configure the amount or timing of notifications.

Pros:
* Supports 22 different package managers.

**VersionEye** [https://www.versioneye.com/](https://www.versioneye.com/)

Cons:
* Warns about dependencies without licenses on pull requests.
* Cluttered overview: sub-dependencies and dependencies in one overview.
* Some new releases are not parsed correctly. For example, the newest release of [PrismJS](https://github.com/PrismJS/prism) would be 9000.0.1 while it is at 1.5.1.

Pros:
* Integration with Github pull requests.
* Ability to "follow" individual repositories without tracking a full repository. This might be an alternative for a paid plan but is not really fail safe.
* Checks on known security issues for your dependencies. Haven't seen this work so I cannot say any more about it.

**Gemnasium** [https://gemnasium.com/](https://gemnasium.com/)

Cons:
* No pull request integration.

Pros:
* Best notifications system (weekly summary containing the right amount of information).
* Best web interface. It's easy to scan and allows you to view a changelog for each out-of-date dependency.
* Setting for scanning dependencies recursively or not. This way you can choose to only see your own dependencies and not sub-dependencies.
* Auto-update feature. It's still in beta and I haven't tested it. But apparently, it can try to automatically update dependencies, run your tests and the create a pull request for the changes. Sounds great!

## Conclusions
For me, Gemnasium definitely works best! It's clean, it's easy and the data about new releases was always correct.

Of course you should also have a look for yourself. Try it out on your own repository or have a look at mine, which is publicly available at the following links:
* [barryvanveen/barryvanveen at libraries.io](https://libraries.io/github/barryvanveen/barryvanveen)
* [barryvanveen/barryvanveen at VersionEye](https://www.versioneye.com/user/projects/580fbeda9cfcf70035d81775?child=summary#tab-dependencies)
* [barryvanveen/barryvanveen at Gemnasium](https://gemnasium.com/github.com/barryvanveen/barryvanveen)
