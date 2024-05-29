---
title: "Uitgaande links bijhouden in Google Analytics"
date: 2015-11-27T14:30:00+02:00
draft: false
summary: "Je kunt zelf events registreren bij Google Analytics. Dit stelt je in staat om bijvoorbeeld te meten op welke uitgaande links je bezoekers klikken. In dit artikel leg ik uit hoe dat werkt."
types: ['tutorial']
subjects: ['analytics', 'tracking', 'seo']
params:
  outdated_warning: true
---
Je kunt in Google Analytics zelfs events registreren. Hiermee kun je gebeurtenissen tracken die normaal gesproken niet zichtbaar zijn. Op deze manier kun je bijhouden op welke uitgaande links je bezoekers klikken, maar bijvoorbeeld ook of een gebruiker een video heeft afgespeeld of een contactformulier heeft ingevuld.

## Voorwaarden
* Ik ga er in dit artikel van uit dat je gebruikt maakt van de [nieuwe Google Analytics tracking code](https://support.google.com/analytics/answer/4457764).
* Ik maak gebruik van jQuery.

## De javascript

```javascript
// voer dit script uit na het laden van het document
$('document').ready(function(){

    // voer deze functie uit bij elke klik
    $(window).click(function(e) {

        // stop als er niet op een link is geklikt
        if (e.target.nodeName != 'A') {
            return;
        }

        // stop als dit geen uitgaande link is
        if (e.target.href.indexOf(location.host) == -1) {
            return;
        }

        // schiet een event in met de volgende gegevens:
        //   categorie: outbound
        //   actie: click
        //   label: <de url van de link>
        // als het event is geregistreerd sturen we de bezoeker door naar de juiste url
        ga('send', 'event', 'outbound', 'click', e.target.href, {'hitCallback':
            function () {
                document.location = e.target.href;
            }
        });

    });
});
```

## De statistieken
De geregistreerde events kun je in Google Analytics terugvinden onder Gedrag -> Gebeurtenissen -> Overzicht. Onder de gebeurtenislabels zie je welke linkjes zijn aangeklikt.

## Verder lezen
* Meer informatie over [gebeurtenissen in Google Analytics](https://support.google.com/analytics/answer/1033068).
* Met dank aan de blogpost [track outbound links with Google Universal Analytics.js](http://www.axllent.org/docs/view/track-outbound-links-with-analytics-js/).  Ik heb de code die zij beschrijven wat leesbaarder gemaakt en omgeschreven naar jQuery.
