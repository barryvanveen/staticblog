---
title: "Consistency is key"
date: 2022-10-14T15:30:54+02:00
draft: false
summary: "Clean code with consistent formatting is easier to read. Writing code in a consistent way is hard. That is why I'm a big fan of tools that automate this process. "
types: ['tutorial']
subjects: ['linting', 'tools']
params:
  outdated_warning: false
---
Clean code with consistent formatting is easier to read. Writing code in a consistent way is hard. That is why I'm a big fan of tools that automate this process.

## PHP CodeSniffer

[PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer) provides an easy way to define a coding standard and report any violations. The best part is that it can solve many violations automatically.

In my experience, it is easiest to store your configuration in a [ruleset xml file](https://github.com/squizlabs/PHP_CodeSniffer/wiki/Annotated-Ruleset).

In this configuration file, you define a custom standard. You can start with a preconfigured standard, like [PSR-12](https://www.php-fig.org/psr/psr-12/). Then you deviate from the standard by excluding or including specific rules.

## Slevomat Coding Standard

[Slevomat Coding Standard](https://github.com/slevomat/coding-standard) is not a tool in itself, but a big set of rules you can apply with PHP CodeSniffer.

You can, for example, automatically sort use statements. Or require trailing commas in multiline arrays.

Have a look at [my CodeSniffer configuration file](https://github.com/barryvanveen/blog/blob/master/ruleset.xml) if you want some inspiration.

## Rector

If you are looking for a tool to automatically refactor code, try out [rectorphp/rector](https://github.com/rectorphp/rector).

It is not strictly a code standard tool, but it can be used in much the same way. If have used it to apply new PHP 8.0 features to an entire project:
- promoted properties in all constructors;
- using `::class` on objects instead of `get_class()`;
- using the new `str_starts_with()` function.

## Automation

Writing code according to your (team's) standard can be hard. That is why I always automate these tasks.

To make life just a little easier I always have a custom composer script. With `composer fix-style` all code is scanned and fixed where possible.

On every PR I have a script that runs `composer check-style` that errors when wrongly formatted code is committed.