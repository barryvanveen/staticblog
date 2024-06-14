---
title: "How to configure security headers for Laravel"
date: 2016-12-18T17:30:00+02:00
draft: false
summary: "Any website is potentially vulnerable to different attacks. With proper security headers in place, you can minimize the risks for yourself and your visitors."
types: ['tutorial']
subjects: ['security', 'laravel', 'configuration', 'tools']
params:
  outdated_warning: true
resources:
  - name: report-ui-report
    src: 'report-ui-report.png'
    title: "Report-uri.io report"
    params:
      alt: "Report-uri.io report"
---
Some time ago I read an excellent article by Scott Helme on [security headers](https://scotthelme.co.uk/hardening-your-http-response-headers/). If you want to learn more about these headers I suggest you read the article yourself.

I've added security headers to this website and want to show you how it was done.

## Step 1: Security headers for Laravel

I've used the [bepsvpt/laravel-security-header](https://github.com/BePsvPT/laravel-security-header) package for adding security headers. It supports all the main headers plus some extra.

The configuration file is full of links to websites with more information. My [current configuration](https://github.com/barryvanveen/barryvanveen/blob/master/config/security-header.php) looks like this:

```php
<?php

$protocol = 'https://';
if (! isset($_SERVER['HTTPS']) || $_SERVER['HTTPS'] == 'off') {
    $protocol = 'http://';
}

return [
    'x-content-type-options' => 'nosniff',
    'x-download-options' => 'noopen',
    'x-frame-options' => 'sameorigin',
    'x-permitted-cross-domain-policies' => 'none',
    'x-xss-protection' => '1; mode=block',
    'referrer-policy' => 'unsafe-url',
    'hsts' => [
        'enable' => env('SECURITY_HEADER_HSTS_ENABLE', false),
        'max-age' => 31536000,
        'include-sub-domains' => true,
    ],
    'hpkp' => [
        'hashes' => false,
        'include-sub-domains' => false,
        'max-age' => 15552000,
        'report-only' => false,
        'report-uri' => null,
    ],
    'custom-csp' => env('SECURITY_HEADER_CUSTOM_CSP', null),
    'csp' => [
        'report-only' => false,
        'report-uri' => env('CONTENT_SECURITY_POLICY_REPORT_URI', false),
        'upgrade-insecure-requests' => false,
        'default-src' => [
            'self' => true,
        ],
        'script-src' => [
            'allow' => [
                $protocol.'ajax.googleapis.com',
                $protocol.'code.jquery.com',
                $protocol.'www.googletagmanager.com',
                $protocol.'www.google-analytics.com',
            ],
            'self' => true,
            'unsafe-inline' => true,
            'unsafe-eval' => true,
            'data' => true,
        ],
        'style-src' => [
            'allow' => [
                $protocol.'fonts.googleapis.com',
            ],
            'self' => true,
            'unsafe-inline' => true,
        ],
        'img-src' => [
            'allow' => [
                $protocol.'www.google-analytics.com',
            ],
            'self' => true,
            'data' => true,
        ],
        'font-src' => [
            'allow' => [
                $protocol.'fonts.gstatic.com',
            ],
            'self' => true,
            'data' => true,
        ],
        'object-src' => [
            'allow' => [],
            'self' => false,
        ],
    ],
];

```

Some notes:
* Only enable Strict-Transport-Security if you have an SSL certificate. And then you probably only want to enable it on your production environment.
* Have a look at [paragonie/csp-builder](https://github.com/paragonie/csp-builder) for configuring the Content-Security-Policy header. This is a dependency used by bepsvpt/laravel-security-header.
* [HTTP Public Key Pinning](https://scotthelme.co.uk/hpkp-http-public-key-pinning/) sounds a bit scary, mistakes are probably difficult to solve. I'm no expert in SSL keys or CSR so I haven't enabled this header.

## Step 2: Test your setup

Test your headers in your browser. You will have to tweak the CSP a bit, enable stuff like Google Analytics or widgets.

After that, scan your website at [securityheaders.io](https://securityheaders.io/), another project by Scott Helme. It will scan your headers and give some advice on stuff you can improve.

## Step 3: Configure a report URI

If a browser encounters content that is violating the Content Security Policy it can report this. The URI that is reported to can be configured in the CSP header itself.

A great (and free) service that you use for this is [report-uri.com](https://report-uri.com/). Again, this is made by Scott Helme, this is getting awkward... After setting up your personal report-uri you can see reports for content that violated your CSP. Below is the report for this website for last month:

{{< figure src="report-ui-report" >}}
