---
title: "Code coverage when running PHPUnit on Laravel Homestead"
date: 2017-09-04T23:00:00+02:00
draft: false
summary: "This is a quick tip on how to get code coverage results when running PHPUnit on Laravel Homestead. This will enable Xdebug first and then run your tests."
types: ['tutorial']
subjects: ['laravel', 'testing', 'configuration', 'phpunit']
params:
  outdated_warning: true
---
This is a quick tip on how to get code coverage results when running PHPUnit on Laravel Homestead. This will enable Xdebug first and then run your tests.

## Xdebug is not enabled by default

When you use the PHP CLI on Laravel Homestead, Xdebug is not enabled by default.

```bash
vagrant@homestead:~/Code/lastfm$ php -v
PHP 7.1.8-2+ubuntu16.04.1+deb.sury.org+4 (cli) (built: Aug  4 2017 13:04:12) ( NTS )
Copyright (c) 1997-2017 The PHP Group
Zend Engine v3.1.0, Copyright (c) 1998-2017 Zend Technologies
    with Zend OPcache v7.1.8-2+ubuntu16.04.1+deb.sury.org+4, Copyright (c) 1999-2017, by Zend Technologies
    with blackfire v1.17.3~linux-x64-non_zts71, https://blackfire.io, by SensioLabs
```

So, when you run your PHPUnit tests it will tell you that no code coverage driver was found and no code coverage will be reported.

```bash
vagrant@homestead:~/Code/lastfm$ phpunit
PHPUnit 6.2.4 by Sebastian Bergmann and contributors.

Runtime:       PHP 7.1.8-2+ubuntu16.04.1+deb.sury.org+4
Configuration: /home/vagrant/Code/lastfm/phpunit.xml
Error:         No code coverage driver is available

.......................                                           23 / 23 (100%)

Time: 308 ms, Memory: 6.00MB

OK (23 tests, 40 assertions)
```
Luckily, there's an easy solution for this.

## How to enable Xdebug
There are 2 aliases that you can use to quickly enable and disable Xdebug: `xon` and `xoff`. As you would expect, `xon` enables Xdebug and `xoff` disables it again.

So, we can run our code coverage in the following way:
```bash
vagrant@homestead:~/Code/lastfm$ xon
vagrant@homestead:~/Code/lastfm$ phpunit
PHPUnit 6.2.4 by Sebastian Bergmann and contributors.

Runtime:       PHP 7.1.8-2+ubuntu16.04.1+deb.sury.org+4 with Xdebug 2.5.5
Configuration: /home/vagrant/Code/lastfm/phpunit.xml

.......................                                           23 / 23 (100%)

Time: 1.77 seconds, Memory: 8.00MB

OK (23 tests, 40 assertions)

Generating code coverage report in Clover XML format ... done

Generating code coverage report in HTML format ... done
``` 

Afterwards you can disable Xdebug again if you want to have a slightly better performance.

## Usage outside Laravel Homestead
Both these aliases are available in Laravel Homestead by default. If you want to use them on you own machine, add the following lines to the `.bash_aliases` file in your home directory:

```bash
alias xoff='sudo phpdismod -s cli xdebug'
alias xon='sudo phpenmod -s cli xdebug'
```
