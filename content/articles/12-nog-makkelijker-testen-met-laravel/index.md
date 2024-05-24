---
title: "Nog makkelijker testen met Laravel"
date: 2015-11-07T23:00:00+02:00
draft: false
summary: "In Laravel is het makkelijker dan ooit om geautomatiseerde tests te schrijven. Zo wordt PHPUnit standaard meegeleverd en is de meeste configuratie alvast ingesteld. Toch zijn er nog een aantal dingen die je moet verbeteren voordat je echt makkelijk je tests kunt draaien."
params:
  outdated_warning: true
---
In Laravel is het makkelijker dan ooit om geautomatiseerde tests te schrijven. Zo wordt PHPUnit standaard meegeleverd en is de meeste configuratie alvast ingesteld. Toch zijn er nog een aantal dingen die je moet verbeteren voordat je echt makkelijk je tests kunt draaien.

## Aparte configuratie voor tests
Als je Laravel 5.1 nieuw installeert staan er in `/phpunit.xml` een aantal PHP-variabelen voor je ingesteld. Dat is natuurlijk niet handig voor gevoelige gegevens, die wil je buiten je versiebeheersysteem houden.

Die gegevens wil je dus (net als in de rest van je applicatie) in een [environment-configuratie](http://laravel.com/docs/5.1/installation#environment-configuration) zetten. Maak een bestand `.env.testing.example` en een `.env.testing` aan. Ik heb hierin mijn normale configuratie gekopieerd maar de naam van de database aangepast.

In `/tests/TestCase.php` voeg je vervolgens een regeltje toe om deze configuraties met Dotenv in te lezen:

```php
public function createApplication()
{
    $app = require __DIR__.'/../bootstrap/app.php';

    Dotenv::load(dirname(__DIR__), '.env.testing');

    $app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

    return $app;
}
```

De oude configuratie uit `/phpunit.xml` verwijder je natuurlijk zodat het elkaar niet in de weg zit...

## Vooraf migreren
Ik kies ervoor om mijn test-database vooraf eenmalig te migreren. Je kunt dit ook onderdeel maken van de SetUp-methode van PHPUnit, maar ik vind dat inefficiënt omdat mijn databasestructuur toch niet zo vaak wordt aangepast.

Door vooraf te migreren worden mijn tests iets sneller en aangezien ik vaker de tests draai dan mijn databasestructuur aanpas win ik daarmee tijd.

Maak eerst in `/config/database.php` een nieuwe connectie genaamd `mysql_testing`. In mijn geval is alleen de naam van de database anders dan de standaard connectie. Migreer vervolgens de testing-database met het commando
```bash
php artisan migrate --database=mysql_testing
```

## Standaard transactions
Maak in je tests gebruik van transacties. Transacties zorgen ervoor dat alle wijzigingen in de database aan het einde van de test worden teruggedraaid. Hiermee zorg je ervoor dat:
1. tests elkaar niet beïnvloeden;
2. er geen testdata in de database achterblijft.

Binnen je tests kun je met één makkelijke trait gebruik maken van transacties. Let op dat je deze trait binnen al je TestCases gebruikt.

```php
<?php

use Illuminate\Foundation\Testing\DatabaseTransactions;

class HomepageTest extends TestCase
{
    use DatabaseTransactions;

    public function testHomepage()
    {

        $this->visit(route('home'))
             ->see('Alle artikelen');

    }
}
```

## En nu?
* Lees de officiële documentatie over [testen in Laravel](http://laravel.com/docs/5.1/testing).
* Lees over het [organiseren van je testcases](https://phpunit.de/manual/current/en/organizing-tests.html) in PHPUnit.
* Voeg in `.bash_aliases` een alias toe met <code class="language-bash">alias phpunit='vendor/bin/phpunit'</code>

## Gerelateerde artikelen
* [Updaten naar Laravel 5.1](http://barryvanveen.nl/blog/8-updaten-naar-laravel-5-1)
