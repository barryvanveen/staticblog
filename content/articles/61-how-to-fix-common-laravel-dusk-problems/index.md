---
title: "How to fix common Laravel Dusk problems"
date: 2019-09-06T11:00:00+02:00
draft: false
summary: "Every time I've updated Laravel Homestead or started a new environment, I've had problems running Laravel Dusk. These are solutions for the most common problems."
types: ['tutorial']
subjects: ['devops', 'cheatsheet', 'laravel']
params:
  outdated_warning: true
---
Every time I've updated Laravel Homestead or started a new environment, I've had problems running Laravel Dusk. These are solutions for the most common problems.

*Note that these solutions are not mine, they were found mostly on StackOverflow. However, there are many questions and answers out there and not all of them worked for me. These solutions have not failed me once so they might help you out too.*

## Failed to connect
The error message:
```shell
Failed to connect to localhost port 9515: Connection refused
```

SSH into Homestead. If you call the chrome driver directly using `vendor/laravel/dusk/bin/chromedriver-linux`, you should see this message.
```shell
error while loading shared libraries: libnss3.so: cannot open shared object file: No such file or directory
```

Install missing `libnss3` and `chromium-browser` packages with:
```shell
sudo apt-get update
sudo apt-get install -y libnss3 chromium-browser
```

## Chromium version mismatch

The error message:
```shell
Facebook\WebDriver\Exception\SessionNotCreatedException: session not created: This version of ChromeDriver only supports Chrome version 76
  (Driver info: chromedriver=76.0.3809.68 (420c9498db8ce8fcd190a954d51297672c1515d5-refs/branch-heads/3809@{#864}),platform=Linux 4.15.0-55-generic x86_64)
```

*** Update:
Laravel now ships with an easy command to fix this problem. Just run `php artisan dusk:chrome-driver --detect` and it will automatically install the correct driver version.

If you don't have access to this artisan command, the following might work for you:
*** End of update

SSH into Homestead. Check what major version of `chromium-browser` is installed by running `chromium-browser --version`, e.g. `75`

Now install this version of the dusk chrome-driver with `php artisan dusk:chrome-driver 75`