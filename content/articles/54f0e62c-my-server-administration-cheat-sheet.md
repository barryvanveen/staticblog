---
title: "My Server Administration Cheat Sheet"
date: 2022-12-30T15:59:53+01:00
draft: false
summary: "Some of the commands that I use to install and maintain my web server."
---
This is a short list of commands that I commonly use to install and update the server that runs this blog.

## Upgrading

I tend to upgrade all software every couple of weeks and this lists helps me remember the individual steps.

### Upgrade packages
```
sudo apt-get update
sudo apt-get upgrade
```

### Check if we need to reboot
```
ls /var/run/reboot-required
```

### Reboot
```
sudo shutdown -r now
```

## Installing

When installing a new server, I usually set up some Netherlands/Dutch specific things.

### Set time zone
```
timedatectl set-timezone Europe/Amsterdam
```

### Install locales
```
sudo locale-gen nl_NL
sudo locale-gen nl_NL.UTF-8
sudo update-locale
```

## Misc

This is one of the things I regularly use on my working machine.

### List programs using port 80
```
lsof -i -P -n | grep LISTEN | grep 80
```

