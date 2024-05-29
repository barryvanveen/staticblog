---
title: "Hoe filter je referral spam uit Google Analytics?"
date: 2015-06-06T20:00:00+02:00
draft: false
summary: "Bij het runnen van een website hoort ook dat je wat statistieken verzamelt. Helaas worden de statistieken van Google Analytics de laatste tijd vervuild door spammers die hopen dat je naar hun website doorklikt. Om mijn statistieken weer overzichtelijk te maken heb ik uitgezocht hoe je de spam-bezoekers weg kunt filteren."
types: ['tutorial']
subjects: ['analytics', 'spam', 'seo']
params:
  outdated_warning: true
resources:
  - name: GA-filter-blokkeer-campagnebron
    src: 'GA-filter-blokkeer-campagnebron.png'
    title: "Google Analytics filter op campagnebron"
    params:
      alt: "Google Analytics filter op campagnebron"
  - name: GA-filter-mijn-hostnamen
    src: 'GA-filter-mijn-hostnamen.png'
    title: "Google Analytics filter op hostnamen"
    params:
      alt: "Google Analytics filter op hostnamen"
  - name: GA-gefilterd-doelgroepoverzicht
    src: 'GA-gefilterd-doelgroepoverzicht.png'
    title: "Doelgroepoverzicht voor en na filters"
    params:
      alt: "Doelgroepoverzicht voor en na filters"
  - name: GA-lijst-met-verwijzingen-en-hostnamen
    src: 'GA-lijst-met-verwijzingen-en-hostnamen.png'
    title: "Lijst met verwijzingen en bijbehorende hostnamen in Google Analytics"
    params:
      alt: "Lijst met verwijzingen en bijbehorende hostnamen in Google Analytics"
---

Bij het runnen van een website hoort ook dat je wat statistieken verzamelt. Helaas worden de statistieken van Google Analytics de laatste tijd vervuild door spammers die hopen dat je naar hun website doorklikt. Om mijn statistieken weer overzichtelijk te maken heb ik uitgezocht hoe je de spambezoekers weg kunt filteren.

## Wat is referral spam?
Er zijn al talloze artikelen geschreven over wat referral spam is, dus dat verhaal zal ik hier niet opnieuw opschrijven. Lees bijvoorbeeld op [FrankWatching](http://www.frankwatching.com/archive/2015/05/06/ruim-je-google-analytics-op-zo-kom-je-af-van-spamverwijzingen/) of op [Partner in Content](http://www.partnerincontent.nl/web-analytics/google-analytics-referral-spam-blokkeren-verwijderen/) meer over waar die spam vandaan komt, wat het doel erachter is en waarom je er niet blij van wordt.

## Blokkeren die handel
Wat mij in alle artikelen over referral spam vooral opvalt is dat er heel veel verschillende manieren worden besproken om van de spam af te komen. Sommige van die manieren klinken nogal dom, zoals het aanleggen van een zwarte lijst voor al je verwijzingsverkeer (websites die naar jouw website linken). Zo'n lijst bijhouden kost je erg veel tijd omdat je 1 voor 1 alle spammers op moet zoeken en uitsluiten.

Gelukkig zijn er iets betere manieren te bedenken waarmee je met simpele stappen het grootste gedeelte van de spammers uit je statistieken filtert. Deze aanpak gebruik ik nu ongeveer 2 weken en in die tijd heb ik 75 van de 78 spam-verwijzingen weten te blokkeren.

Hieronder de filters die ik daarvoor in Google Analytics heb ingesteld.

### Filter op hostnaam
De eerste stap is het blokkeren van alle bezoekers (of nepbezoekers, want die zitten er dus ook tussen) die geen geldige hostnaam meesturen. Hiervoor moet je vooral zelf even uitzoeken welke domeinnamen jouw website gebruikt en dan kun je het filter op de volgende manier instellen:

{{< figure src="GA-filter-mijn-hostnamen" >}}

Hierbij vul ik als filterpatroon de volgende waarde in: `(www\.)?barryvanveen\.nl|translate\.googleusercontent\.com`

Dit filter zorgt er dus voor dat alleen bezoekers met 1 van de volgende hostnamen worden opgenomen in de statistieken:
* barryvanveen.nl
* www.barryvanveen.nl
* translate.googleusercontent.com

### Filter overgebleven individuele spammers
Met het eerste filter kunnen we alle domme spammers al uitsluiten. Er zijn echter ook wat slimmere mensen die wel een valide hostnaam meesturen. Helaas zit er niets anders op dan deze bezoekers met een individueel filter uit te sluiten. Gelukkig zijn dat er in de meeste gevallen maar een paar, dus dat is niet heel veel werk.

Om op te zoeken welke domeinen je moet blokkeren ga je naar Acquisitie, Alle verkeer en Verwijzingen. Vervolgens stel je als secundaire dimensie "Hostnaam" in. In de onderstaande lijst zie je alle spamdomeinen die doen alsof ze naar mijn website verwijzen:

{{< figure src="GA-lijst-met-verwijzingen-en-hostnamen" >}}

Nu is het zaak om per gevonden spamdomein een filter aan te maken op de volgende manier:

{{< figure src="GA-filter-blokkeer-campagnebron" >}}

## Het resultaat
We hebben nu dus 4 filters aangemaakt en het resultaat mag er zijn. In mijn ongefilterde Google Analytics-weergave lijkt het alsof ik de afgelopen twee weken 386 bezoekers heb gehad. Na het toepassen van alle filters blijkt dat er daarvan maar 25 echte bezoekers overblijven.

Hieronder een grafiekje van het originele aantal bezoekers (blauw) en het gefilterde aantal bezoekers (oranje):

{{< figure src="GA-gefilterd-doelgroepoverzicht" >}}

Het zou natuurlijk geweldig zijn als ik echt 400 bezoekers per maand zou mogen ontvangen maar ik vind het nog veel belangrijker om een realistisch beeld te krijgen. Bovendien moet je je niet blindstaren op die bezoekersaantallen, [ik heb me juist voorgenomen om voor mijn eigen plezier te bloggen](/articles/1-waarom-deze-blog) ;-)

## En dan?
Na het instellen van deze filters is het natuurlijk zaak om dit te onderhouden. Dus maak een bladwijzer van je overzicht met verwijzingen en hostnamen, neem elke paar weken een kijkje en vul de lijst met geblokkeerde domeinnamen aan. Als het goed is zijn je statistieken nu veel betrouwbaarder en kun je binnen een paar minuten je filters bijwerken.