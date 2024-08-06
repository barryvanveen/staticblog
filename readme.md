# 

Personal blog that will replace [barryvanveen/blog](https://github.com/barryvanveen/blog/). The old blog is build using PHP and dynamic, which creates lots more overhead to maintain. I guess that a static blog will be much faster and less maintainence.

So, this new version is build in Hugo and totally static.

# Requirements

* [Hugo](https://gohugo.io/installation/).
* [NodeJS](https://nodejs.org/en) >= v18.

## Getting started

* Install npm dependencies with `npm ci`.
* Serve and live-reload with `hugo server`

## Environment secrets

### Local

* Copy `.env.example` to `.env`
* Run `export $(xargs <.env)`
* Start hugo with `hugo server (--disableFastRender)`

### Production

Make sure the following environment secrets are available:
* `HUGO_LASTFM_USERNAME`
* `HUGO_LASTFM_API_KEY`