---
title: "Critical path CSS"
date: 2016-01-28T11:00:00+02:00
draft: false
summary: "Critical path CSS is the minimal amount of CSS that you need to render (part of) your website. By inlining this in the `<head>` of your website you can defer loading the rest of the CSS. This increases page speed and gives users a better experience."
types: ['tutorial']
subjects: ['seo', 'pagespeed']
params:
  outdated_warning: true
resources:
  - name: pagespeed-insights-after-critical-path-css
    src: 'pagespeed-insights-after-critical-path-css.png'
    title: "PageSpeed Insights' suggestions after Critical Path CSS"
    params:
      alt: "PageSpeed Insights' suggestions after Critical Path CSS"
---
Critical path CSS is the minimal amount of CSS that you need to render (part of) your website. By inlining this in the `<head>` of your website you can defer loading the rest of the CSS. This increases page speed and gives users a better experience.

## What is it?
When you visit a website your browser will first load all CSS files before it will start to render the page and it becomes visible to you. Until that time it just shows you a blank screen. This is done to avoid the [flash of unstyled content](https://en.wikipedia.org/wiki/Flash_of_unstyled_content) (FOUC).

But, most of the time you do not need the whole stylesheet (or all stylesheets) to render the content that is visible in your viewport. For example, the footer is probably not visible at the top of the page and styles concerning the footer are therefore not needed to render the page initially.

If you would discard any styles that do not contribute to rendering the initial view, you would end up with the critical path CSS. It would be fine for your browser to wait until these critical styles are loaded, as long as all other styles can be loaded and processed at a later moment.

## How to do it?
If you would like to quickly retrieve the critical path CSS of any website, you can look it up at [https://jonassebastianohlsson.com/criticalpathcssgenerator/](https://jonassebastianohlsson.com/criticalpathcssgenerator/).

Although this is very insightful, it is not feasible to do this manually every time we update our styles. Luckily for us, Addy Osmani has created a great NodeJS package that will do the work for you. And best of all: it can be easily integrated in your Gulp (or Grunt) workflow.

Check out the readme of [addyosmani/critical](https://github.com/addyosmani/critical) for installation and docs. It is fast enough to run it every time that I make changes to my SCSS files. And it allows you to run it on your local development website. This is how I integrated it into my setup:

```javascript
gulp.task('critical', function() {
    critical.generate({
        src: 'http://barryvanveen.app',
        css: 'public_html/dist/css/screen.css',
        width: 1280,
        height: 600,
        dest: 'public_html/dist/css/critical.css',
        minify: true
    });
});
```

After generating and inlining the contents of `critical.css` I used lazyload.js to load the full stylesheet after loading the page. Read the previous article on [lazyloading Javascript](/articles/19-lazyloading-javascript) to see how to do that.

## Pros and cons
Whether inlining your CSS is a good or a bad thing is still a subject of debate. Pros: It is quick and makes your pages render quickly for first time visitors. Cons: the CSS cannot be cached and the page is therefor slower for returning visitors. Also, because the CSS cannot be cached it cannot be served by a CDN, which might be a consideration.

Read [this post](https://medium.com/@drublic/a-counter-statement-putting-the-css-in-the-head-f98103d09ce1#.q7k6zn1lg) and [this other post](http://calendar.perfplanet.com/2011/why-inlining-everything-is-not-the-answer/) about the downsides of inlining CSS. Both are very much worth a read.

## PageSpeed grading
So, this is getting somewhat awkward. After following PageSpeed Insights' advice the resulting score is still the same as before. And it is beginning to show a pattern that I have already read about: it dislikes scripts build by Google ;-)

{{< figure src="pagespeed-insights-after-critical-path-css" >}}

Old scores: Mobile: 71/100. Desktop: 89/100.
New scores: Mobile: 71/100. Desktop: 89/100.

## Read these great articles
* [CSS and the critical path](http://www.phpied.com/css-and-the-critical-path/) notices that Facebook, Google and Bing do not use external stylesheets _at all_. Highly interesting read!
* [Nice presentation about optimizing theguardian.co.uk website using critical path CSS](https://speakerdeck.com/patrickhamann/css-and-the-critical-path).
* A good [introduction of critical CSS](https://www.smashingmagazine.com/2015/08/understanding-critical-css/) by Smashing Magazine.
