---
title: "How to automatically apply the Laravel PHP code style"
date: 2016-10-04T00:00:00+02:00
draft: false
summary: "Writing clean and readable code is essential. Having a properly defined code style, and adhering to that, is tedious work. Let's automate it as much as possible."
types: ['tutorial']
subjects: ['linting', 'tools', 'laravel', 'php']
params:
  outdated_warning: true
---

Writing clean and readable code is essential. Having a properly defined code style, and adhering to that, is tedious work. Let's automate it as much as possible.

## Laravel code style
Laravel uses the [PSR-1](http://www.php-fig.org/psr/psr-1/) and [PSR-2](http://www.php-fig.org/psr/psr-2/) code style standards. These conventions define things like:

* Class names MUST be declared in `StudlyCaps`.
* Method names MUST be declared in `camelCase`.
* Code MUST use 4 spaces for indenting, not tabs.

These are the obvious ones, some rules are more detailed and less easy to remember and stick to. It costs a lot of energy to memorize all rules and be strict about using them.

That is why automatic code style checkers are so great, they can save you a lot of work!

## Editor
Many editors allow you to configure your preferred code style. My experience is that it is hard to configure and get exactly right. Also, I haven't found a predefined set of rules that works for me. That's why the following tools are so useful.

## PHP-CS-Fixer
I've been happily using [friendsofphp/php-cs-fixer](https://github.com/friendsofphp/php-cs-fixer) for quite some time now. You can install it using Composer and it has a `.php_cs` config file that you can commit to your repository.

[My `.php_cs` config](https://github.com/barryvanveen/barryvanveen/blob/master/.php_cs) is copied from `laravel/framework` but I've excluded checking on some directories and files.  It still uses the same fixers so the code style is exactly the same as the Laravel core.

Simply run `php-cs-fixer fix` to check and fix all issues in your repository!

## StyleCI
Laravel Framework uses [StyleCI](https://styleci.io/) to automatically check for code style issues on new commits and pull requests.

StyleCI allows you to deal with issues in multiple ways:
* It can notify you when it finds issues.
* It can automatically send (and merge) fixes through pull requests.
* It can automatically commit fixes.

Setup is easy with the [.styleci.yml](https://github.com/barryvanveen/barryvanveen/blob/master/.styleci.yml) config file and they have Laravel code style preset. It's also free for open source projects!