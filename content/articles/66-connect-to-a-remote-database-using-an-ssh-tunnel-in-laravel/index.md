---
title: "Connect to a remote database using an SSH tunnel in Laravel"
date: 2020-07-12T20:00:00+02:00
draft: false
summary: "If you need to connect to a database over an SSH tunnel, here is how to do that in Laravel. You need a new database connection and command to create the tunnel."
types: ['tutorial']
subjects: ['laravel', 'database', 'eloquent', 'ssh']
params:
  outdated_warning: false
---
I've been writing an artisan command to import data from a remote MySQL database. I can only connect to that database over an SSH connection using [an SSH key](/articles/53-ssh-keys-101). Here is an explanation of how to accomplish that.

## Start an SSH tunnel
To start a new SSH tunnel, run the following command:
```shell
ssh -i ./path/to/id_rsa \
    -N -L 13306:127.0.0.1:3306 \
    root@111.222.333.444
```

This SSH command was new to me, so I want to describe it in full detail. If you understand what is going on, just skip to [the database configuration](/articles/66-connect-to-a-remote-database-using-an-ssh-tunnel-in-laravel#database-configuration).

Let us break down what that command is doing.

**Remote server**
The last part (we'll get back to the first parts), `root@111.222.333.444`, is describing that want to connect to a server at `111.222.333.444` with the username `root`.

**Authentication**
The first part, `-i /path/to/id_rsa`, is describing how to authenticate to the remote server. In this case, we use an SSH key.

**Port forwarding**
The second part, `-N -L 13306:127.0.0.1:3306`, is setting up port forwarding. Let's break that down some more.

* `-N` describes we don't want to execute any remote commands, we just want the port forwarding.
* `-L` is the start of our port forwarding configuration.
* `13306` is the local port we want to forward.
* `127.0.0.1` is the remote host.
* `3306` is the remote port.

So, we're describing that whenever we connect locally to port `13306`, we want to forward these commands to `127.0.0.1:3306` *on our remote host*, which is `111.222.333.444`.

So, my remote MySQL database is running on `111.222.333.444`, but on that machine it is accessible on `127.0.0.1:3306` (aka localhost).

*Now, to actually start the SSH tunnel, execute this command and leave that console open. As soon as you stop this command, the SSH tunnel will be closed and you can no longer reach the external database.*

## Database configuration
Now that we have our SSH connection set up, let's see whether we can connect to that database. In `config/database.php` you can set up any database connections.

Add a new section to the `connections` array key like this:
```php
'remote_mysql' => [
    'driver' => 'mysql',
    'host' => env('REMOTE_DB_HOST', '127.0.0.1'),
    'port' => env('REMOTE_DB_PORT', '13306'),
    'database' => env('REMOTE_DB_DATABASE', 'forge'),
    'username' => env('REMOTE_DB_USERNAME', 'forge'),
    'password' => env('REMOTE_DB_PASSWORD', ''),
    // ... 
],
```

The thing to pay attention to is the port, this should match the local port we set up in our SSH command.

## Connecting to the remote database
Everything should be set up and we should be able to retrieve records from the remote database like this:

```php
$records = DB::connection('remote_mysql')
    ->table('blogs')
    ->get();
```