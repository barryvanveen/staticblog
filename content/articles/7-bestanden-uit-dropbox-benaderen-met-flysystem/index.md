---
title: "Bestanden uit Dropbox benaderen met Flysystem"
date: 2015-06-19T22:00:00+02:00
draft: false
summary: "De afbeeldingen die je op deze blog ziet worden direct uit mijn eigen Dropbox-map gehaald. Superhandig want zo kan ik een bestand \"uploaden\" naar mijn webserver door het op mijn eigen computer naar een mapje te slepen."
params:
  outdated_warning: true
resources:
  - name: dropbox-app-aanmaken
    src: 'dropbox-app-aanmaken.png'
    title: "Een Dropbox app aanmaken"
    params:
      alt: "Een Dropbox app aanmaken"
  - name: dropbox-app-details
    src: 'dropbox-app-details.png'
    title: "Dropbox app details bekijken"
    params:
      alt: "Dropbox app details bekijken"
---
De afbeeldingen die je op deze blog ziet worden direct uit mijn eigen Dropbox-map gehaald. Superhandig want zo kan ik een bestand "uploaden" naar mijn webserver door het op mijn eigen computer naar een mapje te slepen.

Ik heb dit voor elkaar gekregen door gebruik te maken van [Flysystem](http://flysystem.thephpleague.com/).  Flysystem is opgezet met als doel een abstractielaag te vormen voor het bestandssysteem. Hierdoor kun je je lokale bestandssysteem makkelijk inwisselen voor een bestandssysteem op afstand zoals [Dropbox](https://www.dropbox.com), [AWS](http://aws.amazon.com/) of [Rackspace](http://www.rackspace.nl/).

Bij het maken van deze functionaliteit moet je de volgende stappen doorlopen:
1. maak een eigen Dropbox-app;
2. installeer en configureer Flysystem en de bijbehorende Dropbox-adapter;
3. zet een bestand in Dropbox en benader dit bestand vanaf de website.

## Een Dropbox-app aanmaken
Voor het aanmaken van een Dropbox-app heb je een account bij Dropbox nodig. Ga vervolgens naar de [App console](https://www.dropbox.com/developers/apps) - een onderdeel van de ontwikkelaars-website van Dropbox.

Kies voor het aanmaken van een app die:
* gebruikmaakt van de Dropbox API;
* alleen toegang heeft tot zijn eigen specifieke map (`/Apps/naam-van-app` in je Dropbox-map).

{{< figure src="dropbox-app-aanmaken" >}}

Deze nieuwe app willen we in Development-status houden, anderen hoeven 'm niet te gebruiken. Noteer nu de volgende codes want die hebben we nodig voor het configureren van Flysystem:
* app key;
* generated access code (eerst even op de knop "Generate" klikken).

{{< figure src="dropbox-app-details" >}}

## Flysystem installeren en de Dropbox-adapter configureren
Om Flysystem te gebruiken binnen Laravel heb ik gekozen voor de [Laravel-Flysystem package](https://github.com/GrahamCampbell/Laravel-Flysystem). Hiermee wordt Flysystem automatisch beschikbaar gemaakt in heel je applicatie. Bovendien zorgt het voor een net configuratiebestand waarmee we alles kunnen instellen. [Flysystem-dropbox](https://github.com/thephpleague/flysystem-dropbox) is de adapter die ervoor zorgt dat we Dropbox kunnen gebruiken als onderliggend bestandssysteem.

Installeer Laravel-Flysystem en Flysystem-dropbox volgens de aanwijzingen op GitHub. Let daarbij op dat je Laravel-Flysystem versie 1.* gebruikt als je met Laravel 4.2 werkt zoals ik.

### Configureer Flysystem
Publiceer het configuratiebestand van Flysystem met
```bash 
php artisan config:publish graham-campbell/flysystem
```

en stel daarin vervolgens ongeveer deze waarden in:
```php
return [
    'default' => 'dropbox',
    'connections' => [
        'dropbox' => [
            'driver' => 'dropbox',
            'token'  => getenv('DROPBOX_TOKEN'),
            'app'    => getenv('DROPBOX_APP'),
            'prefix' => '',
        ],
        'local' => [
            'driver' => 'local',
            'path'   => storage_path(),
        ],
    ],
];
```

In je [environment-bestand](http://laravel.com/docs/5.1#environment-configuration) kun je daarna de configuratie-variabelen toevoegen die we net hebben opgeschreven:
```php
// App key
"DROPBOX_APP"   => "abcabcabcabcabc",
// Generated access token
"DROPBOX_TOKEN" => "abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabca",
```

## Een bestand uit Dropbox benaderen op je website
Als je de stappen tot nu toe hebt doorlopen dan zou je in de Dropbox-map een map `/App/naam-van-je-app` moeten hebben. Plaats hierin een bestand test.txt en zet er wat onzin in.

Open nu een willekeurige controller en plaats daarin de volgende code:
```php
$source = Flysystem::connection('dropbox');
$contents = $source->read('test.txt');
dd($contents);
```

Als je nu de pagina bezoekt die bij deze controller hoort zou je nu de inhoud van je testbestand te zien moeten krijgen. Goed nieuws!

## En nu?
Nu we de koppeling werkend hebben kunnen we deze voor allerlei zaken gebruiken. Op het moment gebruik ik het om de afbeeldingen voor deze blog beschikbaar te maken op mijn webserver, dan hoef ik niet te FTP'en. Binnenkort wil ik het ook gaan gebruiken om makkelijk een backup van mijn database op te slaan.

Kijk ook even naar de [API van Flysystem](http://flysystem.thephpleague.com/api/) want je kunt niet alleen bestanden uitlezen, je kunt ze ook aanmaken, updaten of verwijderen.

Erg handig en makkelijk te herschrijven naar een ander bestandssysteem mocht je daar later behoefte aan hebben :)

