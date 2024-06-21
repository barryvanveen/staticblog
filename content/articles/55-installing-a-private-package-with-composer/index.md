---
title: "Installing a private package with composer"
date: 2019-01-21T23:00:00+02:00
draft: false
summary: "This articles explains how to install a private PHP package with Composer. Using SSH keys and a little composer.json magic, in just 3 steps."
types: ['tutorial']
subjects: ['git', 'composer', 'ssh']
params:
  outdated_warning: false
---
Private PHP packages can be installed using Composer. We need a little extra configuration in the `composer.json` file and then we setup our SSH key. Follow along with these 3 easy steps, and don't miss the caveat at the end.

*1/25 update: provided a safer way to add a host to the known_hosts file. Thanks George for pointing this out!*

## 1. Point to the Git repository
Update composer.json and add a repository:

```json
"repositories":[
    {
        "type": "vcs",
        "url": "git@github.com:barryvanveen/secret.git"
    }
]
```

## 2. Create an SSH key
Create an [SSH Key](https://barryvanveen.nl/blog/53-ssh-keys-101) on the machine on which you want to install the package.

If you are working on a development machine, you probably want to add the SSH key to your GitHub/BitBucket/GitLab account. This gives access to all private repositories that your account has access to.
* [Add an SSH key to a GitHub account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)
* [Add an SSH key to a BitBucket account](https://confluence.atlassian.com/bitbucket/set-up-an-ssh-key-728138079.html#SetupanSSHkey-#installpublickeyStep3.AddthepublickeytoyourBitbucketsettings)
* [Add an SSH key to a GitLab account](https://docs.gitlab.com/ee/gitlab-basics/create-your-ssh-keys.html)

In case you are configuring a deployment server, it would be better to configure an access key or deploy key. An access key only provides access to a single repository and thus allows for more specific access management.

* [Add a deploy key to a GitHub repository](https://developer.github.com/v3/guides/managing-deploy-keys/#deploy-keys)
* [Add an access key to a BitBucket repository](https://confluence.atlassian.com/bitbucket/use-deployment-keys-294486051.html)
* [Add a deploy key to a GitLab repository](https://docs.gitlab.com/ee/ssh/#deploy-keys)

## 3. Run composer
Now just `composer require` or `composer install` the package as usual.

## Caveat: add an SSH fingerprint to known hosts
The first time you use an SSH key on a new hostname, it will show you a warning like this:

```bash
The authenticity of host '123.123.123.123 (123.123.123.123)' can't be established.
RSA key fingerprint is a1:b2:c3:d4:e5:f6:6f:5e:4d:3c:2b:1a:00:11:22:33.
Are you sure you want to continue connecting (yes/no)?
```

This serves as an extra layer of protection to prevent you from mistakenly connecting to an unknown host. This does however pose some problems if you want to use SSH keys to automate tasks.

That is why we want to trigger this warning manually and avoid it from popping up in the future. This can be done using the following command:

```bash
ssh -T git@github.com
``` 

Naturally, you should replace `git@github.com` with the hostname of your private repository. This command will invoke the warning that is listed above. You can verify the fingerprint with the list of fingerprints in your GitHub/BitBucket/GitLab account.

After confirming this warning the SSH fingerprint will be added to the list of known hosts and this will prevent the warning from popping up again.