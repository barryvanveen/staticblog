---
title: "Tracking exceptions with Bugsnag"
date: 2016-06-16T22:00:00+02:00
draft: false
summary: "Until today, I kept an eye on any errors on this website by sending them to myself by email. Although this works, I thought it was time to look for a better way of handling exceptions. Enter Bugsnag, a service that lets you track errors and exceptions and view them in a dashboard. These are my first experiences working with Bugsnag."
types: ['tutorial']
subjects: ['observability', 'logging', 'devops', 'laravel']
params:
  outdated_warning: true
---

Until today, I kept an eye on any errors on this website by sending them to myself by email. Although this works, I thought it was time to look for a better way of handling exceptions. Enter [Bugsnag](https://bugsnag.com/), a service that lets you track errors and exceptions and view them in a dashboard. These are my first experiences working with Bugsnag.

## Easy installation
Signing up for Bugsnag was fast and installing it was almost as easy. Thanks to the [bugsnag-laravel](https://github.com/bugsnag/bugsnag-laravel) package it's as easy as replacing the default `App\Exceptions\Handler` class.

The documentation is excellent, there are just 2 things that I did to expand on the default installation:

1. In order to track the version number of my project with each exception I have the following report function:
```php
public function report(Exception $e)
{
    Bugsnag::setAppVersion(config('app.version'));

    parent::report($e);
}
```

2. Because the [environment configuration](https://laravel.com/docs/5.2/configuration#environment-configuration) doesn't allow for array values I've set up my `/config/bugsnag.php` configuration for with a static array:
```php
'notify_release_stages' => array('production'),
```

## And now we wait
So far, so good. Everything is set up and now it is time to wait and see how the dashboard and notifications work. Bugsnag supplies multiple integrations with (among others) Slack, Hipchat and Github issues, but that is something for later.

## Free for open source
It is possible to sign up for a free 14-day trial with access to all features. Open source projects can [even request free access as detailed in this blog post](http://blog.bugsnag.com/bugsnag-loves-open-source). I did and am now enjoying the benefits, which is also why I wanted to share my great experience with you :-)
