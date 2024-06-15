---
title: "Solving inconsistent line endings within a Git repository"
date: 2018-08-22T20:00:00+02:00
draft: false
summary: 'If you develop code on both Windows and Linux machines you might have run into inconsistent line endings. This might lead to "empty" commits, consisting only of changed line endings. This post describes how a .gitattributes file can solve all your (line ending-related) problems.'
types: ['tutorial']
subjects: ['git', 'linting']
params:
  outdated_warning: false
---
Windows uses CRLF (\r\n) lined endings while Linux uses LF (\n). If like me, you develop on both Windows and Linux machines you might experience some annoying problems.

In my case, these problems consisted of "empty" commits in which many files only had changes in line endings. Mostly, these were caused by running a [code style fixer](/articles/31-how-to-automatically-apply-the-laravel-php-code-style) that introduced these inconsistencies.

This can be fixed by adding 2 configuration files to your project. The benefit of this approach is that the fixes are easy to share among team members and consistent across different systems without requiring reconfiguration.

## .gitattributes

The [`.gitattributes` file](https://www.git-scm.com/docs/gitattributes) allows one to configure "attributes" for "paths" in Git. A path is usually a file extension. Some examples of attributes include:
* type of file (text or binary)
* type of line ending ("lf" or "crlf")
* tab width
* how to display the diff

So, start by adding .gitattributes to the root of your project. Then, copy [the `.gitattributes` gist](https://github.com/swisnl/gists/tree/master/gitattributes) that we use for all our projects at SWIS.

What this does is tell Git to only use LF line endings in all files where that is appropriate. So, enable it for .css or .php but not for .png of .woff.

## .editorconfig

Now that Git knows what type of line endings we want, it is time to configure our editor. The [`.editorconfig` configuration file](https://editorconfig.org/) is meant to do just that. It has a simple markup and can be re-used by any editor.

Add a `.editorconfig` file to the root of your project and add an EditorConfig plugin to your editor for choice.

At SWIS, we also made a [.editorconfig gist](https://github.com/swisnl/gists/tree/master/editorconfig) that can get you up-and-running quickly.

## Cleaning things up

Now that we have successfully configured our project, it is time to clean up all incorrect line endings that are left.

My editor of choice is PHPStorm and one of the reasons is that fixing things across files is really easy. To fix all inconsistent line endings, do the following:

* Hit shift 2 times (this will bring up the "search everywhere" dialog).
* Search for "run inspection by name".
* Find the inspection "Inconsistent line separators" and run in on the whole project.
* A list with all incorrect line separators will be displayed and there is a button to fix all issues at once.

If you don't use PHPStorm, GitHub has a great write-up of how to fix all line endings by just using the [git command line](https://help.github.com/articles/dealing-with-line-endings/#refreshing-a-repository-after-changing-line-endings).

Once this is done, commit your changes and everything should be solved!

## Further reading
* [Background info on the Newline control character](https://en.wikipedia.org/wiki/Newline).
* [Dealing with line endings help article on GitHub](https://help.github.com/articles/dealing-with-line-endings).