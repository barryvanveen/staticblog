---
title: "Connect to MSSQL database from PHP"
date: 2017-08-21T23:30:00+02:00
draft: false
summary: "Lately, I've been working on a project that has to read data from an MSSQL database. This is the setup that we used to connect to the database and solve any encoding issues."
types: ['tutorial']
subjects: ['database', 'laravel', 'configuration', 'mssql']
params:
  outdated_warning: true
---
Last couple of months I've been working on a project that relies heavily on a Microsoft SQL (or mssql) database. It is the source of a legacy system that we are currently replacing. Connecting to the database and solving all encoding issues has been quite a pain, but now it is working and I retraced my steps to write down how we managed to get things working. Turns out it's not that difficult after all!

## Install FreeTDS driver
Start by installing the [FreeTDS](http://www.freetds.org/) database driver with the following commands:

```bash
sudo apt-get update
sudo apt-get install freetds-common freetds-bin php-sybase
```

## FreeTDS configuration
The FreeTDS configuration file can be found at `/etc/freetds/freetds.conf`. Make a backup of that file before you make any changes.

In the configuration file we can either change the global settings or add a server-specific configuration. I would suggest you choose the latter because it the most versatile approach.

Add a new configuration to the end of file:
```bash
[myhostname]
    host = myhostname.com
    port = 1433
    tds version = 7.1
    client charset = UTF-8
```

Naturally, you must change the hostname and port number. We will choose the correct tds version in a moment. You can read more about the TDS configuration file in the [TDS userguide](http://www.freetds.org/userguide/freetdsconf.htm).

## Making the database connection
Using plain PHP we can set up a database connection using:
```php
$db = new PDO('dblib:host=myhostname;dbname=mydbname', $username, $password);
```

In Laravel we can specify the "sqlsrv" driver in `/config/database.php`.
```php
'mssql' => [
    'driver' => 'sqlsrv',
    'host' => 'myhostname',
    'port' => '1433',
    'database' => 'mydbname',
    'username' => 'username',
    'password' => 'password',
    'charset' => 'utf8',
    'collation' => 'utf8_unicode_ci',
    'prefix' => '',
    'strict' => false,
    'engine' => null,
],
```
If you use Laravel, make sure that you use this newly created "mssql" connection.

## Choosing the correct TDS version
In order to get the connection working correctly, it is important to choose the correct TDS version. There are [7 different versions](http://www.freetds.org/userguide/choosingtdsprotocol.htm) and each one is written for a version of Microsoft SQL Server.

You can find the version number of SQL Server by running the following query:
```sql
SELECT @@VERSION AS 'SQL Server Version';  
```

Even though our SQL Server was running version 2008, we still choose to use TDS version 7.1 instead of 7.3 because it was better at encoding/decoding data.

So, test some different versions and fetch some records from the database. Try to retrieve some records with accented characters, because these are most error-prone. Our target database contains Russian, Thai and Vietnamese texts, which are retrieved as "????" if you choose the incorrect TDS versions.

Some TDS versions will fail to connect entirely, others will produce mediocre results. Just keep trying till you find the correct one, there are only 7 options.

## Solving encoding issues
In my search to solve the initial encoding options I have tried many things. Setting the mssql charset using `ini_set()`, encoding with `utf8_encode()` and even this ugly mess:
```php
mb_detect_encoding($value, mb_detect_order(), true) === 'UTF-8') 
            ? $value : iconv('iso-8859-1', 'utf-8', $value)
```

When I went back to the code for this blog post I had to find out what settings are needed to get everything right. And you know what? FreeTDS can do it all for you, you just need to configure it correctly. That's it!

*Our project runs on Ubuntu 16.04, Apache and PHP 7.0.*