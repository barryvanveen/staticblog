---
title: "Zoekmachineoptimalisatie deel 3: microdata"
date: 2015-09-19T19:00:00+02:00
draft: false
summary: "[Microdata](https://en.wikipedia.org/wiki/Microdata_%28HTML%29) is een manier om de inhoud van je pagina nog duidelijker te maken voor zoekmachines. Met [semantische html](/articles/10-zoekmachineoptimalisatie-deel-2-semantische-html) kun je al aangeven wat de belangrijkste content van een pagina en welke content bij elkaar hoort. Met microdata kun je aangeven wat voor data je content beschrijft. Zo kun je dus aangeven dat een artikel een nieuwsbericht is, of een recept, of één van de duizenden andere mogelijkheden."
types: ['tutorial']
subjects: ['seo', 'microdata']
params:
  outdated_warning: false
resources:
  - name: zoekresultaten-met-microdata
    src: 'zoekresultaten-met-microdata.png'
    title: "Zoekresultaten met microdata"
    params:
      alt: "Zoekresultaten met microdata"
---
[Microdata](https://en.wikipedia.org/wiki/Microdata_%28HTML%29) is een manier om de inhoud van je pagina nog duidelijker te maken voor zoekmachines. Met [semantische html](/articles/10-zoekmachineoptimalisatie-deel-2-semantische-html) kun je al aangeven wat de belangrijkste content van een pagina en welke content bij elkaar hoort. Met microdata kun je aangeven wat voor data je content beschrijft. Zo kun je dus aangeven dat een artikel een nieuwsbericht is, of een recept, of één van de duizenden andere mogelijkheden.

## Microdata en vocabularies
Microdata is een set afspraken om metadata aan html toe te voegen. Je gebruikt daarbij vocabulary om aan te geven om wat voor type metadata het gaat. Van deze vocabularies is [schema.org](https://schema.org) het meest bekend en vrij te gebruiken. Het is echter ook mogelijk om je eigen vocabulary te ontwikkelen en te gebruiken.

## Hoe doe je dat dan?
Als je wilt beginnen met het toevoegen van microdata kun je het beste de [Getting Started-pagina van schema.org](http://schema.org/docs/gs.html) lezen. In het kort komt het hier op neer:

```html
<div itemscope itemtype ="http://schema.org/Movie">
    <h1 itemprop="name">Avatar</h1>
    <div itemprop="director" 
         itemscope itemtype="http://schema.org/Person">

        Director: <span itemprop="name">James Cameron</span> (born <span itemprop="birthDate">August 16, 1954</span>)

    </div>
    <span itemprop="genre">Science fiction</span>
    <a href="../movies/avatar-theatrical-trailer.html"
       itemprop="trailer">Trailer</a>
</div>
```

* Met `itemscope` en `itemtype` geen je aan wat voor soort data een element beschrijft. De `itemtype` is daarbij een link naar je schema. De html hierboven beschrijft dus een film.
* Op [http://schema.org/Movie](http://schema.org/Movie) kun je lezen wat de mogelijke eigenschappen van een film zijn. Deze kun je vervolgens specificeren door de bijbehorende elementen van je html een `itemprop` te geven. De html hierboven bevat dus een titel, een regisseur, een genre en een trailer.
* Het is mogelijk om de verschillende soorten content hiërarchisch te ordenen. De regisseur van de film is namelijk tegelijkertijd een persoon. Dat element is dus op zichzelf een `itemscope` van het type [http://schema.org/Person](http://schema.org/Person). En een persoon heeft weer zijn eigen eigenschappen die je dan kunt specificeren, zoals een naam en een geboortedatum.

## Wat heb ik gedaan?
Deze website maakt op het moment gebruik van 3 verschillende schema's.

1. Op /articles staat een [Blog](https://schema.org/Blog) met daarbinnen de verschillende [BlogPostings](https://schema.org/BlogPosting).
2. Elk artikel is weer een [BlogPosting](https://schema.org/BlogPosting) op zichzelf, alleen kunnen er dan meer eigenschappen worden aangegeven.
3. De andere tekstpagina's, zoals de pagina met meer [informatie over wie ik ben](https://barryvanveen.nl/about), zijn een [WebPage](https://schema.org/WebPage). Dit is zo ongeveer het meest generieke element en voegt niet zo veel toe. Maar ach, ik was toch al bezig.

## Mooiere resultaten in Google's zoekresultaten
Google (en andere zoekmachines) gebruiken microdata om je website beter te indexeren. Maar als je het echt goed toepast dan worden je zoekresultaten bij Google ook veel mooier weergegeven. Als je alle benodigde velden vult (vaak is daarbij een afbeelding verplicht) dan heb je kans dat jouw website ongeveer zo in de zoekresultaten verschijnt:

{{< figure src="zoekresultaten-met-microdata" >}}

In Google's [Structured Data Testing Tool](https://developers.google.com/structured-data/testing-tool/) heb je een mogelijkheid om je microdata te laten controleren. Let op, Google stelt strengere eisen aan de microdata die je moet toevoegen. Een afbeelding is volgens hen bijvoorbeeld verplicht voor een BlogPosting. Dit is niet echt zo, maar pas als je een afbeelding toevoegt kom je mooier in de zoekresultaten te staan.
