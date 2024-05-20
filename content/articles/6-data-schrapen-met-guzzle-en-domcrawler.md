---
title: "Data schrapen met Guzzle en DomCrawler"
date: 2015-06-15T23:00:00+02:00
draft: false
summary: "Omdat ik tegenwoordig al mijn blogjes in [Feedly](https://www.feedly.com) lees wil ik graag voor alles een RSS feed hebben. Helaas heeft LuckyTV nog geen eigen RSS feed dus heb ik besloten die dan maar zelf in elkaar te knutselen. Dat gaat gelukkig heel makkelijk met [Guzzle](https://github.com/guzzle/guzzle) en de [DomCrawler](http://symfony.com/doc/current/components/dom_crawler.html) van Symfony."
params:
  outdated_warning: true
---

Omdat ik tegenwoordig al mijn blogjes in [Feedly](https://www.feedly.com) lees wil ik graag voor alles een RSS feed hebben. Helaas heeft LuckyTV nog geen eigen RSS feed dus heb ik besloten die dan maar zelf in elkaar te knutselen. Dat gaat gelukkig heel makkelijk met [Guzzle](https://github.com/guzzle/guzzle) en de [DomCrawler](http://symfony.com/doc/current/components/dom_crawler.html) van Symfony.

## Data scraping, data schrapen
Volgens mij is er geen mooie Nederlandse vertaling voor *Data scraping* maar letterlijk is het dus *data schrapen*, op zich klinkt dat ook wel lekker. Wat ermee bedoeld wordt is dat je op een geautomatiseerde manier een webpagina opvraagt en de data verwerkt.

Dat is precies wat we kunnen doen met [het overzicht van alle afleveringen van LuckyTV](http://www.luckymedia.nl/luckytv/category/dwdd/). Voor het omzetten van deze webpagina naar een RSS feed moet je een paar stappen doorlopen:

1. Haal de html van de pagina op met Guzzle.
```php
    use GuzzleHttp\Client;
        
    // zet de timeouts op 10 seconden
    $client = new Client([
        'connect_timeout' => 10,
        'timeout'         => 10,
    ]);

    // doe een request naar de url
    $response = $client->get('http://www.luckymedia.nl/luckytv/category/dwdd/');

    // geef de html van de response terug
    return $response->getBody()->getContents();
```
In [de documentatie van Guzzle](http://docs.guzzlephp.org/en/latest/quickstart.html) kun meer lezen over de functionaliteiten van Guzzle, en die zijn ontzettend uitgebreid. Je kunt naast data ophalen ook data opsturen. Er zijn standaard verschillende exceptions te gebruiken om bijvoorbeeld 404-responses af te vangen. En Guzzle ondersteunt ook nog eens de gloednieuwe [PSR-7 standaard](http://docs.guzzlephp.org/en/latest/psr7.html).

2. Haal de benodigde data uit de opgehaalde html met DomCrawler.
```php
    use Symfony\Component\DomCrawler\Crawler;
    
    // initialiseer de crawler met de opgehaalde html
    $crawler = new Crawler($html);

    // loop over alle elementen die overeen komen met het filter
    $posts = $crawler->filter('div#content div.post div.meta')
                     ->each(function (Crawler $node) {

        // haal specifieke data uit het element
        $title = $node->filter('h3.title a')->text();
        $link = $node->filter('h3.title a')->attr('href');
        $date = $node->filter('div.date')->text();
    
        return compact('title', 'link', 'date');
    });

    // geef een array met data terug
    return $posts;
```

3. Zet de data om naar een RSS feed.
   Met de opgehaalde data moeten we nu [een RSS feed opbouwen](/articles/5-rss-feed-toegevoegd), zoals ik een week of 2 geleden al beschreef. Hiervoor gebruiken we dus weer [thujohn/rss-l4](https://github.com/thujohn/rss-l4).

## Het resultaat
Het resultaat is dat er nu in ongeveer 2 seconden een lijst van ongeveer 40 afleveringen wordt opgehaald. De lijst met afleveringen op [luckymedia.nl](http://luckymedia.nl/) is nog langer maar dat is voor nu even niet interessant, ik wil alleen de nieuwste afleveringen ophalen.

*Dit artikel is inmiddels al een paar jaar oud. Vroeger kon je hier doorklikken naar de RSS-feed met de laatste LuckyTV afleveringen. Nu helaas niet meer, sorry!*