---
title: "Use an SSL certificate"
date: 2016-02-12T17:00:00+02:00
draft: false
summary: "Using an SSL certificate is quickly becoming a best practice, if it isn't already. What do you need to know before choosing a certificate and what do you need to check after installing it?"
types: ['tutorial']
subjects: ['ssl', 'security']
params:
  outdated_warning: true
---

Using an SSL certificate is quickly becoming a best practice, if it isn't already. What do you need to know before choosing a certificate and what do you need to check after installing it?

## Why do I need a certificate?
There is a whole range of arguments to be made in favor of using an SSL certificate. For example, this blog at Snyk.io lists [10 of those reasons](https://snyk.io/blog/10-reasons-to-use-https/).

For me personally a couple of reasons stand out:

1. It is necessary to protect the data that users can post to your website. At this time that is only me logging into the admin panel. But still, I want to protect my account credentials.
2. It is future proof. Many more websites will adopt certificates and before too long you will be lagging behind. Best to stay up-t0-date with the rest.
3. Google now accounts for the availability of an SSL certificate in its ranking algorithm. So, with an SSL certificate your website will rank higher than without.

## Things to keep in mind
When you go and buy a certificate you will be presented with different options. Depending on your hosting provider or the certificate supplier these options may vary.

**Duration**
Certificates can have different durations, mostly 1, 2 or 3 years. You pay up front and longer durations are relatively cheaper. I've chosen a certificate for 3 years but there might be a downside: you cannot be sure that this certificate will meet the standards that are needed in 2 years time.

**Server Name Indication**
[Server Name Indication](https://en.wikipedia.org/wiki/Server_Name_Indication) (SNI) is a relatively new method with which you can use an SSL certificate without the need for a unique IP address. This method can save you the costs of this extra IP address but not all clients [support SNI certificates](http://caniuse.com/#feat=sni).

Specifically clients running Windows XP in combination with IE8 or lower will not be able to connect properly. IE might display a warning or might not work at all. Frankly, I don't care since these people should have updated long ago and are probably not visiting this website :)

## SSL Check
After you install the certificate be sure to do a quick [SSL test at SSLlabs.com](https://www.ssllabs.com/ssltest/). It is very thorough and will let you know of any server (mis)configurations that you might not know of.

In my case multiple things could be fixed or improved:
* [SSL3 was still enabled](https://blog.qualys.com/ssllabs/2014/10/15/ssl-3-is-dead-killed-by-the-poodle-attack)
* [RC4 ciphers were enabled](https://blog.qualys.com/ssllabs/2013/03/19/rc4-in-tls-is-broken-now-what)
* [Forward Secrecy could be improved](https://blog.qualys.com/ssllabs/2013/06/25/ssl-labs-deploying-forward-secrecy)

If, like me, you don't have a clue what that means or how to solve it, just contact your hosting provider and they can probably solve it for you. My hosting provider could solve all issues and the certificate now has a A rating instead of a C.

## Redirects
Now that everything works like it should, it is time to redirect all visitors to the HTTPS-encrypted version of the website. I've chosen to fix this in my `.htaccess` file like so:

```text
RewriteEngine On

RewriteCond %{HTTP_HOST} ^barryvanveen.nl$ [NC]
RewriteCond %{HTTPS} !=on [NC]
RewriteRule ^(.*)$ https://barryvanveen.nl/$1 [R=301,L]
```

So, from now on this website is served over an encrypted connection. Hopefully you haven't noticed any changes except for a shiny lock-symbol in your address bar!