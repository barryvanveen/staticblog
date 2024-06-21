---
title: "Configure PurgeCss to not remove certain styles"
date: 2021-04-26T17:50:00+02:00
draft: false
summary: "Today I learned about 2 easy ways to instruct PurgeCSS to *not* remove certain styles: safelists and comments."
types: ['tutorial']
subjects: ['frontend', 'purgecss', 'performance']
params:
  outdated_warning: true
---
If you have used PurgeCSS before, you know it is really good at removing unused css styles. This is great, but you immediately start running into another problem: it removes styles that you *DO* need.

This project I'm working on contains some dynamic styles. You write markdown in the backend and that gets converted into html. Throw in some syntax highlighting and suddenly you have all these styles that you do need but are not actually in any template.

My first hacky solution was creating a template file that just contained these "dynamic" elements so that PurgeCSS would pick them up and not remove it from the stylesheet. It is a very simple solution that worked so far, but I had to keep making sure all my essential styling was kept.

Today I properly read the [PurgeCSS docs](https://purgecss.com/) and discovered 2 easy solutions that I want to share with you.

## PurgeCSS safelist

When I added some syntax highlighting to the project [using highlight.js](https://highlightjs.org/) I also added a safelist configuration to the PurgeCSS Webpack plugin I use:

```js
new PurgecssPlugin({
    paths: ...,
    defaultExtractor: ...,
    safelist: {
        deep: [/hljs-/],
    }
}),
```

This will basically keep all css selectors that contain `hljs-`, which is exactly what I need.

Read the [docs on PurgeCSS safelist configurations](https://purgecss.com/safelisting.html) for more options.

## CSS comments

Another way to indicate that styles should be kept is by placing some specific css comments. In my case, I have only a single file with some customers styles.

That file now contains 2 comments:
```css
/*! purgecss start ignore */
    // customer styles go here
/*! purgecss end ignore */
```

The docs also contains ways of [safelisting a single rule](https://purgecss.com/safelisting.html#in-the-css-directly).

These are two very nice solutions and more maintainable solutions. Hope it helps you in your project too!
