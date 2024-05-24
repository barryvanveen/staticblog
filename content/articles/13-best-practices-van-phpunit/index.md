---
title: "Best Practices van PHPUnit"
date: 2015-11-13T18:00:00+02:00
draft: false
summary: "Ik ben aan het proberen mijn code helemaal automatisch te testen met PHPUnit. Daarbij heb ik wat handige dingen geleerd en die wil ik graag met jullie delen."
params:
  outdated_warning: true
---
Ik ben aan het proberen mijn code beter te testen met PHPUnit. Ik maak nu gebruik van verschillende soorten tests:

1. Functionele tests voor het hele globaal testen van pagina's van de website. Bijvoorbeeld "zie ik een blogpost op de homepage en kan ik doorklikken naar de volledige tekst?".
2. Integratie tests om te controleren of mijn repositories de juiste data teruggeven. Bijvoorbeeld "geeft mijn repository alleen maar blogposts terug die gepubliceerd zijn?".
3. Unit tests om elke functie individueel te testen, los van andere code. Bijvoorbeeld "Geeft de UserPresenter de volledige naam van een gebruiker op de juiste manier terug?".

## Best practices
Om dit allemaal een beetje netjes op te zetten ben ik zoek gegaan naar de best practices voor het gebruik van PHPUnit. Als snel kwam ik, zoals zo vaak, terecht op [PHPUnit best practices to organize tests](http://stackoverflow.com/a/8313669/404423).

Een korte samenvatting:
1. Deel je map met tests op in `/functional`, `/integration` en `/unit`.
2. Binnen `/unit` kopieer je de mappenstructuur van je eigen applicatie.
3. Ook alle bestandsnamen zet je over maar je zet er Test achter, dus `/Users/User.php` wordt `/tests/Users/UserTest.php`.
4. Functienamen beginnen `test` en maak je zo beschrijvend mogelijk. Als je een functie `generateSlug()` hebt dan noem je je unit test `testGenerateSlugReturnsCorrectSlug()`, of iets vergelijkbaars.

Het kan natuurlijk zijn dat je verschillende dingen aan een functie wilt unit testen. Maak dan verschillende tests met goed beschrijvende namen of lees de documentatie over [data providers](https://phpunit.de/manual/current/en/writing-tests-for-phpunit.html#writing-tests-for-phpunit.data-providers).

## Aliases
Om het geheel nog wat makkelijker te maken heb ik een aantal aliases aangemaakt in `~/.bash_aliases`. Dit is een beetje afgekeken van [Jeffrey Way](http://laracasts.com/) maar maakt het leven wel zo makkelijk.

Neem de onderstaande aliases over en roep in het vervolg je tests aan met `t` om alle tests uit te voeren of met `tu` om alleen de unit tests te doen.

```bash
alias t='vendor/bin/phpunit'
alias tf='vendor/bin/phpunit tests/functional'
alias ti='vendor/bin/phpunit tests/integration'
alias tu='vendor/bin/phpunit tests/unit'
```

## Gerelateerde artikelen
* [Nog makkelijker testen met Laravel](/articles/12-nog-makkelijker-testen-met-laravel)
