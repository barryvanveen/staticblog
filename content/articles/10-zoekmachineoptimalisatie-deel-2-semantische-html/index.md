---
title: "Zoekmachineoptimalisatie deel 2: semantische html"
date: 2015-07-25T19:00:00+02:00
lastmod: 2024-05-24T21:15:00+02:00
draft: false
summary: "Vorige week schreef ik over het [maken van een sitemap](/articles/9-zoekmachineoptimalisatie-deel-1-hoe-genereer-je-een-sitemap-xml). Deze week wil ik het hebben over een andere aanpak waardoor zoekmachines je website beter kunnen indexeren, namelijk door gebruik te maken van semantische (beschrijvende) HTML. Met HTML5 tags zoals `<article>`, `<section>` en `<main>` kun je heel goed aangeven wat de belangrijkste inhoud van een pagina is."
types: ['tutorial']
subjects: ['seo', 'semantic', 'html', 'html5']
params:
  outdated_warning: false
---
Vorige week schreef ik over het [maken van een sitemap](/articles/9-zoekmachineoptimalisatie-deel-1-hoe-genereer-je-een-sitemap-xml). Deze week wil ik het hebben over een andere aanpak waardoor zoekmachines je website beter kunnen indexeren, namelijk door gebruik te maken van semantische (beschrijvende) HTML. Met HTML5 tags zoals `<article>`, `<section>` en `<main>` kun je heel goed aangeven wat de belangrijkste inhoud van een pagina is.

## Wat is semantische HTML?
Semantiek gaat over de betekenis van woorden en woordgroepen. Semantische HTML is dus HTML die betekenis geeft aan de inhoud van de HTML-tags. Neem de volgende 2 voorbeelden:

```html
<!-- voorbeeld 1 -->
<div class="blog-item">
    <div class="blog-item__heading">Titel van mijn artikel</div>
    <p class="blog-item__content">Dit is de inhoud</p>
</div>
```

```html
<!-- voorbeeld 2 -->
<article class="blog-item">
    <h1 class="blog-item__heading">Titel van mijn artikel</h1>
    <p class="blog-item__content">Dit is de inhoud</p>
</div>
```

Het eerste voorbeeld bevat geen beschrijvende html-tags. Wij hebben nog wat houvast aan de CSS-classes die gebruikt worden maar zoekmachines gebruiken deze informatie niet. Uit het eerste voorbeeld is het dus erg moeilijk om automatisch te bepalen wat de belangrijkste inhoud van een pagina is.

In het tweede voorbeeld kunnen we duidelijk herkennen dat dit een artikel is. Hoe rommelig de rest van de html ook is, een zoekmachine kan heel makkelijk achterhalen dat dit belangrijke content is. Bovendien is binnen het artikel aangegeven wat de belangrijkste titel is. De rest van de tekst is automatisch de inhoud van het artikel.

## HTML5, dat is er toch al even?
Wat je hierboven in het tweede voorbeeld ziet is een heel erg eenvoudig voorbeeld van [HTML5](http://www.w3.org/TR/html5/). Die standaard  bestaat inmiddels al weer een tijdje maar je bent niet verplicht het te gebruiken. Voorbeeld 1 is valide HTML, het is gewoon niet zo optimaal. Daarom werd het hoog tijd dat ik eens naar html van deze blog ging kijken.

Ik heb daarvoor vooral gekeken naar de [uitgebreide specificatie van het W3C](http://www.w3.org/html/wg/drafts/html/master/semantics.html). Interessant leesvoer, ook als je dit al vaker hebt gedaan. Het zit boordevol met obscure elementen en uitgebreide voorbeelden.

## Welke elementen gebruik ik voor de verschillende pagina's?
Na wat gepuzzel ben ik uiteindelijk op de volgende opbouw uitgekomen voor de verschillende pagina's.

### De layout
```html
<body>
    <header>
        <nav>
            <ul>
                <li>Link in hoofdmenu</li> 
            </ul>
        </nav>
    </header>
    ...
    // content van de website, zie hieronder
    ...
    <footer>
        <ul>
            <li>Linkjes in footer</li>
        </ul>
    </footer>
</body>
```
Uitdrukkelijk geen nav-tag in de footer omdat het geen belangrijk navigatie-element is. Het is nu dus semantisch een lijst met linkjes, en zo wil ik het ook.

### De homepage
```html
<section>
    <h1>Alle artikelen</h1>
    <article>
        <header>
             <h1>Titel van artikel</h1>
             <p>Publicatiedatum</p>
        </header>
        <p>Samenvatting van artikel</p>
        <footer>
             <a>Link naar volledig artikel</a>
        </footer>
    </article>
    ...
    // meer samenvattingen van artikelen
</section>
```
De homepage bevat een section-tag met de titel "Alle artikelen". Die titel omschrijft dus de inhoud van de sectie. Verder is elk artikel gevat in een article-tag.

Hierover bestaat wat discussie, sommige mensen vinden dat je een [lijst met blockquotes](http://stackoverflow.com/questions/4501834/whats-the-best-html5-tag-to-use-for-marking-up-blog-excerpts) moet maken omdat een samenvatting van een artikel niet een echt artikel is. Je moet dus eigenlijk het volledige artikel quoten. Dit stuk van de specificatie is op meerdere manieren uit te leggen en omdat de meeste websites wel de article-tag gebruiken heb ik ook daarvoor gekozen.

Verder heeft elk artikel een eigen header-tag die alle meta-achtige informatie (titel + publicatiedatum) groepeert. Op eenzelfde manier groepeert de footer-tag ook meta-informatie, namelijk de link naar het volledige artikel.

### Een blogpost
```html
<main>
    <article>
        <header>
             <h1>Titel van artikel</h1>
             <p>Publicatiedatum</p>
        </header>
        <p>Volledige tekst van artikel</p>
    </article>
</main>
```
Op de pagina van een individuele blogpost wordt het artikel omringt door de main-tag. Dit geeft aan dat deze content uniek is voor deze URL. Verder is de indeling hetzelfde als voor de samenvatting op de homepage, al is de inhoud wat langer.

In de inhoud van het artikel gebruiken ik de headings h2 en lager, de h1 is gereserveerd voor de titel. Verder worden afbeeldingen ingevoegd met  [figure](http://www.w3.org/html/wg/drafts/html/master/semantics.html#the-figure-element)- en [figcaption](http://www.w3.org/html/wg/drafts/html/master/semantics.html#the-figcaption-element)-tags.

## Een pagina
```html
<main>
    <article>
        <header>
             <h1>Titel van de pagina</h1>
        </header>
        <p>Tekst van pagina</p>
        <footer>
             <p>Datum van laatste aanpassing</p>
        </footer>
    </article>
</main>
```
Op een tekstpagina wordt ook weer gebruik gemaakt van een main-tag omdat het hier over unieke content gaat. Een article-tag bevat de belangrijke informatie waarbinnen een header- en footer-tag de meta-data groeperen.

## En nu?
Nu de globale opzet van de HTML weer netjes is gemaakt wil ik me gaan verdiepen in [microdata](http://www.w3.org/TR/microdata/). Daarmee kan ik nog duidelijke aangeven wat voor informatie een stuk HTML beschrijft.
