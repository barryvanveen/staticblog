---
title: "Laravel Blade @each directive"
date: 2016-07-08T13:30:00+02:00
draft: false
summary: "The relatively unknown `@each` function in a very powerful way to loop over data in Laravel Blade templates. It is powerful and much more elegant than `@foreach`."
types: ['tutorial']
subjects: ['laravel', 'blade']
---
The relatively unknown `@each` function in a very powerful way to loop over data in Laravel Blade templates. It is powerful and much more elegant than `@foreach`.

## @foreach
Suppose you want to loop over all comments on your article. You would probably write something like this:

```php
@if(count($article->comments) > 0) 
    @foreach($article->comments as $comment)
        @include('comments.item')
    @endforeach
@else
    @include('comments.no-items')
@endif
```

This looks awfully messy. You're glad there is a better way to do this, with `@forelse`.

## @forelse
```php
@forelse($article->comments as $comment)
    @include('comments.item')
@empty
    @include('comments.no-items')
@endforelse
```

Better, but still sort of messy. For almost every `@forelse` that you write, you will have to include the `@empty` statement. We still have the indentation which makes this very simple task into a block of code. Enter `@each`

## @each
```php
@each('comments.item', $article->comments, 'comment', 'comments.no-items')
```

That's it. No conditionals, no indentation.

The arguments are:
1. The view partial for rendering each element in the array or collection.
2. The array or collection you want to iterate over.
3. The variable name that the current element will be assigned to.
4. [Optional] The view partial that will be rendered if the array or collection is empty.

Because the view partials will have descriptive names of themselves this code is very self-explanatory. No need for a `@empty` statement when the particle is called `comments.no-items`, right?

So, rendering a list of articles with their respective comments would look something like this:

```php
// articles/full-list.blade.php
@each('articles.item', $articles, 'article', 'articles.no-items')

// articles/item.blade.php
{{ $article->title}
@each('comments.item', $article->comments, 'comment', 'comments.no-items')

// comments/item.blade.php
{{ comment->author }} wrote: {{ comment->text}}.
```

*According to the docs `@each seems to be available from Laravel 5.1 and newer.*