---
title: "A new and improved blog"
date: 2022-01-14T16:30:00+02:00
draft: false
summary: "After almost 2 years of (non)development, this blog finally received a big overhaul. Let's go over the biggest changes in this new version."
types: ['project']
subjects: ['blog', 'opensource']
params:
  outdated_warning: false
---
The previous version of this blog was getting increasingly hard to maintain. Because of this it was getting outdated very fast, to the point where I did not dare to deploy any new changes.

So, instead of fixing the problem, I decided to build a new blog from scratch.

## Goals

This new version would be better than ever.

It should be:
* [Easy to maintain](/articles/57-a-new-and-improved-blog#easy-to-maintain).
* [Fast](/articles/57-a-new-and-improved-blog#fast).
* [Privacy friendly](/articles/57-a-new-and-improved-blog#privacy-friendly).

So how were these goals accomplished? I'll give a brief outline, but will give more details in upcoming articles.

### Easy to maintain

Cutting back on the number of dependencies is the main strategy in making this project easier to maintain. Fewer dependencies means fewer updates, fewer breaking changes and thus less work.

Decoupling from Laravel Framework has been another strategy.  By using a layered architecture it is now more clear what code is "application code" and what is "framework code". When the next big update of Laravel comes around, it should be way easier to update the now isolated pieces of framework-related code.

### Fast

This blog is fast because of 2 reasons:

1. It is small in size. The homepage and all its assets currently total just under 17kB. This is as 94% reduction compared to the previous 312 kB.
2. All HTML output is cached. When the content of an article is updated, or a comment is posted, this cache is automatically invalidated.

### Privacy friendly

No more tracking. No more Google Tag Manager, Google Analytics or Google Fonts.

If I don't want to be tracked while browsing, then I should not do the same to visitors of my own websites.

Funny enough this helps in maintainability, reduces asset size and made it possible to use a stricter [Content Security Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy).

## Continue reading
* Check out the [source code on Github](https://github.com/barryvanveen/blog).