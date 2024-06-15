---
title: "Improving the performance of spatie/laravel-permission"
date: 2018-04-26T00:00:00+02:00
draft: false
summary: "Filtering Laravel Collections can become a performance bottleneck. Using the `filter` method is significantly faster then the `where` method, if used properly. Read the article for a full comparison and benchmark results."
types: ['tutorial']
subjects: ['performance']
params:
  outdated_warning: false
---
Recently I was investigating the performance of an application we have built at [SWIS](https://www.swis.nl/?utm_source=barry). To my surprise, one of the most costly methods was part of the excellent [`spatie/laravel-permission`](https://github.com/spatie/laravel-permission/) package.

After reading some more it was clearly a [performance issue](https://github.com/spatie/laravel-permission/issues/550) that could be improved upon. Since the solution was already clearly outlined it was quite easy to code it and submit a pull request.

Now that the solution has been merged and released, here is an explanation of the performance issue and how to avoid such an issue in your own projects.

TL;DR: [skip to the conclusions](articles/46-improving-the-performance-of-spatielaravel-permission/#conclusions).

## Performance bottlenecks

If we look at `spatie/laravel-permission` in an abstract way it mainly does 2 things:
1. Keep a list of permissions that belong to a model.
2. Check if a model has a certain permission.

The first part is not very interesting for this article. The permissions are stored in a database and need to be retrieved. This is a somewhat slow process but it only needs to be done once. The result is cached so it can be reused in subsequent requests.

The second part is much more relevant from a performance standpoint. Depending on the nature and size of a project, permissions need to be checked very often. Any slowness in this process can quickly become a performance bottleneck for the complete application.

## Filtering collections

The method that caused slow performance is concerned with filtering the collection of permissions. What it did was this:

```php
$permission = $permissions
    ->where('id', $id)
    ->where('guard_name', $guardName)
    ->first();
```

And it was changed to this:

```php
$permission = $permissions
    ->filter(function ($permission) use ($id, $guardName) {
        return $permission->id === $id && $permission->guard_name === $guardName;
    })
    ->first();
```

These 2 code blocks achieve exactly the same thing but the second method is much faster.

## Measurements

The application I've been working on has approximately 150 different permissions. On a typical request, 50 permissions need to be checked using the `hasPermissionTo` method, although some pages check as much as 200 permissions.

This is the setup that was used to take these measurements.
```php
$users = factory(User::class, 150)->make();
$searchForTheseUsers = $users->shuffle()->take(50);

# method 1: where
foreach($searchForTheseUsers as $user) {
    $result = $users->where('id', '=', $user->id)->first();
}

# method 2: filter, passing model to callback
foreach($searchForTheseUsers as $searchUser) {
    $result = $users->filter(function($user) use ($searchUser) {
        return $user->id === $searchUser->id;
    })->first();
}

# method 3: filter, passing attributes to callback
foreach($searchForTheseUsers as $user) {
    $searchId = $user->id;
    $result = $users->filter(function($user) use ($searchId) {
        return $user->id === $searchId;
    })->first();
}
```

Each of these 3 methods was tested using by filtering on 1, 2 or 3 attributes. So, filtering on 3 attributes using method #1 looks like this:

```php
foreach($searchForTheseUsers as $user) {
    $result = $users
        ->where('id', '=', $user->id)
        ->where('firstname', '=', $user->firstname)
        ->where('lastname', '=', $user->lastname)->first();
}
```

## Results

|              | Method #1  | Method #2    | Method #3    |
|--------------|:-----------|:-------------|:-------------|
| 1 attribute  | 0.190      | 0.139 (-27%) | 0.072 (-62%) |
| 2 attributes | 0.499      | 0.372 (-25%) | 0.196 (-61%) |
| 3 attributes | 0.488      | 0.603 (+25%) | 0.603 (+25%) |

## Conclusions
We can conclude that repeatedly filtering a large collection can become a serious bottleneck for an application.

Filtering on multiple attributes increases the computational costs significantly.

Replacing the `Collection::where()` method with the `Collection::filter()` method systematically improves performance by about 60%.

**Caveat**: passing complete models to the filter-callback is costly. It is better to pass individual attributes.

## Acknowledgements
Thanks to Spatie and the contributors of `spatie/laravel-permissions` for creating a great package that I love to use! Thanks to [Andru Beldie](https://github.com/andrubeldie) for pointing out the performance issues so they could be investigated and remedied.

## Links
* [spatie/laravel-permission package](https://github.com/spatie/laravel-permission/).
* [Issue #550 addressing performance problem](https://github.com/spatie/laravel-permission/issues/550).
* [Pull request #710 that fixes problems](https://github.com/spatie/laravel-permission/pull/710/files).