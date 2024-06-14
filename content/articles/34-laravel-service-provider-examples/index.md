---
title: "Laravel service provider examples"
date: 2016-11-13T13:00:00+02:00
draft: false
summary: "In this post, we'll look at some Laravel service provider examples. Most common use cases are shown using service providers from real open-source Laravel packages."
types: ['tutorial']
subjects: ['laravel', 'examples', '']
params:
  outdated_warning: true
---
Currently, I'm working on my first Laravel package. So, it was time to dive into the wonderful world of the service container and service providers.

Laravel has some great docs about, but I wanted to see some real-world examples for myself. And what better way than to have a look at the packages that you already depend on?

This post details the different things that a service provider can be used for, each taken from a real open-source project. I've linked to the source of each example.

*Additions:*
*15/11: defining an alias.*
*15/11: registering sub-dependencies.*
*16/11: registering middleware.*
*16/11: registering an event handler.*

## Docs
First of, you should probably have a look at the docs for the [service container](https://laravel.com/docs/5.3/container), [service providers](https://laravel.com/docs/5.3/providers) and [package development](https://laravel.com/docs/5.3/packages).

You can register a service provider by adding it to the `providers` array in `config/app.php` like so:

```php
'providers' => [
    // Other Service Providers
    App\Providers\MyCustomServiceProvider::class,
],
```

Now, let's look at some common scenario's that you can find in service providers.

## Binding
Common binding. Taken from [spatie/laravel-glide](https://github.com/spatie/laravel-glide/blob/master/src/GlideServiceProvider.php).
```php
public function register()
{
    $this->app->bind('laravel-glide-image', function () {
        return new GlideImage();
    });
}
```

<span class="divider"></span>

Singleton binding. Taken from [cviebrock/eloquent-sluggable](https://github.com/cviebrock/eloquent-sluggable/blob/master/src/ServiceProvider.php).
```php
public function register()
{
    $this->app->singleton(SluggableObserver::class, function ($app) {
        return new SluggableObserver(new SlugService(), $app['events']);
     });
}
```

<span class="divider"></span>

Instance binding. Taken from [spatie/laravel\-googletagmanager](https://github.com/spatie/laravel-googletagmanager/blob/master/src/GoogleTagManagerServiceProvider.php).
```php
public function register()
{
    $googleTagManager = new GoogleTagManager(config('googletagmanager.id'));

    if (config('googletagmanager.enabled') === false) {
        $googleTagManager->disable();
    }

    $this->app->instance('Spatie\GoogleTagManager\GoogleTagManager', $googleTagManager);
}
```

<span class="divider"></span>

Define an alias. Taken from [graham-campbell/htmlmin](https://github.com/GrahamCampbell/Laravel-HTMLMin/blob/master/src/HTMLMinServiceProvider.php).
```php
public function register()
{
    $this->app->alias('htmlmin.css', CssMinifier::class);
}
```

<span class="divider"></span>

Register and alias for a sub-dependency. Found on [http://stackoverflow.com/a/22749871/404423](http://stackoverflow.com/a/22749871/404423).
```php
public function register()
{
    $this->app->register('LucaDegasperi\OAuth2Server\OAuth2ServerServiceProvider');

    $this->app->alias('AuthorizationServer', 'LucaDegasperi\OAuth2Server\Facades\AuthorizationServerFacade');
    $this->app->alias('ResourceServer', 'LucaDegasperi\OAuth2Server\Facades\ResourceServerFacade');
}
```

## Resources
The following examples are about publishing resources so they can be used throughout the application.

Configuration. Taken from [mcamara/laravel-localization](https://github.com/mcamara/laravel-localization/blob/master/src/Mcamara/LaravelLocalization/LaravelLocalizationServiceProvider.php).
```php
public function boot()
{
    $this->publishes([
        __DIR__ . '/../../config/config.php' => config_path('laravellocalization.php'),
    ], 'config');
}

public function register()
{
    $packageConfigFile = __DIR__ . '/../../config/config.php';

    $this->mergeConfigFrom(
        $packageConfigFile, 'laravellocalization'
    );
}
```

<span class="divider"></span>

Views. Taken from [laracasts/flash](https://github.com/laracasts/flash/blob/master/src/Laracasts/Flash/FlashServiceProvider.php).
```php
public function boot()
{
    $this->loadViewsFrom(__DIR__ . '/../../views', 'flash');

    $this->publishes([
        __DIR__ . '/../../views' => base_path('resources/views/vendor/flash')
    ]);
}
```

<span class="divider"></span>

Commands. Taken from [jeroen-g/laravel-packager](https://github.com/Jeroen-G/laravel-packager/blob/master/src/PackagerServiceProvider.php).
```php
protected $commands = [
    'JeroenG\Packager\PackagerNewCommand',
    ...
    'JeroenG\Packager\PackagerTestsCommand',
];

public function register()
{
    $this->commands($this->commands);
}
```

<span class="divider"></span>

Migrations. Taken from: [waavi/translation](https://github.com/Waavi/translation/blob/master/src/TranslationServiceProvider.php).
```php
public function boot()
{
    $this->publishes([
        __DIR__ . '/../database/migrations/' => database_path('migrations'),
    ], 'migrations');
}
```

<span class="divider"></span>

Translations. Taken from: [laravelrus/localized-carbon](https://github.com/LaravelRUS/localized-carbon/blob/master/src/Laravelrus/LocalizedCarbon/LocalizedCarbonServiceProvider.php).
```php
public function boot()
{
    $this->loadTranslationsFrom(__DIR__.'/../../lang', 'localized-carbon');

    $this->publishes([
        __DIR__.'/../../lang' => base_path('resources/lang'),
    ]);
}
```

<span class="divider"></span>

Middleware. Taken from: [barryvdh/laravel-cors](https://github.com/barryvdh/laravel-cors/blob/master/src/ServiceProvider.php).
```php
public function boot()
{
    $this->app['router']->middleware('cors', HandleCors::class);
}
```

## Others

[Defer loading](https://laravel.com/docs/5.3/providers#deferred-providers). Register bindings only if they are requested. Can only be used for registering bindings. Taken from [antonioribeiro/google2fa](https://github.com/antonioribeiro/google2fa/blob/master/src/Vendor/Laravel/ServiceProvider.php).
```php
protected $defer = true;

public function register()
{
    $this->app->bind(
       'PragmaRX\Google2FA\Contracts\Google2FA',
       'PragmaRX\Google2FA\Google2FA'
    );
}

public function provides()
{
    return ['PragmaRX\Google2FA\Contracts\Google2FA'];
}
```

<span class="divider"></span>

Register an event handler. Taken from [sentry/sentry-laravel](https://github.com/getsentry/sentry-laravel/blob/master/src/Sentry/SentryLaravel/SentryLaravelServiceProvider.php).
```php
public function boot()
{
    ...
    $this->bindEvents($this->app);
    ...
}

protected function bindEvents($app)
{
    $handler = new SentryLaravelEventHandler($app['sentry'], $app['sentry.config']);
    $handler->subscribe($app->events);
}
```

<span class="divider"></span>

Set event listener. Taken from: [jenssegers/date](https://github.com/jenssegers/date/blob/master/src/DateServiceProvider.php).
```php
public function boot()
{
    $this->app['events']->listen('locale.changed', function () {
        $this->setLocale();
    });

    $this->setLocale();
}

protected function setLocale()
{
    $locale = $this->app['translator']->getLocale();

    Date::setLocale($locale);
}
```

<span class="divider"></span>

Adding a Blade directive. Taken from [spatie/laravel-blade-javascript](https://github.com/spatie/laravel-blade-javascript/blob/master/src/BladeJavaScriptServiceProvider.php).
```php
public function boot()
{
    Blade::directive('javascript', function ($expression) {
        $expression = $this->makeBackwardsCompatible($expression);

        return "<?= app('\Spatie\BladeJavaScript\Renderer')->render{$expression}; ?>";
    });
}
```
