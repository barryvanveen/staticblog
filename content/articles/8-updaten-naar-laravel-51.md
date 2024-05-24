---
title: "Updaten naar Laravel 5.1"
date: 2015-07-13T00:00:00+02:00
draft: false
summary: "Op 9 juli is [Laravel 5.1](http://laravel.com/docs/5.1) uitgekomen, een belangrijke nieuwe release. Dit is de eerste Long Term Support (LTS) versie van Laravel, wat betekent dat er 3 jaar ondersteuning zal zijn in de vorm van beveiligingsupdates. Niet alleen dat, versie 5 biedt veel nieuwe functies ten opzichte van versie 4.2 waar deze blog nog op draaide. Tijd dus om te updaten, maar dat blijkt een flinke klus..."
params:
  outdated_warning: true
---
Als het goed is heb je er niets van gemerkt maar deze blog draait sinds vandaag op de nieuwste versie van Laravel. In dit stuk wil ik graag samenvatten waarom je de overstap naar Laravel 5.1 zou moeten maken en hoe je dat voor elkaar krijgt.

## Long Term Support
Laravel 5.1 is de eerste Long Term Support (LTS) versie van Laravel. Dit betekent dat er 3 jaar lang beveiligingsupdates worden uitgegeven. Niet toevallig maakt Laravel 5.1 gebruik van Symfony 2.7, wat ook een LTS-versie is.

Dit maakt dat je deze versie met een veilig gevoel een paar jaar kunt blijven gebruiken. Als je dus niet mee hoeft te lopen met de nieuwste versies, of domweg geen tijd/geld hebt om te blijven updaten, dan kun je er het beste voor kiezen om 5.1 te gaan gebruiken. De oudere versies zullen namelijk niet (of nauwelijks) meer onderhouden worden en zijn daarom minder geschikt.

## Nieuwe functionaliteiten
Maar het feit dat er nu langer ondersteuning zal zijn is natuurlijk niet het enige voordeel van updaten. Versie 5.0 en 5.1 introduceren ook een hoop nieuwe functionaliteiten die ik graag wil gebruiken. De (voor mij) belangrijkste nieuwe functies zijn:

* ingebouwde [validatie](http://laravel.com/docs/5.1/validation) van requests
* ingebouwde ondersteuning van [Flysystem](/articles/7-bestanden-uit-dropbox-benaderen-met-flysystem)
* ingebouwde [command bus](http://laravel.com/docs/5.1/queues#writing-job-classes)

Daarnaast is er nog het feit dat Laravel nu de PSR-2 codestyle aanhoudt, waar ik erg fan van ben. De documentatie is compleet herschreven en de mappenstructuur is op zijn kop gezet maar wel een stuk overzichtelijker geworden.

Dit is echter lang niet alles. Matt Stauffer heeft mooie series geschreven over [nieuwe features in 5.0](https://mattstauffer.co/blog/series/new-features-in-laravel-5.0) en [nieuwe features in 5.1](https://mattstauffer.co/blog/series/new-features-in-laravel-5.1) dus daar kun je uitgebreid verder lezen.

## Upgraden
Bij het upgraden heb ik gebruik gemaakt van wederom een mooie blogpost van Matt Stauffer: [Upgrading from Laravel 4 to Laravel 5](https://mattstauffer.co/blog/upgrading-from-laravel-4-to-laravel-5).

Het probleem zit hem helaas in een van de eerste stappen: de packages in composer.json updaten. Hoewel deze blog maar weinig afhankelijkheden heeft moest ik toch 3 packages vervangen omdat ze (nog) geen ondersteuning hebben voor de nieuwe versie van Laravel.  Dit zorgt voor een hoop werk omdat je a) op zoek moet naar een goede vervangende package en b) je code moet omschrijven naar die nieuwe package.

Na het updaten van composer.json is het een groot knip- en plakfestijn. Alle bestanden die je hebt mag je gaan verplaatsen naar hun nieuwe plek in de aangepaste mappenstructuur. Vervolgens pas je de namespace aan, hernoem je sommige zaken (*commands* heten nu bijvoorbeeld *jobs*) en stel je de configuratie opnieuw in.

Daarnaast moest ik dus mijn validatie, Dropbox-afhankelijke code en command bus-afhankelijke code omschrijven naar de nieuwe functies van Laravel. Al met al een hoop werk waar ik best lang mee bezig ben geweest. En ik snap achteraf wel waarom want ik heb bij de update 339 verschillende bestanden aangepast.

## En nu?
Nu de code weer eens flink opgeschoond is en van de laatste snufjes voorzien kan ik weer nieuwe shizzle maken. De komende weken wil ik wat zoekmachine-optimalisaties doorvoeren. Verwacht dus wat verhaaltjes over sitemaps, meta-tags en het juiste gebruik van HTML5 tags.
