---
title: "Reinstall global packages after updating node using NVM"
date: 2023-09-21T10:00:00+01:00
draft: false
summary: "When you use `nvm` to update a node version, you lose all globally installed `npm` packages. Use these steps to reinstall those packages."
types: ['tutorial']
subjects: ['node', 'nvm', 'npm', 'upgrades', 'linux']
---
Node Version Manager (`nvm`) is a tool I use on a daily basis. Lately, we have upgraded some projects to newer Node versions and this is causing some problems.

## The problem

My global packages (like `cdk`) were installed when I was still running version 16. Now I'm running version 18 and those packages are not globally available anymore.

The same can happen when running `nvm install` upgrades Node to a new minor or patch version.


## The solution

Next time this happens to you, follow these steps:

- Run `nvm list` to find the previously installed version, the one that "contains" the global packages
- Run `nvm reinstall-packages <previousVersion>` to get your global packages back.

## Bonus

If you want to get a list of all globally installed packages, run `
npm list -g --depth 0`.
