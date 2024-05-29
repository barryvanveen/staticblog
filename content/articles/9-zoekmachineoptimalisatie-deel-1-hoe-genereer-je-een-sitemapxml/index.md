---
title: "Zoekmachineoptimalisatie deel 1: Hoe genereer je een sitemap.xml?"
date: 2015-07-19T17:00:00+02:00
draft: false
summary: "Een sitemap is een overzicht van alle bereikbare pagina's van je website. Het is een hulpmiddel dat door zoekmachines wordt gebruikt om alle pagina's te indexeren. Het bouwen van een sitemap is daarmee één van de eerste stappen die je kunt zetten om je website beter vindbaar te maken in Google en andere zoekmachines."
types: ['tutorial']
subjects: ['seo', 'sitemap', 'laravel']
params:
  outdated_warning: true
---
Een sitemap is een overzicht van alle bereikbare pagina's van je website. Het is een hulpmiddel dat door zoekmachines wordt gebruikt om alle pagina's te indexeren. Het bouwen van een sitemap is daarmee één van de eerste stappen die je kunt zetten om je website beter vindbaar te maken in Google en andere zoekmachines.

Gelukkig is het genereren van een sitemap vrij makkelijk. Je moet een XML-bestand opbouwen volgens de [specificaties op sitemaps.org](http://www.sitemaps.org/protocol.html). Als je website minder dan 50.000 pagina's heeft dan kun je gewoon onderstaande stappen volgen, anders moet je nog even verder lezen over [sitemap index files](http://www.sitemaps.org/protocol.html#index).

## Stappenplan
### Maak een route aan in `app/Http/routes.php`
```php
Route::get('sitemap.xml', [
    'as'   => 'sitemap',
    'uses' => 'SitemapController@index',
]);
```

### Statische routes opzoeken en filteren
In je SitemapController wil je vervolgens zoveel mogelijk routes automatisch toevoegen aan je sitemap. We pakken dus alle routes die zijn geregistreerd in de router en loopen daar overheen. Daarbij negeren we alle routes die niet overeenkomen met onze wensen.

```php
$routes = Route::getRoutes();
$sitemap = [];

/** @var \Illuminate\Routing\Route $route */
foreach ($routes->getIterator() as $route) {

    // de route heeft geen GET-method
    if (!in_array('GET', $route->getMethods())) {
       continue;
    }

    // de route bevat URL-parameters
    if (strpos($route->getUri(), '{') !== false) {
        continue;
    }

    // de route is geconfigureerd als verborgen in routes.php
    $action = $route->getAction();
    if (isset($action['sitemap']) && isset($action['sitemap']['hidden']) && $action['sitemap']['hidden'] === true) {
        continue;
    }

    // als dit de sitemap.xml-route zelf is
    if ($route->getName() == Route::getCurrentRoute()->getName()) {
         continue;
    }

    // voeg deze route toe aan de sitemap
    $sitemap[] = [
        'loc'     => url($route->getUri()),
    ];
}
```

Daarbij zien we één bijzondere voorwaarde. In routes.php heb ik aan een aantal routes (bijvoorbeeld die naar de beheerpagina's) een waarde toegevoegd om de routes op te filteren. Dat kun je op de volgende manier doen voor een individuele route (en werkt vergelijkbaar voor een route-groep):
```php
Route::get('niet-indexeren', [
    'as'   => 'name',
    'uses' => 'MyController@index',
    'sitemap' => [
        'hidden' => true
    ]
]);
```

### Aanvullen met dynamische routes
Nu hebben we dus een overzicht van alle statische pagina's. De dynamische pagina's, in mijn geval alle blogposts, moeten los worden opgehaald. Dat doe ik op de volgende manier:
```php
$blogs = $this->blogRepository->published();

/** @var Blog $blog */
foreach ($blogs as $blog) {
    $sitemap[] = [
        'loc'     => url(route('blog-item', ['id' => $blog->id, 'slug' => $blog->slug])),
        'lastmod' => Carbon::createFromFormat('Y-m-d H:i:s', $blog->updated_at)->format('Y-m-d\TH:i:sP');
    ];
}
```

### De XML genereren en outputten
We hebben nu dus een array met alle pagina's op de website. Hier willen we een XML van genereren. In de controller roepen we dus een template aan en hieraan geven we de array mee. Het resultaat outputten we daarna als XML.

De controller:
```php
$xml  = View::make('templates.sitemap', ['items' => $sitemap]);

return Response::make($xml, 200, ['Content-Type', 'text/xml']);
```

De template:
```php
{{ -- hack om XML-openingstag te kunnen outputten binnen Blade --}}
{!! '<'.'?'.'xml version="1.0" encoding="UTF-8"?>' !!}

<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd"
        xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">

    @foreach($items as $item)
    <url>
        <loc>{{ $item['loc']  }}</loc>
        @if(isset($item['lastmod']))
        <lastmod>{{ $item['lastmod'] }}</lastmod>
        @endif
    </url>
    @endforeach

</urlset>
```

## Het resultaat
Het resultaat kun je bekijken op [https://barryvanveen.nl/sitemap.xml](https://barryvanveen.nl/sitemap.xml). Niet dat er echt veel aan te zien is, het is nou eenmaal niet gemaakt voor menselijke bezoekers maar voor zoekmachines...

Als je eenmaal de XML hebt gegenereerd moet je die even testen met de [W3Schools XML Validator](http://www.w3schools.com/xml/xml_validator.asp). Daarna kun je de sitemap indienen in de [Google Search Console](https://www.google.com/webmasters/tools/), het vroegere Google webmasters Tools.

Ik heb er in mijn sitemap voor gekozen geen gebruik te maken van de velden `priority` en `changefreq`. Ik heb het volgens mij gewoon niet nodig en ze zijn niet voor niets optioneel.

## En nu?
Nu is het eventjes wachten tot Google alles geïndexeerd heeft. Ik verwacht er verder niet al te veel van, ik zal niet ineens boven aan in de ranking staan op keywords als `blog`, `php` of `laravel` maar die sitemap moest toch een keer gemaakt worden.

Komende week ga ik verder met het opschonen van mijn html want op dit moment benut ik nog niet alles wat html5 te bieden heeft...
