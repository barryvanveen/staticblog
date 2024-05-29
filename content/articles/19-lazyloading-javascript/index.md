---
title: "Lazyloading Javascript"
date: 2016-01-23T17:00:00+02:00
draft: false
summary: "To improve the speed of your website you can lazyload Javascript, CSS and images. This means that you first load all essential elements of the page and only after that you start loading any extras. Lazyloading Javascript is simple and was the first thing I did."
types: ['tutorial']
subjects: ['seo', 'pagespeed']
params:
  outdated_warning: true
---

To improve the speed of your website you can lazyload Javascript, CSS and images. This means that you first load all essential elements of the page and only after that you start loading any extras. Lazyloading Javascript is simple and was the first thing I did.

## Lazyload
You can lazyload Javascript files in many different ways. I set out looking for a simple method without too many features. After reading this [comparison between RequireJS and HeadJS](http://www.peterbe.com/plog/requirejs-vs-headjs) by Peter Bengtsson I realized this those scripts are to complex for my needs. That's why I settled with [lazyload](https://github.com/rgrove/lazyload/) by Ryan Grove. It is simple, clean and effective.

## Old situation
In the old situation I just loaded my minified Javascript just before closing the body tag. The file main.js was 70 KB and had to be fully loaded before the page could be displayed. This file also include a copy of jQuery that I use for various plugins.

## New situation
By using lazyload.js we can postpone loading our main Javascript file. I've inlined a minified version of lazyload.js (<1 KB) so that it doesn't need a request itself. When the page is loaded we require jQuery (38 KB, from CDN) and main.js (35 KB).

```javascript
<script type="text/javascript">
    LazyLoad=function(e){function t(t,n){var s,c=e.createElement(t);for(s in n)n.hasOwnProperty(s)&&c.setAttribute(s,n[s]);return c}function n(e){var t,n,s=i[e];s&&(t=s.callback,n=s.urls,n.shift(),u=0,n.length||(t&&t.call(s.context,s.obj),i[e]=null,f[e].length&&c(e)))}function s(){var t=navigator.userAgent;o={async:e.createElement("script").async===!0},(o.webkit=/AppleWebKit\//.test(t))||(o.ie=/MSIE|Trident/.test(t))||(o.opera=/Opera/.test(t))||(o.gecko=/Gecko\//.test(t))||(o.unknown=!0)}function c(c,u,h,g,d){var y,p,b,k,m,v,j=function(){n(c)},w="css"===c,T=[];if(o||s(),u)if(u="string"==typeof u?[u]:u.concat(),w||o.async||o.gecko||o.opera)f[c].push({urls:u,callback:h,obj:g,context:d});else for(y=0,p=u.length;p>y;++y)f[c].push({urls:[u[y]],callback:y===p-1?h:null,obj:g,context:d});if(!i[c]&&(k=i[c]=f[c].shift())){for(l||(l=e.head||e.getElementsByTagName("head")[0]),m=k.urls.concat(),y=0,p=m.length;p>y;++y)v=m[y],w?b=o.gecko?t("style"):t("link",{href:v,rel:"stylesheet"}):(b=t("script",{src:v}),b.async=!1),b.className="lazyload",b.setAttribute("charset","utf-8"),o.ie&&!w&&"onreadystatechange"in b&&!("draggable"in b)?b.onreadystatechange=function(){/loaded|complete/.test(b.readyState)&&(b.onreadystatechange=null,j())}:w&&(o.gecko||o.webkit)?o.webkit?(k.urls[y]=b.href,r()):(b.innerHTML='@import "'+v+'";',a(b)):b.onload=b.onerror=j,T.push(b);for(y=0,p=T.length;p>y;++y)l.appendChild(T[y])}}function a(e){var t;try{t=!!e.sheet.cssRules}catch(s){return u+=1,void(200>u?setTimeout(function(){a(e)},50):t&&n("css"))}n("css")}function r(){var e,t=i.css;if(t){for(e=h.length;--e>=0;)if(h[e].href===t.urls[0]){n("css");break}u+=1,t&&(200>u?setTimeout(r,50):n("css"))}}var o,l,i={},u=0,f={css:[],js:[]},h=e.styleSheets;return{css:function(e,t,n,s){c("css",e,t,n,s)},js:function(e,t,n,s){c("js",e,t,n,s)}}}(this.document);

    var lazyloadCallback = function() {
        LazyLoad.js([
            'http://code.jquery.com/jquery-1.11.2.min.js',
            'http://barryvanveen.nl/dist/js/main.6ca12112.js'
        ]);
    };
    window.addEventListener('load', lazyloadCallback);
</script>
```

By doing this we have saved a request for the initial page load. We have also saved 70 KB from that request, which is the biggest part of the page.

For some reason though, PageSpeed Insights doesn't really care and decides to lower the scores. I'm not sure why that is because I am pretty sure this is a better setup than before.

Old scores: Mobile: 75/100. Desktop: 91/100.
New scores: Mobile: 71/100. Desktop: 89/100.

## Further reading
* [Lazy Loading Asynchronis Javascript](https://friendlybit.com/js/lazy-loading-asyncronous-javascript/)
* [Painless JavaScript lazy loading with LazyLoad](http://wonko.com/post/painless_javascript_lazy_loading_with_lazyload)
* [Lazyload repository at GitHub](https://github.com/rgrove/lazyload/)
