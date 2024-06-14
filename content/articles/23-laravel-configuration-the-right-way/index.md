---
title: "Laravel configuration, the right way"
date: 2016-02-19T19:00:00+02:00
draft: false
summary: "In this article I want to show you the best practices of configuring your Laravel application."
types: ['tutorial']
subjects: ['laravel', 'configuration']
params:
  outdated_warning: true
---

In this article I want to show you the best practices of configuring your Laravel application.

## DotEnv
Laravel uses [dotenv](https://github.com/vlucas/phpdotenv) to set up the configuration of your application. Basically this means that you create a file called `.env` which contains all sensitive data. Think of stuff like usernames, passwords and API tokens that you don't want to upload to your public repository. You don't add this file to your repository, the whole point is that you keep it private.

A good [sample `.env` file](https://github.com/laravel/laravel/blob/master/.env.example) can be in the Laravel project.

Remember to put quotes around values with spaces! Not doing this triggers a [ReflectionException "Class log does not exist"](https://laracasts.com/discuss/channels/general-discussion/class-log-does-not-exist).

```shell
# bad, wil trigger exception
name=Barry van Veen
# good
name="Barry van Veen"
```

## Configuration files
In Laravel 5 your project will have a /config folder containing all configuration files. In these files you can access values from `.env` using the [`env()` helper function](https://laravel.com/docs/5.2/helpers#method-env).

The installation has included a number of files for you. With these you can configure stuff like the database, mail and caching. If you want to include your own file that is very easy: just create a file in /config and make it return an array.

I have created `/config/custom.php` for my own configuration. This keeps the other files nice and clean.

```php
<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Google Analytics code
    |--------------------------------------------------------------------------
    */
    'google_analytics_code' => env('GA_CODE'),

    /*
    |--------------------------------------------------------------------------
    | Nested values
    |--------------------------------------------------------------------------
    */
    'nested_values' => [
        'first' => env('NESTED_VALUES_FIRST'),
        'second' => env('NESTED_VALUES_SECOND'),
    ],

];
```

## Accessing configuration variables
So, now that your configuration is set up it is time to use these values in your application code. This can be done with the [`config()` helper function](https://laravel.com/docs/5.2/helpers#method-config).

Accessing my custom Google Analytics code can be done using:
```php
config('custom.google_analytics_code');
```

In the same way we can access nested values like this:
```php
config('custom.nested_values.first')
```

## Keep on reading
* [Introduction into Laravel configuration](https://laracasts.com/series/laravel-5-fundamentals/episodes/6) at Laracasts.
* [Laravel docs on configuration](https://laravel.com/docs/5.2/configuration).