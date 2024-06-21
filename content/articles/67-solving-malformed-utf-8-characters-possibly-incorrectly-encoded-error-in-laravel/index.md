---
title: 'Solving "Malformed UTF-8 characters, possibly incorrectly encoded" error in Laravel'
date: 2020-09-28T23:00:00+02:00
draft: false
summary: "I ran into this error about malformed characters when return a JSON response. The solution is using multi-byte safe string functions."
types: ['tutorial']
subjects: ['laravel', 'error', 'encoding']
params:
  outdated_warning: true
---
Here is a short blog for a problem I ran into this evening. I was testing a new endpoint that returns some user data in JSON format. Once every while the test was failing, it was flaky.

## The error
The error was this one:
`Malformed UTF-8 characters, possibly incorrectly encoded` at `/path/to/vendor/laravel/framework/src/Illuminate/Http/JsonResponse.php:75`.

## The cause
Since the problem only happened once every couple of tests (and helped by the error message itself) I figured it must be related to the random user that I test with.

This turned out to be true. When a name contains some accented character, like "Ç", this error occured.

## The solution
The solution turned out to be in my application code, it has nothing to do with Laravel itself.

The initials of the user are part of the return data. So in case of a user named "Isabella Özkan", those would be "IÖ".

The old code for getting the initials was using `strtoupper` and `substr` like this:
```php
public function initials(): string
{
    return strtoupper(substr($this->first_name, 0, 1) . substr($this->last_name, 0, 1));
}
```

But these functions are not multi-byte safe and so they can give incorrect results for multi-byte characters. To solve this we should use the equivalent multi-byte safe functions:

```php
public function initials(): string
{
    return mb_strtoupper(mb_substr($this->first_name, 0, 1) . mb_substr($this->last_name, 0, 1));
}
```

That should do it. By using the correct string functions you make sure all characters are properly handled. This, in turn, will allow everything to be outputted as a JSON response without problems.

Happy coding!