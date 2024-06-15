---
title: "Enforce strict type checking in PHP with PHP Code Sniffer"
date: 2018-08-03T18:00:00+02:00
draft: false
summary: "PHP 7+ has support for strict type checking. Using PHP Code Sniffer we can enforce the use of `declare(strict_types=1);` at the beginning of each file."
types: ['tutorial']
subjects: ['linting', 'tools', 'php']
params:
  outdated_warning: true
---
Since [version 7.0](https://secure.php.net/manual/en/migration70.new-features.php), PHP has the ability to use strict type checking. Let us look at the differences between loose and strict type checking. Afterward, we can have a look at enforcing strict type checking in every file of our project.

To illustrate the difference be loose type checking and strict type checking, consider the following method:

```php
function add(int $a, int $b): int 
{
    return $a + $b;
}
```

## Loose type checking
With loose type checking, all these calls would yield a result:
```php
add(3, 3);   // 6
add(3, '3'); // 6
add(3, 3.0); // 6
add(3, true); // 4
```

Internally, PHP casts each parameter into an integer. As long as it is able to do so, the function call will succeed and a value will be returned.

This behavior is pretty normal if you are familiar with PHP. However, because the method was defined with type hints, one would suspect these types to be enforced. This is not the case by default and can lead to hard-to-find bugs.

## Strict type checking
Strict type checking can be enabled by starting the PHP file with the following code:

```php
<?php
declare(strict_types=1);
```

With strict type checking enabled, only the first call would succeed. All other calls will trigger a TypeError.

In my view, strict types are more predictable and thus better. They might also break backward compatibility and that is why there is [no built-in way to enforce strict types for a whole project](https://stackoverflow.com/a/37112026/404423).

## PHP CS to the rescue
[PHP Code Sniffer](https://github.com/squizlabs/PHP_CodeSniffer) is a tool to check and fix code style issues throughout a code base. Thanks to the [slevomat/code-standard](https://github.com/slevomat/coding-standard) extension it can be used to sniff out even more style problems.

Firstly, install PHP CS and the extension using composer:
```bash
composer require squizlabs/php_codesniffer ~3.0
composer require slevomat/coding-standard ~4.0
```

Then, create a `ruleset.xml` file in the root of your project with the following contents:
```xml
<?xml version="1.0"?>
<ruleset name="name-of-your-project">
    <!-- relative path from PHPCS source location -->
    <config name="installed_paths" value="vendor/slevomat/coding-standard"/>

    <!-- specific sniffs to include -->
    <rule ref="vendor/slevomat/coding-standard/SlevomatCodingStandard/Sniffs/TypeHints/DeclareStrictTypesSniff.php" />
</ruleset>
```

Now, add the following 2 lines to the scripts-section of `composer.json`:
```json
"check-style": "phpcs -p --standard=ruleset.xml --runtime-set ignore_errors_on_exit 1 --runtime-set ignore_warnings_on_exit 1 src tests",
"fix-style": "phpcbf -p --standard=ruleset.xml --runtime-set ignore_errors_on_exit 1 --runtime-set ignore_warnings_on_exit 1  src tests"
```
## Usage
Now, with `composer check-style` and `composer fix-style` you are able to enforce the declaration of strict type checking in all files. Use these commands in the continuous integration platform of your choice and loose types will (hopefully) never trip you up again!

## Further reading
* Learn more about this code style rule at the [slevomat/coding-standards repository](https://github.com/slevomat/coding-standard#slevomatcodingstandardtypehintsdeclarestricttypes-).
* Have a look at my [example ruleset.xml](https://github.com/barryvanveen/php-cca/blob/34aa006d8934e8ec201d11ddef78a77fa38962fb/ruleset.xml#L1-L24) for a more advanced configuration. I've used it in my [barryvanveen/php-cca](https://github.com/barryvanveen/php-cca) package and loved it.
* Other methods of [enforcing code style](/articles/31-how-to-automatically-apply-the-laravel-php-code-style) in your projects.