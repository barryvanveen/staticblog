---
title: "Mijn Git cheatsheet"
date: 2015-12-06T16:45:00+02:00
draft: false
summary: "Eens in de zoveel tijd loop ik tegen een probleem aan met Git. Gelukkig is dat niet zo vaak, maar dat zorgt er wel voor dat ik elke keer opnieuw op zoek moet naar de oplossing voor een probleem dat ik al eerder heb opgelost. Daarom deze lijst met oplossingen die ik kan hergebruiken."
types: ['tutorial']
subjects: ['git', 'versioning', 'cheatsheet']
params:
  outdated_warning: true
---
Eens in de zoveel tijd loop ik tegen een probleem aan met Git. Gelukkig is dat niet zo vaak, maar dat zorgt er wel voor dat ik elke keer opnieuw op zoek moet naar de oplossing voor een probleem dat ik al eerder heb opgelost. Daarom deze lijst met oplossingen die ik kan hergebruiken.

## Mijn cheatsheet

### Een remote tag verwijderen
* Probleem: je hebt een tag gecommit en gepushed en wilt dit ongedaan maken.
* Bron: [https://nathanhoad.net/how-to-delete-a-remote-git-tag](https://nathanhoad.net/how-to-delete-a-remote-git-tag).
* Oplossing:
```bash 
git tag -d naam-van-de-tag
git push origin :refs/tags/naam-van-de-tag
```

### De laatste lokale commit ongedaan maken
* Probleem: je hebt gecommit en komt erachter dat je in de verkeerde branch of erger, in het verkeerde project hebt zitten werken.
* Bron: [http://stackoverflow.com/a/6866485/404423](http://stackoverflow.com/a/6866485/404423).
* Oplossing:
```bash
git reset --hard HEAD~1
```

### Een map of bestand niet meer tracken en toevoegen aan gitignore
* Probleem: je hebt per ongeluk een bestand of bestand opgenomen in een commit die niet in je repository thuishoort. Bijvoorbeeld de project-configuratie van PhpStorm. Je wilt deze map uit Git verwijderen maar niet van je harde schijf.
* Bron: [http://stackoverflow.com/questions/936249/stop-tracking-and-ignore-changes-to-a-file-in-git](http://stackoverflow.com/questions/936249/stop-tracking-and-ignore-changes-to-a-file-in-git).
* Oplossing:
```bash
# voor een bestand
git rm --cached filename.php
# voor een map
git rm -r --cached .idea/
```

### Naam en e-mailadres configureren voor je commits
* Probleem: als je vanaf de command line commit wil je dat jouw naam en e-mailadres netjes vermeldt worden, niet de gebruikersnaam waaronder je toevallig bent ingelogd.
* Bron: [http://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration](http://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration).
* Oplossing:
```bash
git config --global user.name "Barry van Veen"
git config --global user.email "barry@example.org"
```

## Uitchecken van een specifieke commit
* Probleem: je wilt je code terugzetten naar een vorige versie, bijvoorbeeld om te kijken of een bug daarin al aanwezig is.
* Bron: [http://xmodulo.com/how-to-checkout-specific-version-of-git-repository.html](http://xmodulo.com/how-to-checkout-specific-version-of-git-repository.html).
* Oplossing:
```bash
git checkout <checksum_hash>
```

## De remote url aanpassen
* Probleem: je wilt de remote url van een project aanpassen.
* Bron: [https://help.github.com/articles/changing-a-remote-s-url/](https://help.github.com/articles/changing-a-remote-s-url/)
* Oplossing:
```bash
git remote set-url origin https://github.com/USERNAME/REPOSITORY.git
git remote -v # to check new urls
``` 

## Zoeken in geschiedenis van een bestand
* Probleem: je wilt zoeken naar een tekst in de geschiedenis van een bestand
* Bron: [https://stackoverflow.com/questions/10215197/git-search-for-string-in-a-single-files-history](https://stackoverflow.com/a/10216050)
* Oplossing:
```bash
git log -S'query' -- filename.php
```
