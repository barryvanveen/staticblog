---
title: "SSH keys 101"
date: 2019-01-04T19:00:00+02:00
draft: false
summary: "SSH keys can be used to create secure connections between computers. This article explains the basics of creating and using SSH keys."
types: ['tutorial']
subjects: ['ssh']
params:
  outdated_warning: false
---
SSH keys can be used to create a secure connection to a remote computer. In other words, they are an alternative to logging in using a password.

Keys come in pairs: a private key and a public key. The public key is meant to be shared, the private key should never be shared, obviously.

The steps for setting up SSH keys for authentication are simple:
1. [Find an existing SSH key pair](/articles/53-ssh-keys-101#find-an-existing-ssh-key) or [create a new one](articles/53-ssh-keys-101#create-a-new-ssh-key).
2. [Add the public key to the remote computer](articles/53-ssh-keys-101#add-an-ssh-key-to-a-remote-machine).
3. [Connect to the remote machine](articles/53-ssh-keys-101#connect-to-the-remote-machine).

The rest of this article lists various methods of achieving these steps.

{{< divider >}}

*All following commands use username `barry` and IP address `123.123.123.123`. Naturally, these should be replaced by your own username and the IP address or hostname of your choice.*

{{< divider >}}

## Find an existing SSH key
Keys are generally stored in the `.ssh` folder in your home directory (on your local machine!) For me that would be `/home/barry/.ssh`.

If that folder contains the files `id_rsa` and `id_rsa.pub` you already have an existing key pair. Of these, `id_rsa` is the private key and `id_rsa.pub` is the public key.

## Create a new SSH key
In case you don't have an existing SSH key pair, or if you want to overwrite these, run the following command:

```bash
$ ssh-keygen -t rsa
```

The command will ask you some questions:
* **At what location do you want to save the keys?** If you don't know, just use the default location.
* **What passphrase (password) do you want to use?** You can leave this blank if you don't want a passphrase. This makes automation easier but means you have the private key absolutely private. Read [Do I need to have a passphrase for my SSH RSA key?](https://superuser.com/questions/261361/do-i-need-to-have-a-passphrase-for-my-ssh-rsa-key) for more details.

## Add an SSH key to a remote machine
The file `/home/<username>/.ssh/authorized_keys` contains all public keys that can be used to log in as that user. In order to authenticate ourselves, we will need to copy our public key to the `authorized_keys` of the user on the remote computer.

This can be done in 3 ways:

### 1. Manually add a public key to authorized keys
Get the contents of your private key `id_rsa.pub`. The contents should look similar to this:

```bash
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTSqkjrM7jGLSOr6iRlJbtsLo9hbNkIWKuwqYTYxBOrhlkNranC6GZeuW0xXiQGHoa43PuU/WXrtD9DH7JjcfGiAF+2msdZNxw52qXQJCZ4qDIokzRK499ZJka9ug35qRagCGJbrXOV52b29mCMhcUyxGg5YwssrsGyW36Jx1+hhJsTWoaGBwh3CwDKRPMU/CVAe3NPjd1O/w8o3faenLepir2PgXSx5A5igcDJExfYnmReeGVKuUhfKtc0OPx6D8zyGbn5eGVO07DXhzPkUhk6OUcYXdfkpozMUOAOFC9zYbXHR4fOuQ3B9mjpDbUQZkeC9mhNMvYBRcsYZ1iQdqb username@hostname
```

Now, login to the remote computer and edit `/home/barry/.ssh/authorized_keys`. Add the contents of your public key to the end of the file and save it.

### 2. Add a public key to the autorized_keys using bash
The above can also be achieved by executing the following command:

```bash
$ cat ~/.ssh/id_rsa.pub | ssh barry@123.123.123.123 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >>  ~/.ssh/authorized_keys"
```

This command automates all the things we did before:
* First it gets the content of the public key (`cat ~/.ssh/id_rsa.pub`)
* Then it connects to the remote machine (`ssh barry@123.123.123.123`)
* Now that we have connected, it executes the rest of the command which ensures that the `.ssh` directory exists and is writable before it appends the contents of the public key to the authorized keys (`"mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >>  ~/.ssh/authorized_keys"`)

### 3. Add a public key to authorized_keys using `ssh-copy-id`
The `ssh-copy-id` utility makes the process even simpler, but it is not installed on all machines. Just run the following command:

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub barry@123.123.123.123
```

## Connect to the remote machine
If everything was set up in the correct way, you can now connect like this:

```bash
$ ssh barry@123.123.123.123
```

If you have stored your private key in a different location, try this:
```bash
$ ssh -i /path/to/id_rsa barry@123.123.123.123
```