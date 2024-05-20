---
title: "Automatisch inloggen bij Github en Bitbucket"
date: 2015-05-16T12:00:00+02:00
draft: false
summary: "Als je met de command-line van Git werkt dan moet je vaak je wachtwoord invoeren. Dat is op zich wel zo veilig, maar niet heel makkelijk. Gelukkig is er een oplossing: het instellen van SSH keys."
---
Als je je automatisch wilt authenticeren bij diensten als GitHub of BitBucket zul je een SSH key in moeten stellen. Dit is gelukkig erg makkelijk om te doen en bespaart je daarna een hoop typewerk.

## Een SSH certificaat genereren
* Log in op je webserver, bijvoorbeeld met [PuttyTray](https://puttytray.goeswhere.com/).
* Kijk of je al een certificaat op de locatie `~/.ssh/id_rsa` hebt staan.
* Bestaat dat bestand nog niet, genereer dan een nieuw certificaat met onderstaand commando. Kies daarbij voor de standaard bestandslocatie en kies een sterk wachtwoord.
```bash
ssh-keygen -t rsa -C "jouw comment om deze key later te herkennen"
```
* Kopieer de inhoud van `~/.ssh/id_rsa.pub`

## GitHub en BitBucket
* Maak een nieuwe SSH key aan op [Github](https://github.com/settings/ssh), geef deze een herkenbare naam en plak de inhoud van id_rsa.pub in het Key-veld.
* Controleer met <code class="language-bash">ssh -T git@github.com</code> of de SSH key werkt. Je moet nu het wachtwoord van je certificaat invullen. De output moet iets zijn als "*Hi barryvanveen! You've successfully authenticated, but GitHub does not provide shell access.*"
* In BitBucket kun je een SSH key aanmaken door naar je [BitBucket account](https://bitbucket.org/account/) te gaan en links in het menu te kiezen voor "SSH Keys".
* Controleer met <code class="language-bash">ssh -T git@bitbucket.org</code> of de SSH key werkt. Je moet nu het wachtwoord van je certificaat invullen. De output moet ongeveer gelijk zijn aan "*logged in as barryvanveen. You can use git or hg to connect to Bitbucket. Shell access is disabled.*".

## SSH Agent
Het authenticeren bij GitHub en BitBucket werkt nu maar je moet nog wel bij elke handeling het wachtwoord van je certificaat intypen. Dat is natuurlijk niet handig, zo kunnen we nog steeds onze zaakjes niet automatiseren.

Gelukkig heeft GitHub heel handig beschreven [hoe je dit automatiseert](https://help.github.com/articles/working-with-ssh-key-passphrases/#auto-launching-ssh-agent-on-msysgit). Door deze stappen te volgen wordt bij het inloggen automatisch `ssh-agent` gestart en met `ssh-add` het goede certificaat geladen. Je hoeft nu nog maar 1 keer (na het inloggen) het wachtwoord van je certificaat op te geven en kunt daarna lekker verder werken.

## En nu?
Nu je automatisch geauthenticeerd bent als je via SSH communiceert kun je [de remote url van je repository aanpassen](https://help.github.com/articles/changing-a-remote-s-url/#switching-remote-urls-from-https-to-ssh). Als je vanaf dat moment `git pull` of `composer update` uitvoert zul je geen wachtwoord meer nodig hebben, lekker makkelijk!
