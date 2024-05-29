---
title: "Een goede workflow voor Git"
date: 2015-11-21T15:00:00+02:00
draft: false
summary: "Ik werk nu ongeveer een jaar met Git en het is me hartstikke goed bevallen. Het geeft veel meer mogelijkheden om samen aan software te bouwen dan bijvoorbeeld SVN, wat ik daarvoor gebruikte. Maar die vrijheid vraagt ook weer om een bepaalde structuur. En dat is waar Gitflow het leven heel veel makkelijker maakt."
types: ['tutorial']
subjects: ['git', 'workflow', 'gitflow', 'versioning']
params:
  outdated_warning: true
resources:
  - name: gitflow-workflow
    src: 'gitflow-workflow.png'
    title: "Gitflow branching model"
    params:
      alt: "Gitflow branching model"
---
Ik werk nu ongeveer een jaar met Git en het is me hartstikke goed bevallen. Het geeft veel meer mogelijkheden om samen aan software te bouwen dan bijvoorbeeld SVN, wat ik daarvoor gebruikte. Maar die vrijheid vraagt ook weer om een bepaalde structuur. En dat is waar Gitflow het leven heel veel makkelijker maakt.

## Een duidelijke structuur
Omdat Git het zo makkelijk maakt om met branches te werken kan het al snel een rommeltje worden. Slimme mensen, zoals [Vincent Driessen](http://nvie.com/about/), hebben daarom een workflow bedacht om goed met die branches om te gaan.

{{< figure src="gitflow-workflow" >}}

Zijn idee, de [Gitflow workflow](http://nvie.com/posts/a-successful-git-branching-model/), is iets dat ik langere tijd in de praktijk gebruik. Het werkt erg lekker maar het is wel veel werk. Je moet consequent blijven in je naamgeving en de tijd en manier waarop je branched en merged.

## Gitflow
Gelukkig is er ook daar een oplossing voor: [gitflow](https://github.com/nvie/gitflow). Het is een extensie op de Git command line waarmee je het aanmaken en mergen van branches kunt automatiseren. Er zijn commando's om te werken met feature-, hotfix-, en release-branches.

Met een simpel commando kun je een feature-branch starten of weer mergen:
```bash
git flow feature start <naam-van-je-feature>
git flow feature finish <naam-van-je-feature>
```

De output van het commando is erg fijn, je ziet precies wat er is gebeurd.
```bash
vagrant@homestead:~/Code/barryvanveen$ git flow feature start pagination
Switched to a new branch 'feature/pagination'

Summary of actions:
- A new branch 'feature/pagination' was created, based on 'develop'
- You are now on branch 'feature/pagination'

Now, start committing on your feature. When done, use:

     git flow feature finish pagination
```

## Lees verder
Lees voor een uitgebreide introductie vooral ook de blogpost [Using git-flow to automate your git branching workflow](http://jeffkreeftmeijer.com/2010/why-arent-you-using-git-flow/).