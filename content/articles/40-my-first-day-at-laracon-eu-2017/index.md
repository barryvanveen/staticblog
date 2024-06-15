---
title: "My first day at Laracon EU 2017"
date: 2017-08-30T18:00:00+02:00
draft: false
summary: "This is a report of my first day at Laracon EU 2017. I'll describe the talks I saw and what stood out for me."
types: ['story']
subjects: ['laravel', 'conference']
params:
  outdated_warning: false
---
Tuesday the 29th of August, day 1 of Laracon EU 2017. This is my second Laracon and I've been regularly working with Laracon Framework for about 2,5 years now.

Together with 2 colleagues from SWIS we went to Amsterdam and saw some cool talks. It was also nice to feel more connected to the community and see some people in real life.

These are the talks that I attended on the first day.

### [From zero to multi-platform Chatbot with BotMan](https://www.youtube.com/watch?v=4zzSw-0IShE)

[Marcel Pociot](http://marcelpociot.de/) is the developer of BotMan, an open source project that enables you to develop a custom chatbot. BotMan is packaged with many drivers so you can hook it up to Slack, Facebook Messenger or your website, to name just a few.

[BotMan](https://github.com/botman/botman) was introduced to us by creating an example chatbot for ordering pizzas. Beside that technical introduction, Marcel argued that chatbots can play an important part in interacting with your customers. You can use many channels, create a personalized conversation and engage the user in a way that is not possible by relying on, for example, an email.

I thought this was a great talk and found myself finding usages for chatbots for our customers at SWIS.

### [Denormalization With Eloquent: How, Why and When](https://www.youtube.com/watch?v=eh2iXuzBbTc&index=11&list=PLMdXHJK-lGoBFZgG2juDXF6LiikpQeLx2)
This presentation by [Max Brokman](https://github.com/maxbrokman) was about denormalizing records in your database. Max works on internal business intelligence services for Vice and in that role he has to work with lots of data. While normalization of your database is a good practice, there are situations when it is just infeasible because of performance issues.

This is something I've come across in recent project where we had to generate a big report about the purchases, stock, and sales. The query to create these numbers takes somewhere between 10 and 20 seconds. So this is where denormalization can be your friend.

The talk includes some tips about how to approach this with Eloquent. It's not difficult and I thought it was reassuring to know that people involved with data warehousing apply the same solutions as I do.

### [Bruce Lee Driven Development](https://www.youtube.com/watch?v=LV-qXn42o6g&index=19&list=PLMdXHJK-lGoBFZgG2juDXF6LiikpQeLx2)
This was a funny talk by [Jeroen van der Gulik](https://github.com/jeroenvdgulik). Although I thought this talk was a little unstructured it contains some cool advice. The take home message of this talk: "Keep your eyes open and learn from the people around you. Keep the stuff that works for you, loose the stuff that doesn't and add a little of your own to it."

And I learned a lot about Bruce Lee in the process ;)

### [Bad UX is Not an Option: Intuitive Software by being a Better Developer](https://www.youtube.com/watch?v=_kXgWRN7weM&index=8&list=PLMdXHJK-lGoBFZgG2juDXF6LiikpQeLx2)

This inspired talk was given by [Rizqi Djamaluddin](https://rizqi.web.id/). He started off by explaining why he cares about building a great user experience, which I thought was a great story. Then he gave some guidelines for creating a better UX.

The basis should be laid by adding some logging to your application. Log as many stuff as you can: user actions, validation errors, etc. This builds up a great source of information if you want to know something about your end users.

After logging the information you can set out to improve the UX. The main thing that stuck with me? Explain to the user WHY something is happening instead of telling them WHAT is happening. Change your validation message from "Password invalid" to "Because longer passwords are more secure, we only allow passwords with a minimum length of 10 characters. Choose a longer password".

Yeah, it's long, but it explains to your user what you want them to do. And that is something that really helps (less tech-savvy) users out.

### [Laravel Design Patterns](https://www.youtube.com/watch?v=mNl4cMLlplM&index=2&list=PLMdXHJK-lGoBFZgG2juDXF6LiikpQeLx2)

Fellow Dutchman [Bobby Bouwmann](https://github.com/bobbybouwmann) held a talk about software design patterns. There are many patterns so he could only talk about 4 patterns:
* the Factory pattern,
* the Builder pattern,
* the Strategy pattern, and
* the Provider pattern.

By the analogy of a pizza-making-application, Bobby explained each of these patterns. He also showed an example of how the pattern is used in the Laravel core.

Although the talk was a little rushed for my taste, it really made me realize that I have to read up on design patterns. Thanks Bobby for arousing my interest!

### [State of Laravel](https://www.youtube.com/watch?v=2pLL00WR5iU&index=13&list=PLMdXHJK-lGoBFZgG2juDXF6LiikpQeLx2)

And then the last talk of the day. This could only be given by [Taylor Otwell](https://twitter.com/taylorotwell) himself, obviously.

Taylor showed us some code examples of new features coming out in Laravel 5.5, which was actually released today. It was cool to see Taylor "at work" (he types ridiculously quick and accurate).

As Laravel 5.5 was released today I won't go into details about any new features. You can read more at [Laravel news](https://laravel-news.com/laravel-5-5), the [release notes](https://laravel.com/docs/5.5/releases) or the [upgrade guide](https://laravel.com/docs/5.5/upgrade).

## Conclusions
So, that was my first day at Laracon. I had a great time and really liked it. Thanks to the great organization and all speakers!

*26/9 the videos have been released and each title now links to the related talk on YouTube.*