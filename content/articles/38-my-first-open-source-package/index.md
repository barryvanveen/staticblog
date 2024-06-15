---
title: "My first open source package"
date: 2017-03-18T17:30:00+02:00
draft: false
summary: "Last week I published my first open source package. This is what I learned while working on it."
types: ['project']
subjects: ['opensource', 'laravel', 'package', 'lastfm']
params:
  outdated_warning: true
---
So, I've wanted to make my own open source package for quite some time. Last week it was registered at Packagist: [barryvanveen/lastfm](https://github.com/barryvanveen/lastfm). It's a simple API client to retrieve data from Last.fm. But I've learned a lot while building this and wanted to share some thoughts.

## Get it out
Probably the hardest part of developing was just getting it out there. It's scary to publish something for the first time. The code can always be more optimal, neater, safer. The readme could be more elaborate, more compact, more clear. And the tests could be better, the code coverage could be higher.

Just being able to publish the code was the biggest hurdle. Now I can use it to show you [what music I listen to](/about/music). Others can use it on their projects.

It was ready to be released for a long time but fear and perfectionism were holding me back.

## Use a skeleton package
Many seasoned package developers have published so-called skeleton packages. It contains everything you need to get started: directory structure, readme, changelog, stuff like that.

I've used [thephpleague/skeleton](https://github.com/thephpleague/skeleton) and it was a great way to kick-start the project.

## Use third party services
Many third party services offer a free account for open source packages. They make your package better and your life easier. Services that have helped me:
* [Travis CI](https://travis-ci.org/barryvanveen/lastfm)
* [Scrutinizer CI](https://scrutinizer-ci.com/g/barryvanveen/lastfm/)

## Look at other packages
During coding and writing tests it is very helpful to have a look at established packages. What setup do they use, how is configuration handled. Do they write tests for their ServiceProvider? If so, how?

I've been looking at [service providers for Laravel](/articles/34-laravel-service-provider-examples) before. This time I was mainly interested in providing a clear interface to end-users and a clear readme.

## Promote your work
As [Ondřej Mirtes](https://medium.com/@ondrejmirtes/how-i-got-from-0-to-1-000-stars-on-github-in-three-months-with-my-open-source-side-project-8ffe4725146#.79sny9qrj) tells in his blog on PHPStan, you have to share and promote your own work. If you don't it will never be found by others, it won't be used and it'll just sit there.

Now, I don't think my Last.fm client will bring forth any life-changing events. But hey, it might just save someone a couple of hours work. And at least I've learned a lot while developing it and had a lot of fun doing it.

<span class="divider"></span>

Check out my [last.fm API client](https://github.com/barryvanveen/lastfm) on GitHub.