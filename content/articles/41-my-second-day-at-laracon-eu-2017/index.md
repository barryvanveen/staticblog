---
title: "My second day at Laracon EU 2017"
date: 2017-08-31T00:00:00+02:00
draft: false
summary: "In this post, I give an overview of my second day at Laracon EU 2017. I'll describe the presentations I've seen and things that stood out for me."
types: ['story']
subjects: ['laravel', 'conference']
params:
  outdated_warning: false
---
Oh, how the weather can change! Yesterday it was 28 degrees Celsius, sunny and we were sweating because of a broken airconditioning (which was fixed and compensated by free ice cream, just so you know). Today it was 16 degrees and raining constantly. Luckily the venue was dry and they had some great coffee!

These are the 6 talks I attended on the second day of Laracon, with a bonus surprise announcement at the end.

### 1) [Project Triage: What to Do When Everything Hits the Fan](https://www.youtube.com/watch?v=arE2x74-RK4&index=14&list=PLMdXHJK-lGoBFZgG2juDXF6LiikpQeLx2)

[Eryn O'neil](https://twitter.com/eryno) has been working for an agency for many years and has seen stuff fail, and she learned from it. Problems can be split up into project-problems and tech-problems. The Project-problems need empathy and good communication to understand each other and overcome any misunderstandings. The Tech-problems are best solved by making a plan up front, keeping calm and keeping checklists where appropriate.

Although for me she was putting too much emphasis on the developer-vs-human-being part, which I find very degrading, it was fun and informative talk. I'll definitely think about this when I hit my next Project-problem and I'll start preparing for my next Tech-problem.

### 2) [Building a realtime dashboard with Laravel, Vue and Pusher](https://www.youtube.com/watch?v=jtB_rTh61Zo&index=7&list=PLMdXHJK-lGoBFZgG2juDXF6LiikpQeLx2)

[Freek van der Herten](https://murze.be/), and his company Spatie, are celebrities in the Laravel ecosystem. Mainly because of their many open source packages, but also for their talks at Laracon.

In this presentation, Freek gave a walkthrough of their homemade [dashboarding website](https://github.com/spatie/dashboard.spatie.be) for in the Spatie office. Laravel is used to retrieve all the bits of data that are displayed on the tiles of the dashboard. Pusher is used to setup a websocket connection and send updates over that connection. Vue.js is used to build the frontend tiles in the dashboard and update each tile as updates are coming in over the websocket connection.

Personally, I really liked the walk-through of the Vue.js components as I am not really familiar with Vue, yet. You should definitely check out [Pusher](https://pusher.com/) if you don't know it already. They make it crazy simple to setup a real-time connection between your backend and frontend and it allows you to build some super cool stuff!

### 3) [Debugging Design: 5 simple design principles to make your UI "not look terrible"](https://www.youtube.com/watch?v=9z61670MVQo&index=16&list=PLMdXHJK-lGoBFZgG2juDXF6LiikpQeLx2)

How to make my UI not look terrible? Shut up and take my money! :')

[Laura Elizabeth](http://lauraelizabeth.co/) is an independent designer that wants to teach developers how to make better looking UI's. Her 5 simple principles are based around choosing the correct colors and fonts. Then you should pick a nice layout and add sufficient padding. At the end, you can add some flair to make things shiny.

What I liked was that each step was accompanied by some rules of thumb and she shared many great websites that help you make better choices. For example, [palleton.com](http://paletton.com/) can help you pick better colors.

Her #1 tip: don't stop if your first attempts don't lead to immediate results. Keep trying and eventually you will see improvements and get better at spotting correct design choices.

### 4) [Building your API with Apiary & Dredd](https://www.youtube.com/watch?v=bBxTGmF7kP4&index=12&list=PLMdXHJK-lGoBFZgG2juDXF6LiikpQeLx2)

After the lunch break Dries Vints introduced us to building API's using API Blueprint, Dredd, and Apiary. It is one of the possible workflows and it might not be for everybody, but he showed some cool stuff that many projects can benefit from.

[API Blueprint](https://apiblueprint.org/) is a method of describing the specifications of your API. Its syntax is Markdown-like and very readable, which I think is pretty awesome. Using [Dredd](https://github.com/apiaryio/dredd) you can test your implementation of the API against the API Blueprint specification.

The first (and for me the most obvious benefit) is that the specification is easily and automatically translated into documentation about the API. Secondly, this is a framework- and language-agnostic style of describing your API. So it works the same for Laravel and Drupal, for PHP and Python.

I still don't really get what [Apiary](https://apiary.io/) exactly is. It seems to be a collaboration tool for developing API's. But Dries was very enthusiastic about it so it probably worth a closer look!

### 5) [Stop listening to the internet](https://www.youtube.com/watch?v=DCmX4ahF8sM&index=5&list=PLMdXHJK-lGoBFZgG2juDXF6LiikpQeLx2)

So I must admit: after two days of sitting and listening I was getting a little tired and just a little bit sleepy. I haven't been paying enough attention to the talk by Femke van Schoonhoven, and that's a shame. Sorry [Femke](https://twitter.com/femkesvs)!

Because this talk was a little different from most. To me, it had a self-help-vibe to it, but in a good way. It is really easy to get overwhelmed by "the way things go" and "the things you should do" in day-to-day life. You should learn JavaScript Framework Foo, you should know this new tool Bar, have you heard of this new Virtualization technology to build your own development server? It's overwhelming and stressful and it is good to point out that everybody has these problems. I know I do!

Femke has some great stories that put all these things in a different perspective, and that is really refreshing to hear. Especially since all the other talks are centered about stuff that you should be doing. Highly recommended!

### 6) [Inside Vue Components](https://www.youtube.com/watch?v=wZN_FtZRYC8&index=6&list=PLMdXHJK-lGoBFZgG2juDXF6LiikpQeLx2).

Evan You, the creator of the Vue.js framework was to give the closing talk of the conference. Vue makes use of Single File Components. These files have the .vue file extension and contain 3 parts: a template (html), some behavior (javascript/typescript) and styles (css).

Traditionally these files were separated and Evan talked about why this changed and what advantages it has. After that he dove deeper into the inner workings of Vue and how the different components are all processed so it can be interpreted by browsers.

If you want to know more about the inner workings of Vue, this talk is really good. Topics that are touched are WebPack loaders, how Vue enables hot reloading of components and why it doesn't use Native Web Components.

### But wait! There is more!

So at the end of the conference (or should I say: at the beginning of the after party?), Shawn McCool had a special announcement to make: Laravel is going to offer [official certification for Laravel developers](https://laravel.com/certification/).

Pre-registrations are being offered at a discounted price, so maybe that is the reason that the website seems to be offline at the moment. This stuff seems to be really fresh and the details need to be filled in a bit. From what I've seen so far this seems like a great new extension of the Laravel community!

## Conclusion
I've had a great time at Laracon and learned a ton of new things. The atmosphere and the venue were also great so it was a very pleasant experience. I highly recommend it to everyone. Thanks for the organization and the speakers for offering this great event!

*23/9 all videos have been added, click on the title to see the talk on YouTube.*