---
title: "Pluralization in Laravel translations"
date: 2016-07-15T12:00:00+02:00
draft: false
summary: "Laravel translations can depend on the number of subjects: one apple, two apple**s**. This article will explain more complex pluralizations: no apples, one apple, two apples, tons of apples."
types: ['tutorial']
subjects: ['laravel', 'translations', 'blade']
---
Laravel translations can depend on the number of subjects: one apple, two apple**s**. This article will explain more complex pluralizations: no apples, one apple, two apples, tons of apples.

## Define and use translations
In Laravel you can define translations in the `/resources/lang/` folder. Each folder contains files with the translations for a specific language. An example of these translations:

```php
// en/comments.php
'title' => 'Comments',

// nl/comments.php
'title' => 'Reacties',
```

In your views you can use these with a helper like so:

```php
trans('comments.title')
```

## Replacing parameters
Parameters can be used in translations like so:

```php
// en/comments.php
'number-of-comments' => ':count comments',

// in your views
trans('comments.number-of-comments', ['count' => $count])
```

## Pluralization
Pluralizations give you the ability to express the difference between 1 comment and 2 comment**s**. This time, we must use the `trans_choice` helper function.

```php
// en/comments.php
'number-of-comments' => ':count comment|:count comments',

// in your views
trans_choice('comments.number-of-comments', ['count' => $count])
```

The downside of these pluralizations is they only define the difference between a single object and multiple objects. If we want to overcome this problem we must be specific about interval that each string belongs to.

## Advanced pluralizations
Because Laravel translations are powered by the Symfony Translation component we can define even more powerful translations like this.

```php
// en/comments.php
'number-of-comments' =>  '{0} no comments yet|{1} 1 comment|[2, Inf] :count comments',

// in your views
trans_choice('comments.number-of-comments', $count, ['count' => $count])
```
Each translation is a list of separated strings. Each string belongs to an interval that is denoted in the [ISO 31-11](https://en.wikipedia.org/wiki/ISO_31-11) form.

A few examples of intervals:

```text
{0}         = 0
{1,2,3}     = 1, 2, 3
[0, 3]      = 0, 1, 2, 3
]0, 3]      = 1, 2, 3
]0, 3[      = 1, 2
[-2, Inf]   = -2, -1, 0, 1, 2, ..., n
[-Inf, Inf] = -n, ..., -1, 0, 1, ..., n
```

## Further reading
* [Laravel translation pluralization](https://laravel.com/docs/5.2/localization#pluralization)
* [Symfony Translator usage](http://symfony.com/doc/current/components/translation/usage.html#explicit-interval-pluralization)
* [Interval notations](https://en.wikipedia.org/wiki/Interval_(mathematics)#Notations_for_intervals)
