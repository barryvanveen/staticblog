---
title: "RSS feed toegevoegd"
date: 2015-05-30T17:54:00+02:00
draft: false
summary: "Vanaf nu is het mogelijk om je te abonneren op de RSS feed van deze blog. Makkelijk als je het gewend bent om je blogjes lezen met bijvoorbeeld Feedly. Klik rechtsboven op het RSS-icoon om de feed te openen of abonneer je op de url [barryvanveen.nl/rss](/rss)."
params:
  outdated_warning: true
---
Vanaf nu is het mogelijk om je te abonneren op de RSS feed van deze blog. Makkelijk als je het gewend bent om je blogjes lezen met bijvoorbeeld Feedly. Klik rechtsboven op het RSS-icoon om de feed te openen of abonneer je op de url [barryvanveen.nl/rss](rss).

## De feed bouwen
Het bouwen van de RSS feed was gelukkig een eitje door gebruikt te maken van [rss-l4](https://github.com/thujohn/rss-l4). Ik heb een commando genaamd `CreateRssFeedCommand` aangemaakt die ik vanuit mijn controller aanroep.  Dit is de code die in dat commando wordt uitgevoerd:

```php
$rss = new Rss();
$rss->feed('2.0', 'UTF-8');

$rss->channel([
    'title'       => 'Titel van mijn blog',
    'description' => 'Beschrijving van mijn blog',
    'link'        => url(),
]);

$blogs = $this->blogRepository->published();

/** @var Blog $blog */
foreach ($blogs as $blog) {
    $link = route('blog-item', ['id' => $blog->id, 'slug' => $blog->slug]);

    $rss->item([
        'title'             => $blog->title,
        'description|cdata' => $blog->body,
        'link'              => $link,
        'guid'              => $link,
    ]);
}

return $rss;
```

In de controller hoef ik nu niets anders te doen dan het commando aan te roepen en als XML terug te geven:

```php
$rss = $this->commandBus->execute(
    new CreateRssFeedCommand()
);

return Response::make($rss, 200, ['Content-Type' => 'text/xml']);
```

## Waarom een command?
Ik heb ervoor gekozen de code die de feed opbouwt in een command te plaatsen. Dit is geen [Artisan-commando](/articles/3-je-laravel-website-deployen-met-1-commando) maar een manier om de logica van je applicatie te scheiden van je controllers. Ik maak hiervoor gebruik van [Flyingfoxx/CommandCenter](https://github.com/airbornfoxx/commandcenter).

Dit zorgt er niet alleen voor dat de controller lekker opgeruimd blijft maar ook dat het genereren van de RSS feed nu vanuit elk stukje code aanroepbaar is, handig als ik dat soort functionaliteit later moet hergebruiken.