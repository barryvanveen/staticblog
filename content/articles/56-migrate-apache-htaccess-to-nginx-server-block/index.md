---
title: "Migrate Apache .htaccess to NGINX server block"
date: 2019-02-06T19:00:00+02:00
draft: false
summary: "I've migrated my blog from Apache to NGINX. In the process, the .htaccess file was converted into an NGINX Server Block. This article shows both files and serves as an example for others that want to migrate."
types: ['tutorial']
subjects: ['devops', 'configuration', 'apache', 'nginx']
params:
  outdated_warning: true
---
At the end of last year, this blog was migrated to a new server, hosted by DigitalOcean. The old server ran on Apache but on the new server I wanted to try out the [LEMP One-click application](https://www.digitalocean.com/docs/one-clicks/lemp/).

LEMP stands for Linux, NGINX (say: en-juhn-ex), MySQL, PHP. The old server ran on Apache, so some things needed to be migrated from Apache to Nginx.

## Differences between Apache and NGINX
The biggest difference between Apache and NGINX (for me) is the fact that Apache can be configured using .htaccess files and NGINX can't. That means that any logic contained in the .htaccess file(s) must be migrated to the NGINX Server Block. A server block is the NGINX equivalent of Apache's Virtual Host.

If you want to learn more, read this excellent article about [the differences between Apache and Nginx](https://www.digitalocean.com/community/tutorials/apache-vs-nginx-practical-considerations).

## The old .htaccess file
So, let's have a look at the old annotated .htaccess file. There was only one file, which was located in the `public_html` directory.

```bash
<IfModule mod_rewrite.c>
    <IfModule mod_negotiation.c>
        Options -MultiViews
    </IfModule>

    # set Expire and Cache Control headers for css and js
    <IfModule mod_expires.c>
        ExpiresActive On
        ExpiresDefault "access"
        ExpiresByType text/css "access plus 1 year"
        ExpiresByType application/javascript "access plus 1 year"

        ExpiresByType font/truetype "access plus 1 year"
        ExpiresByType font/opentype "access plus 1 year"
        ExpiresByType application/x-font-woff "access plus 1 year"
        ExpiresByType image/svg+xml "access plus 1 year"
        ExpiresByType application/vnd.ms-fontobject "access plus 1 year"
        ExpiresByType image/vnd.microsoft.icon "access plus 1 month"
    </IfModule>

    RewriteEngine On

    # Redirect to preferred domain
    RewriteCond %{HTTP_HOST} !(^barryvanveen\.test|^barryvanveen\.nl)$ [NC]
    RewriteRule ^(.*)$ https://barryvanveen.nl/$1 [R=301,L]

    # Redirect old Dutch urls to English urls
    RewriteRule ^over-mij$ https://barryvanveen.nl/about-me [L,R=301]
    RewriteRule ^over-mij/boeken-die-ik-heb-gelezen$ https://barryvanveen.nl/about-me/books-that-i-have-read [L,R=301]

    # Redirect to HTTPS domain
    RewriteCond %{HTTP_HOST} ^barryvanveen.nl$ [NC]
    RewriteCond %{HTTPS} !=on [NC]
    RewriteRule ^(.*)$ https://barryvanveen.nl/$1 [R=301,L]

    # Redirect assets with filehash in name to actual filename
    RewriteRule ^dist/css/(.*)\.[0-9a-f]{8}\.css$ /dist/css/$1.css [L]
    RewriteRule ^dist/js/(.*)\.[0-9a-f]{8}\.js$ /dist/js/$1.js [L]

    # Remove trailing slashes if not a folder
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_URI} (.+)/$
    RewriteRule ^ %1 [L,R=301]

    # Handle request using index.php
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^ index.php [L]
</IfModule>
```

## The equivalent NGINX Server Block

And here is the NGINX Server Block that accomplices the same thing.

```bash
# map content types to expire times
map $sent_http_content_type $expires {
    default                 off;
    text/css                max;
    application/font-woff   max;
    application/javascript  max;
    ~image/                 7d;
}

# redirect http to https
server {
    listen 80;
    listen [::]:80;

    server_name barryvanveen.nl;
    server_name www.barryvanveen.nl;

    return 301 https://barryvanveen.nl$request_uri;
}

# redirect https to domain without www.
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name www.barryvanveen.nl;

    return 301 https://barryvanveen.nl$request_uri;

    ssl_certificate /path/to/certificate.pem; # managed by Certbot
    ssl_certificate_key /path/to/private/key.pem; # managed by Certbot
}

# serve website over https
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name barryvanveen.nl;

    root /var/www/barryvanveen_nl/public_html;

    index index.php index.html index.htm index.nginx-debian.html;

    # serve website using index.php
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    # redirect old Dutch urls to English urls
    location = /over-mij {
        return 301 /about-me;
    }

    location = /over-mij/boeken-die-ik-heb-gelezen {
        return 301 /about-me/books-that-i-have-read;
    }

    # tell NGINX how to serve PHP files
    location ~ \.php$ {
        try_files $uri /index.php =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $request_filename;
        include fastcgi_params;
    }

    # redirect assets with filehash in name to actual filename
    location ~ ^/dist/ {
        rewrite "^/dist/css/(.*)\.[0-9a-f]{8}\.css$" /dist/css/$1.css last;
        rewrite "^/dist/js/(.*)\.[0-9a-f]{8}\.js$" /dist/js/$1.js last;
    }

    # serve expires header
    expires $expires;

    ssl_certificate /path/to/certificate.pem; # managed by Certbot
    ssl_certificate_key /path/to/private/key.pem; # managed by Certbot
}
```

## Differences

Let's point out some differences that stood out for me:
* The NGINX Server Block contains all .htaccess logic but also the logic that was in the Apache Virtual Host. This explains why the `server`, `server_name` and `root` directives (among others) are necessary.
* There are three `server` directives: 1 that redirect non-https traffic, 1 that redirects traffic to the www-domain, and the last 1 that actually serves the website.
* The order of the `server` and `location` directives influences how requests are handled. See below for a link that explains how NGINX selects the server and location that will handle a request.
* The content types for the Expire headers have changed. This might not be due to NGINX, it is worth watching out for this if you are migrating a website.

## Learn more about NGINX

One of the strong points of NGINX is that it is very opinionated. This means the docs are very clear about good and bad configurations. Please read the following links carefully if you plan a migration yourself.

* Docs for [core NGINX directives](https://nginx.org/en/docs/http/ngx_http_core_module.html). Check out `server`, `location` and `try_files`.
* Docs for [rewrite NGINX directives](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html). Check out `return` and `rewrite`.
* An explanation of [how NGINX picks the `server` and `location` for each request](https://www.digitalocean.com/community/tutorials/understanding-nginx-server-and-location-block-selection-algorithms).
* Read about [pitfalls and common mistakes](https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/).
* [Why the NGINX `If` directive is evil](https://www.nginx.com/resources/wiki/start/topics/depth/ifisevil/).