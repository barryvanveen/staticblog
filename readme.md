# barryvanveen.nl 

Source code for blog at [barryvanveen.nl](https://barryvanveen.nl). Static site generated using [Hugo](https://gohugo.io/).

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