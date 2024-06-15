---
title: "Package development: run a package from a local directory"
date: 2018-01-26T23:30:00+02:00
draft: false
summary: "This article explains how you can require a package from a local path into your project with Composer. This way you can run a local copy of a repository and test any changes you make. Because the local repo will be symlinked changes are shared in real-time, there is no need for intermediate committing and updating."
types: ['tutorial']
subjects: ['opensource', 'composer']
params:
  outdated_warning: true
---
Suppose you run a website and want to split part of it into a package with its own repository. You start a new repository and check it out on your development machine. But now you want to see how the website and your new package integrate. How to go about this?

This article explains how you can require a package from a local path into your project with Composer. This way you can run a local copy of a repository and test any changes you make. Because the local repo will be symlinked changes are shared in real-time, there is no need for intermediate committing and updating.

## Path repository

For starters, add a new repository of the type "path" to your composer.json. This will tell Composer that the given path is another source (besides the default Packagist repository) for finding your dependencies.

My dev machine is a Laravel Homestead virtual machine. The code for my [php-cca](https://github.com/barryvanveen/php-cca) repository is in `/home/vagrant/Code/php-cca` so that is where I point Composer.

```json
"repositories":[
    {
        "type": "path",
        "url": "/home/vagrant/Code/php-cca"
    }
]
```

Next time we run Composer it will look at Packagist *and* into the given directory. Custom repositories have preference over Packagist.

## Require a development-branch

Now that Composer knows where to look for the local package, it is time to require a specific version. We will require the `dev-develop` branch using this command:

```bash
composer require barryvanveen/php-cca dev-develop
```

This means that we will get the latest source from the `develop` branch. We could easily swap this for the `dev-master` or `dev-feature-awesome`  branch.

The important thing is that this will install the latest code from the local path, not just the latest version that we have committed or tagged.

The resulting output of Composer should look similar to this:

```bash
Package operations: 5 installs, 0 updates, 0 removals
  ...
  - Installing barryvanveen/php-cca (dev-develop): Symlinking from /home/vagrant/Code/php-cca
  ...
```

And that's it, you can now change the code in your local path and immediately test the results in your project. No need to commit any work or run `composer update`. Isn't that great?

## When symlinking fails

When I first tried the steps mentioned above it didn't work out. I got the following error stating that Composer was unable to create a symlink.

```bash
Package operations: 5 installs, 0 updates, 0 removals
  ...
  - Installing barryvanveen/php-cca (dev-develop): Symlinking from /home/vagrant/Code/php-cca
    Symlink failed, fallback to use mirroring!
    Mirroring from /home/vagrant/Code/php-cca
```

After some searching, it turns out that this problem is specific for Windows users running a virtual machine. Windows does not allow local admins to create symlinks. Luckily this can be solved with a single change.

When you start your VM make sure you do this *as an administrator*. In my case, I run Git Bash as an administrator and then run `vagrant up` from there. This solved the problem immediately.

## Continue reading

* Learn more about Composer [repositories](https://getcomposer.org/doc/05-repositories.md) and [aliases](https://getcomposer.org/doc/articles/aliases.md#branch-alias) in the docs.
* Martin Hujer has a great blog post with [22 tips for using Composer](https://blog.martinhujer.cz/17-tips-for-using-composer-efficiently/).