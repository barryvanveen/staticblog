---
title: "What I learned building a development environment in Docker"
date: 2022-05-16T21:00:00+02:00
draft: false
summary: "This article describes what I've learned building a new Docker-based development environment for this blog."
types: ['tutorial']
subjects: ['devops', 'tools', 'docker']
params:
  outdated_warning: true
---
Because I recently switched to working on an M1 Macbook, I could no longer rely on my Homestead-driven development environment. I have now switched to a newly created setup that runs on Docker instead.

My setup runs the following services:
- *Nginx* - webserver.
- *PHP* - to serve all PHP requests. Also contains NodeJS to compile css and javascript assets.
- *MySQL* - database server.
- *Redis* - for caching and session storage.
- *Maildev* - for testing emails locally.
- *Selenium* - for running Laravel Dusk browser tests.

You can take a look at my setup by looking at the [docker-compose.yml](https://github.com/barryvanveen/blog/blob/master/docker-compose.yml) file and the additional configuration in the [/docker](https://github.com/barryvanveen/blog/tree/master/docker) folder.

Below I want to highlight a couple of key things that I learned while building this new setup.

##  Split up configuration

The `docker-compose.yml` file tends to grow very big. Split it up by providing a [build definition](https://docs.docker.com/compose/compose-file/build/#build-definition) for each server.

## Multiple MySql databases

The default MySQL image only provides you an easy way to create a single database. In my case, I wanted to have 2 databases: one for the website and another one for running the acceptance tests.

To achieve this, create a shell script that you want to run when the image is build:
```sh
#!/bin/sh

CREATE DATABASE blog;
CREATE DATABASE blog_dusk;
GRANT ALL PRIVILEGES ON *.* TO 'blog'@'%';
```

Then add a volume to map your local provisioning script onto `/docker-entrypoint-initdb.d`:
```yml
mysql:
  container_name: mysql
  build: ./docker/mysql
  volumes:
    - ./docker/mysql/provisioning:/docker-entrypoint-initdb.d
```

More details can be found in the [MyQSL Docker image documentation](https://hub.docker.com/_/mysql/).

## Docker hostnames in .env

This might be trivial to some, but cost me some headaches. In your environment secrets, do not reference `localhost` but use the service names you configured.

So, in my case the database hostname is `mysql`, the Redis hostname is `redis` and the mail hostname is `maildev`.

## Selenium on ARM

Running the default Selenium Docker images on an M1 machine won't work. Use the [Selenium ARM-specific images](https://hub.docker.com/u/seleniarm) instead.

## Laravel Dusk environment configuration

First, make sure your `DuskTestCase` (the base test class) is up-to-date with the [stub from the Dusk repository](https://github.com/laravel/dusk/blob/6.x/stubs/DuskTestCase.stub).

In your Dusk environment configuration (`.env.dusk.local`), set `APP_URL='http://nginx'` and `DUSK_DRIVER_URL='http://selenium:4444/wd/hub`.

## Maildev instead of Mailhog

Homestead comes with Mailhog to locally test emails. It intercepts emails your Laravel application sends and presents them in a nice web interface.

However, Mailhog has not been updated for about 2 year now and there are a lot of open issues that indicate it is not maintained any longer.

As an alternative, I switched to using [Maildev](https://github.com/maildev/maildev). It works in much the same way and I'm very happy about it.