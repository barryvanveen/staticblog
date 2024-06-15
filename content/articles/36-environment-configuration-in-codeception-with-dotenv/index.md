---
title: "Environment configuration in Codeception with dotenv"
date: 2017-02-05T12:00:00+02:00
draft: false
summary: "Codeception is normally configured using the codeception.yml file. We can also use a dotenv configuration file to store any sensitive data. This posts shows you how."
types: ['tutorial']
subjects: ['testing', 'configuration', 'tools', 'codeception']
params:
  outdated_warning: true
---
Codeception is configurated using the codeception.yml file. But, you don't want to store any credentials in this file. You can use a dotenv configuration file to store these data (for example database credentials) and use them in our code and codeception.yml file.

## Background
Head over to the [phpdotenv repository](https://github.com/vlucas/phpdotenv) to learn more about dotenv configuration and why you should use it.

## Set up .env
First, create a `.env.example` file in the root of your repository. Fill it with all the names of variables that you need, but do not fill in the actual data:

```shell
DB_HOST=
DB_PORT=
DB_DATABASE=
DB_USERNAME=
DB_PASSWORD=
```

Then, copy `.env.example` to `.env` and set all the variables to their correct values:

```shell
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=myproject
DB_USERNAME=homestead
DB_PASSWORD=secret
```

Add the example file to Git. Add .env to your .gitignore list, never add it to your repository.

## Configure Codeception
This is the `codeception.yml` that I've used for a recent project:

```yml
actor: Tester
paths:
    tests: tests
    log: tests/_output
    data: tests/_data
    support: tests/_support
    envs: tests/_envs
settings:
    bootstrap: _bootstrap.php
    colors: true
    memory_limit: 1024M
extensions:
    enabled:
        - Codeception\Extension\RunFailed
modules:
    config:
        Db:
            dsn: "mysql:host=%DB_HOST%:%DB_PORT%;dbname=%DB_DATABASE%"
            user: "%DB_USERNAME%"
            password: "%DB_PASSWORD%"
params:
    - .env
```

As you can see the last line instructs Codeception to load the .env file and read all variables that it contains.

You can use these variables in your configuration like you see in the database configuration parts. `%DB_HOST%` with be replaced with the value of `DB_HOST` from `.env`.

## Using variables in your code
All variables will be assigned to the global `$_ENV` variable. So, in your PHP code, you can read from `$_ENV['DB_HOST']` to retrieve the same value as before.