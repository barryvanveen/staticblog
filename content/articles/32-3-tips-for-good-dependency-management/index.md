---
title: "3 tips for good dependency management"
date: 2016-10-23T19:00:00+02:00
draft: false
summary: "Updating dependencies can be tricky, especially if you let them build up over time. These are my tips to stay on top of any changes and make updating as painless as possible."
types: ['tutorial']
subjects: ['devops', 'upgrades', 'php', 'npm']
params:
  outdated_warning: true
---
Updating dependencies can be tricky, especially if you let them build up over time. These are my tips to stay on top of any changes and make updating as painless as possible.

*Update 18/12/2016: yarn now has a --no-bin-links options, I've changed section 3 about dependency managers.*

## 1. Update regularly
The worst dependencies are outdated dependencies. If you maintain your project on a regular basis each update will just take a couple of minutes. Updating multiple packages at the same time, especially if they include breaking changes, may take you hours to process and test.

So, keep to a fixed schedule in which you update regularly. This could be every few days to every few weeks, depending on the size of your project and the speed with which your dependencies are changing.

## 2. Require well-defined versions
If you require a new dependency, think about which version you need.

Assuming the package uses [semver versioning](http://semver.org/), which it should, it is probably best to define the minor version number to use. So for Laravel Framework that would be `5.3.*`.

Requiring a major version (e.g. `5.*`) is probably too loose a definition as Laravel requires quite a few changes between minor releases. Requiring a patch (e.g. `5.3.19`) is too narrow a definition and makes updating harder than necessary.

## 3. Use a dependency manager with a lock file
A lock file stores the exact packages and their versions that were installed. If you require Laravel Framework at version `5.3.*` it is the lock file that stores the exact version (e.g. `5.3.1` or `5.3.19`) that is currently installed.

Especially when you are working in a team, it is important to know that every team member uses the exact same dependencies.

Composer uses a lock file by default, so that's good. Bower and npm don't use a lock file by default and should be replaced when you have the possibility. [Yarn](https://yarnpkg.com/) is the shiny new dependency manager by Facebook that has out-of-the-box support for a lock file. Yarn can be used to replace both Bower and npm.

At first I had trouble using Yarn on my Homestead vm because VirtualBox doesn't support symlinks. That has been solved and I can now run "yarn install --no-bin-links". Profit!