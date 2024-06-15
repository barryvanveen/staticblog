---
title: "How to prevent the use of unsafe-inline in CSP"
date: 2018-05-18T22:00:00+02:00
draft: false
summary: 'It is best to prevent the usage of "unsafe-inline" in your Content Security Policy (CSP) header. In this article, I will explain why that is the case and how to transform unsafe assets into safe ones.'
types: ['tutorial']
subjects: ['security', 'configuration']
params:
  outdated_warning: false
---
It is best to prevent the usage of "unsafe-inline" in your Content Security Policy (CSP) header. In this article, I will explain why that is the case and how to transform unsafe assets into safe ones.

## CSP primer
First of all, *any* content security policy is better than no policy at all. So if you don't know what CSP is, or if you don't use it in your projects, it is time to read up:

* On [content-security-policy.com](https://content-security-policy.com/) you can find an overview of CSP directives.
* Scott Helme has written a [great introduction](https://scotthelme.co.uk/content-security-policy-an-introduction/) and a handy [cheatsheet](https://scotthelme.co.uk/csp-cheat-sheet/).
* For the real fanatics, read the [CSP3 draft](https://www.w3.org/TR/CSP3/).

## Why is unsafe-inline dangerous?

It is not uncommon to allow 'unsafe-inline' in a CSP policy. In fact, it was part of this blog's policy until earlier this day.

So, why is this a bad thing?

The beauty of the CSP header is that it can protect websites against cross-site scripting (XSS). When properly configured, [modern browsers](https://caniuse.com/#search=content%20security%20policy) will block any script or style that is not explicitly whitelisted.

The use of 'unsafe-inline' basically allows unknown scripts and styles to be executed and thereby weakens the whole system.

## Cross-site scripting vulnerability

Suppose an attacker has found a way to store HTML code on your website. This means the attacker can now place `<script>`, `<style>` and other HTML content.

A basic CSP header will protect against the most critical attacks. The attacker can not make an ajax request to his own server because the domain will not be whitelisted. The same holds for loading images or framing content. This is why it is important to **never whitelist "https://"** but always list all domains you need.

But, the attacker can still alter the behavior of the page by executing an inline script. Or he can completely change the looks of the page by inlining styles.

This is what we can prevent by not allowing 'unsafe-inline'.

Luckily, there are still ways to use inline scripts and styles on a page. We just have to "convert" them van unsafe to safe by using "nonces" or "hashes".

## Using nonces to make inline content safe

A nonce is a random string that is unique for each request. It is part included in the CSP header like so:

```
script-src: 'nonce-a9d09b55f2b66e00f4d27f8b453003e6';
style-src: 'nonce-a9d09b55f2b66e00f4d27f8b453003e6';
```

We can now create safe inlined content like this:

```html
<script nonce="a9d09b55f2b66e00f4d27f8b453003e6">...</script>
<style nonce="a9d09b55f2b66e00f4d27f8b453003e6">...</style>
```

## Using hashes to make inline content safe

The other way to whitelist inline content is by computing a hash of the content and providing that in the CSP header.

Use PHP to compute the hash of the content like so:
```php
base64_encode(hash("sha256", "this-is-the-content", true));
```

Then include the hash in the policy like so:

```
script-src: 'sha256-cBbpOAakpiPtmHk5QmIjJYt5WwYh3a1a0P1LpPh1AjQ=';
style-src: 'sha256-cBbpOAakpiPtmHk5QmIjJYt5WwYh3a1a0P1LpPh1AjQ=';
```
Make sure you hash the exact content of your script or styles tag, including any spaces or newlines. You can include as many hashes as you want.

## Caveats

Although above methods are pretty simple in theory, I've found it to be hard to implement them. Some problems I've come upon in recent projects:

* [Laravel debugbar](https://github.com/barryvdh/laravel-debugbar) injects its content into the response body automatically. The content is unique for each request and creates an inline style tag on its own.
* Many services that you have to embed (for example AddThis widgets) try to create inline tags.
* I wasn't able to get this working in combination with a Vue app.

My best advice would be to start every project with a very strict policy. It is much harder to apply this to existing projects than to new ones.

Once inline content is blocked, you can try to whitelist it with the above methods. If this doesn't work you basically have 2 options: remove the content or choose to allow unsafe-inline content.