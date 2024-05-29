---
title: "Simple cache busting in Laravel"
date: 2016-01-16T18:00:00+02:00
draft: false
summary: "It is usually a good idea to cache your CSS and JS files as long as possible. This way you save requests and your website will load faster. But how do you make sure your visitors *will* download your new files when you made changes to them? Cache busting solves exactly this problem."
types: ['tutorial']
subjects: ['laravel', 'cache', 'seo', 'pagespeed']
params:
  outdated_warning: true
---

It is usually a good idea to cache your CSS and JS files as long as possible. This way you save requests and your website will load faster. But how do you make sure your visitors *will* download your new files when you made changes to them? Cache busting solves exactly this problem.

## What is cache busting?
Cache busting usually involves changing the file name of your assets when you make changes to them. This is done by computing a [file hash](http://php.net/manual/en/function.hash-file.php) on the source and incorporating that into the file name.

There are multiple ways of achieving this:
* Use Laravel packages like [TheMonkeys/laravel-cachebuster](https://github.com/TheMonkeys/laravel-cachebuster) or [spekkionu/laravel-assetcachebuster](https://github.com/spekkionu/laravel-assetcachebuster).
* Use gulp modules like [gulp-buster](https://www.npmjs.com/package/gulp-buster) or [gulp-cachebust](https://www.npmjs.com/package/gulp-cachebust).
* Append your apps version number as query string (e.g. ?v=1.2.3) to your assets.

I've tried a couple of these methods but I didn't like them.
* I only want to rely on Laravel packages if it is really necessary. Updating packages, and especially updating Laravel itself, can be a pain. So I decided to look for an alternative method.
* Using the gulp modules wasn't very intuitive and you still need a PHP-script to finish the job.
* Some people say that [query strings are unreliable for cache busting](http://www.stevesouders.com/blog/2008/08/23/revving-filenames-dont-use-querystring/). I'm not sure if that is still relevant but I'm not taking any chances.

So, I figured out a way to build this myself and it turns out to be quite simple.

## How to...
Use the next step to build your own cache busting system in Laravel:

### 1. create a [ViewComposer](https://laravel.com/docs/5.1/views#view-composers)
```php
<?php
namespace Barryvanveen\Composers;

use Cache;
use Illuminate\View\View;

class AssetComposer
{
    /** @var  View */
    protected $view;

    /** @var  array */
    protected $assets = [
        'dist/css/print.css'  => 'dist/css/print.css',
        'dist/css/screen.css' => 'dist/css/screen.css',
        'dist/js/main.ie8.js' => 'dist/js/main.ie8.js',
        'dist/js/main.js'     => 'dist/js/main.js',
    ];

    /**
     * @param View $view
     */
    public function compose($view)
    {
        $this->view = $view;

        if (env('APP_ENV') != 'production') {
            $this->view->with('assets', $this->assets);

            return;
        }

        if (Cache::has('assets')) {
            $this->view->with('assets', Cache::get('assets'));

            return;
        }

        $this->assets = $this->createFileHashes($this->assets);

        Cache::forever('assets', $this->assets);

        $this->view->with('assets', $this->assets);
    }

    /**
     * Create a short file hash for each asset.
     *
     * @param $assets
     */
    protected function createFileHashes($assets)
    {
        foreach ($assets as $key => $asset) {
            $path = public_path().'/'.$key;

            if (!file_exists($path)) {
                continue;
            }

            $hash = hash_file('crc32', $path);
            $dot  = strripos($asset, '.');

            $assets[$key] = substr($asset, 0, $dot + 1).$hash.substr($asset, $dot);
        }

        return $assets;
    }
}
```

So, we're basically creating an array of assets. Each index defines an asset and each value is the file name with incorporated hash. The end result looks something like this and can be used in your template:

```php
 protected $assets = [
     'dist/css/print.css'  => 'dist/css/print.217173cb.css',
     'dist/css/screen.css' => 'dist/css/screen.3ed0053f.css',
     'dist/js/main.ie8.js' => 'dist/js/main.ie8.63bb7a83.js',
     'dist/js/main.js'     => 'dist/js/main.4a02a537.js',
 ];
```

### 2. redirect files
Include the following in your .htaccess to redirect all requests to "hashed" file names to the original ones:
```shell
# Redirect assets with filehash in name to actual filename
RewriteRule ^dist/css/(.*)\.[0-9a-f]{8}\.css$ /dist/css/$1.css [L]
RewriteRule ^dist/js/(.*)\.[0-9a-f]{8}\.js$ /dist/js/$1.js [L]
```

### 3. set far-future cache-control en expire headers
Include the following in your .htaccess to cache your files for 1 year. Because you may or may not have all Apache modules installed it is best to encapsulate these statements in the IfModule directive. In my case I have to use mod_expires, which is slightly outdated but seems to be working fine.
```shell
<IfModule mod_headers.c>
    <FilesMatch \.(css|js)$>
        Header set Cache-Control "max-age=31536000"
 </FilesMatch>
</IfModule>

<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresDefault "access"
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
</IfModule>
```

### 4. clear your cache after deploying
Run `php artisan cache:clear` after [deploying your new code](/articles/3-je-laravel-website-deployen-met-1-commando).


## The result
I'm really happy with the results: it is simple, elegant and fast. And best of all: it works. My new PageSpeed scores are slightly better than before:

Mobile: 75/100. Desktop: 91/100.

On to the next challenge: critical path css.
