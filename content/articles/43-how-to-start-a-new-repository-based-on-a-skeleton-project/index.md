---
title: "How to start a new repository based on a skeleton project"
date: 2017-09-15T18:00:00+02:00
draft: false
summary: "When you start a new project it is best to stick the best practices. Skeleton projects provide a good basis. I'll describe how to get up and running fast."
types: ['tutorial']
subjects: ['opensource', 'php']
params:
  outdated_warning: true
---
When you start a new project it is best to stick to some best practices. Skeleton projects provide a basis for starting your project with a good directory structure, documentation, and configuration.

The [skeleton project from ThePhpLeague](https://github.com/thephpleague/skeleton) is such a project. It provides all common files, such a `composer.json`, a PHPUnit configuration file and a README.

But how do you easily start a new project with this skeleton as a basis? Let's find out!

## Checkout the skeleton project

Let us first clone the skeleton project and configure it to our needs. The following command will checkout the project into the `my-project` directory:
```bash
git clone https://github.com/thephpleague/skeleton my-project
```

Now we should configure the skeleton project. Cd into the my-project directory and start the prefill.php script that comes with the skeleton. It will ask you all necessary details to get started.
```bash
cd my-project
php prefill.php # and follow the instructions
rm prefill.php
```

Check if everything is set up as you like. In my case, I had to ignore the `.idea` directory that PHPStorm automatically creates.

Commit your changes *but do not push them yet*.

## Link it to your own repository

Now it is time to create a new repository on your favorite version control service, like Github or BitBucket. Be sure to use the same vendor and package name that you have configured in the skeleton code.

The remote origin is still set to the `thephpleague/skeleton` repository.
```bash
vagrant@homestead:~/Code/php-cca$ git remote -v
origin  https://github.com/thephpleague/skeleton (fetch)
origin  https://github.com/thephpleague/skeleton (push)
```

To be able to push the code to our own repository, we have to replace the remote origin repository. This can be done with these 2 commands:
```bash
git remote remove origin
git remote add origin https://github.com/barryvanveen/php-cca.git
```

Now it should be pointing to our own repository.
```bash
vagrant@homestead:~/Code/php-cca$ git remote -v
origin  https://github.com/barryvanveen/php-cca.git (fetch)
origin  https://github.com/barryvanveen/php-cca.git (push)
```

## Create a clean first commit
So now we have set everything up and can commit our code. There is just one final caveat: the skeleton project has its own history and commit log. Personally, I don't want that history to show up in my new projects history.

We can solve this by creating a new *orphan* branch. The following command will create a branch called `develop`  without any of the history of the original branch:
```bash
git checkout --orphan develop
```

Now we can commit and push our changes. Delete any local branches that you don't want to keep and we are done setting up our shiny new repository. All is set to start coding, happy developing!