---
title: "Using a UUID in a Laravel Eloquent model"
date: 2019-06-01T11:00:00+02:00
draft: false
summary: "Changing the primary key from an auto-incrementing integer to a UUID is really simple in Laravel Eloquent."
types: ['tutorial']
subjects: ['laravel', 'eloquent', 'uuid']
params:
  outdated_warning: true
---
One of the things I really love about Laravel is how easy it is to customize it to your own wishes.

Recently I was working on a model that used a standard auto-incrementing integer as its primary key. My task was to convert this model to work with a [version 4 UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_(random)).

## Making the change
It was actually quite simple, there are just a few protected attributes you have to change on the Eloquent model(s), as can be seen in this code sample:

```php
class Article extends Model
{
    // column name of key
    protected $primaryKey = 'uuid';

    // type of key
    protected $keyType = 'string';

    // whether the key is automatically incremented or not
    public $incrementing = false;
}
```

## What does this do?
This change will make some frequently used Eloquent methods as they did before. For example `Article::find()` can now be called using the UUID. The same is true for `findMany`, `findOrFail` and `firstOrNew`.

Authentication with an Eloquent user model will now also work as you would expect it. This should not come as a surprise as authenticated uses the same Eloquent methods as we mentioned before. Still, it is very nice we don't need to make any further changes to get this to work.

## What does not automatically work?
Not everything will automatically work as it did before. The best example I've come across is [model route binding](https://laravel.com/docs/5.8/routing#implicit-binding). Depending on whether you use implicit or explicit model binding you will need to make different changes, which are clearly stated in the docs.