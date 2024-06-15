---
title: "My favorite talks from Dutch PHP Conference 2018"
date: 2018-07-07T12:00:00+02:00
draft: false
summary: "On June 7, 8, and 9, the Dutch PHP Conference 2018 was held. Now that all information has settled down, and most talks are available on YouTube, I want to share the talks I liked the most."
types: ['story']
subjects: ['conference', 'php']
params:
  outdated_warning: false
---
On June 7, 8, and 9, the Dutch PHP Conference 2018 was held. Now that all information has settled down, and most talks are available on YouTube, I want to share the talks I liked the most.

## Knowing your state machines

Speaker: [Tobias Nyholm](https://twitter.com/tobiasnyholm).
Links: [YouTube](https://www.youtube.com/watch?v=HZoFn8YI1mI) or [SlideShare](https://www.slideshare.net/TobiasNyholm/knowing-your-state-machines).

State machines are great at... well, at keeping state. This is a very common task in applications.

Take for example a publishing flow for a blog. An article can have the following states:
* draft
* in review
* rejected
* published

And states have connections to other states:
* draft -> in review
* in review -> rejected
* in review -> published
* rejected -> in review

These connections make up an important part of the business logic of the application. State machines allow you to denote this logic in a very clean way.

[Symfony's workflow component](https://symfony.com/doc/current/components/workflow.html) makes it easy to work with state machines and related models. There is also a bridge called [laravel-workflow](https://github.com/brexis/laravel-workflow) to use the component in Laravel projects

## Technically DDD

Speaker: [Pim Elshof](https://twitter.com/Pelshoff).
Links: [YouTube](https://www.youtube.com/watch?v=JpcNeeetijo) or [Slide Deck](https://speakerdeck.com/pelshoff/technically-ddd-v6).

Pim gave a quick primer on Domain Driven Design (DDD). Although it is probably safe to say it as much about OOP as it is about DDD.

The key takeaway for me was the following strategy: make the invalid inexpressible. One of the ways this can be done is by using [Value Objects](https://en.wikipedia.org/wiki/Value_object), Entities and Services: some of the building blocks of DDD.

Then Pim goes on to define a set of simple steps to clean up code:
* Implement in Entity
* Extract a Value Object
* Refactor Value Object

## All aboard the Service Bus

Speaker: [Robert Basic](https://twitter.com/robertbasic).
Links: [YouTube](https://www.youtube.com/watch?v=9UCIR9UnsTo) or [Speaker Deck](https://speakerdeck.com/robertbasic/all-aboard-the-service-bus-2).

In this talk, Robert introduces the service bus and how it allows one to give structure to your application. Three difference buses are discussed:
* The command bus
* The event bus
* The query bus

Then the basic differences between commands and events are explained. Unfortunately, Robert doesn't really go into detail about the query bus.

Together these buses may be used to follow the Command Query Responsibility Separation (CQRS) pattern. Although I've read that it is best to be cautious about applying CQRS, it really got me thinking about separation of concerns and application structure in general.

## Conference social

The last thing I wanted to mention is the conference social. Beforehand I wasn't too sure if this was for me since I didn't know any other attendees. Luckily I did visit the social and it turned out to be really nice.

That is also why I want to give a shout-out to Ian, Tom and Dave from [Bristol (UK)](https://www.lampbristol.com/). They were great company and I thoroughly enjoyed speaking to some like-minded developers and hear they have basically the same drives, hopes, and fears.

Lastly, I wanted to thank the organizers, staff and fellow attendees that made the conference a great event to attend!

## Continue reading...

* [All videos on the Dutch PHP Conference YouTube account](https://www.youtube.com/user/DutchPHPConference/videos).