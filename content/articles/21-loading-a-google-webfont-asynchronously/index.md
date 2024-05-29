---
title: "Loading a (Google) webfont asynchronously"
date: 2016-02-05T17:00:00+02:00
draft: false
summary: "Just like stylesheets and Javascript files, requesting a webfont can be postponed or done asynchronously. Doing so will make your pages render more quickly, especially on browsers with a slower internet connection."
types: ['tutorial']
subjects: ['seo', 'pagespeed']
params:
  outdated_warning: true
---

Just like stylesheets and Javascript files, requesting a webfont can be postponed or done asynchronously. Doing so will make your pages render more quickly, especially on browsers with a slower internet connection.

## Asynchronous loading with Web Font Loader
Loading your webfont asynchronously can be done with the [Typekit webfontloader](https://github.com/typekit/webfontloader) which was developed by Typekit and Google. Doing so is pretty easy. Just remove the `@import` statement from your CSS and include some Javascript in your template.

```javascript
<script type="text/javascript">
    WebFontConfig = {
        google: { families: [ 'Raleway:400,700:latin' ] }
    };
    (function() {
        var wf = document.createElement('script');
        wf.src = ('https:' == document.location.protocol ? 'https' : 'http') + '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
        wf.type = 'text/javascript';
        wf.async = 'true';
        var s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(wf, s);
    })();
</script>
```

## Speed boost
The beauty of asynchronously loading these fonts is that your browser can render the page before your Raleway webfont is fully loaded. First it displays the page with a fallback font, in this case something like Helvetica or Arial. This dramatically reduces the time that it takes to render the first elements on your website. This increases the (perceived) speed of your website.

## Flash...
So, while your webfont is not loaded the browser will display the fallback font. When the webfont is loaded all texts that use this font will be updated and redrawn. This leads to a visible flash. Texts are shown a little different, possibly with somewhat different spacing and line heights.

There are different ways of dealing with this. [Some people](http://webdesign.tutsplus.com/articles/quick-tip-avoid-fout-by-adding-a-web-font-preloader--webdesign-8287) apply IMO ridiculous strategies to avoid this behavior. The reason for doing this is not to make the website good-looking, it is meant to make it as fast as possible.

If you don't want this little flash just don't load your fonts asynchronously, stick with the `@import` statement in your CSS. And remember, browsers will cache the font at the first request, so there will be no more flashes on subsequent pages.

## PageSpeed Insights
Old scores: Mobile: 71/100. Desktop: 89/100.
New scores: Mobile: 98/100. Desktop: 99/100.

Apparently Google makes a very big deal out of this :) The last thing I could improve on is making analytics.js cacheable for a longer period. Google is serving it with a 2-hour expiration header. It's true that this is quite short, but since so many websites use Google Analytics I think it will be in the browser cache already...

## Continue reading
* [Web Fonts Performance](https://www.igvita.com/2012/09/12/web-fonts-performance-making-pretty-fast/) by Ilya Grigorik.
* [How to use web fonts responsibly](https://www.filamentgroup.com/lab/font-loading.html)
