---
title: "My Server Administration Cheat Sheet"
date: 2022-12-30T15:59:53+01:00
draft: false
summary: "Some of the commands that I use to install and maintain my web server."
types: ['tutorial']
subjects: ['devops', 'linux', 'server', 'administration', 'security', 'cheatsheet']
---
This is a short list of commands that I commonly use to install and update the server that runs this blog.

## Upgrading

I tend to upgrade all software every couple of weeks and this lists helps me remember the individual steps.

### Upgrade packages
{{< highlight sh >}}
sudo apt-get update
sudo apt-get upgrade
{{< / highlight >}}

### Check if we need to reboot
{{< highlight sh >}}
ls /var/run/reboot-required
{{< / highlight >}}

### Reboot
{{< highlight sh >}}
sudo shutdown -r now
{{< / highlight >}}

## Installing

When installing a new server, I usually set up some Netherlands/Dutch specific things.

### Set time zone
{{< highlight sh >}}
timedatectl set-timezone Europe/Amsterdam
{{< / highlight >}}

### Install locales
{{< highlight sh >}}
sudo locale-gen nl_NL
sudo locale-gen nl_NL.UTF-8
sudo update-locale
{{< / highlight >}}

## Misc

This is one of the things I regularly use on my working machine.

### List programs using port 80
{{< highlight sh >}}
lsof -i -P -n | grep LISTEN | grep 80
{{< / highlight >}}
