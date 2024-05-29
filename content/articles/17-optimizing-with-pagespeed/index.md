---
title: "Optimizing with PageSpeed"
date: 2016-01-11T22:00:00+02:00
draft: false
summary: "Optimizing the speed of your websites is interesting from multiple viewpoints. First and foremost it's good for your visitors: nobody likes waiting. That's probably why Google has incorporated the speed of a website in its ranking algorithm. And to give developers an extra hand they have developed Google Pagespeed: a tool that shows you how you can improve the performance of your website."
types: ['tutorial']
subjects: ['pagespeed', 'seo']
params:
  outdated_warning: true
---

Optimizing the speed of your websites is interesting from multiple viewpoints. First and foremost it's good for your visitors: nobody likes waiting. That's probably why Google has incorporated the speed of a website in its ranking algorithm. And to give developers an extra hand they have developed [Google Pagespeed](https://developers.google.com/speed/pagespeed/insights/): a tool that shows you how you can improve the performance of your website.

## Current score: pretty good
At the moment this website scores [70/100 for the mobile website](https://developers.google.com/speed/pagespeed/insights/?url=http%3A%2F%2Fbarryvanveen.nl&tab=mobile) and [88/100 on desktop](https://developers.google.com/speed/pagespeed/insights/?url=http%3A%2F%2Fbarryvanveen.nl&tab=desktop). Pretty good, but this is just a small blog so it should be doable to achieve near-perfect scores.

## Possible improvements
Pagespeed has a few suggestions to improve the speed of my website. In order of increasing difficulty these are:

1. **Minimize CSS.**
   Not sure why this is not yet fixed, normally this is part of my default Gulp process. I used [gulp-sass](https://www.npmjs.com/package/gulp-sass) which has an optional configuration that will make it output minified css with `{outputStyle: 'compressed'}`.
   *Actually, this only "compresses" the output. So, use [gulp-cssnano](https://github.com/ben-eb/gulp-cssnano) to really minify your css.*
2. **Leverage browser caching.**
   At the moment I don't use any `Cache Control`-headers. These headers tell browsers how long the requested objects (stylesheets, javascript files, images) can be cached.
3. **Eliminate render-blocking JavaScript and CSS in above-the-fold content.**
   By minimizing any blocking CSS resources your pages can be rendered more quickly.

So, I'm gonna fix these issues and try to achieve the maximum scores. Next post will be about [cachebusting](http://curtistimson.co.uk/front-end-dev/what-is-cache-busting/) and the new PageSpeed verdict...

## Read some more
* [Google PageSpeed Tools on Wikepedia](https://en.wikipedia.org/wiki/Google_PageSpeed_Tools).
* [The Biggest Misconception About google PageSpeed](https://www.catchpoint.com/blog/google-pagespeed).
* [Use Google PageSpeed Insights to analyze your Web page performance](http://www.techrepublic.com/blog/google-in-the-enterprise/use-google-pagespeed-insights-to-analyze-your-web-page-performance/).
* Dutch: [Zin en onzin van Google PageSpeed](https://mediaweb.nl/blog/zin-en-onzin-van-google-pagespeed/).


