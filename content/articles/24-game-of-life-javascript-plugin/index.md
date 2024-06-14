---
title: "Game of Life Javascript plugin"
date: 2016-06-07T23:00:00+02:00
draft: false
summary: "I've developed a little Javascript plugin with which you can play Conway's Game of Life. Actually, it's not a real game. You can determine the initial state and from there it sort of just evolves. Visit the article to play it yourself."
types: ['project']
subjects: ['javascript', 'plugin', 'open source']
params:
  outdated_warning: true
---

Conway's Game of Life really is a weird game:
1. You cannot actually play it, you just provide it with an initial state. That's it.
2. You don't have an opponent, you cannot score points.
3. There is no way to win or lose.

So, I'm not sure why they even call it a game. But that's not the point of this article... If you want to learn more about what kind of silly game this is, [Wikipedia is your friend](https://en.wikipedia.org/wiki/Conway's_Game_of_Life).

In short in comes down to this:

* There is a grid of "cells".
* Each cell is either alive or dead, 1 or 0.
* Each iteration of the "game" you count the number of alive neighbors of each cell (using a [Moore neighborhood](https://en.wikipedia.org/wiki/Moore_neighborhood) of size 1).
    * If a living cell has less than 2 or more than 3 life neighbors it dies.
    * If a living cell has 2 or 3 life neighbors it stays alive.
    * If a dead cell has exactly 3 life neighbors it comes to life.
* Repeat for as long as you like.

## Javascript plugin
I've made a javascript plugin that allows you to play the Game of Life. It works with the HTML `<canvas>` element. You can provide it with a config to adjust the size of the playing field and some other stuff. Also, you have some functions with which to start, stop and reset the game.

Some of the things that this script does are:
* It allows you to have multiple games on 1 page.
* It doesn't allow any other script or libraries.
* It should be available on Bower and Npm.

Find out more on the [gameoflife repository on Github](https://github.com/barryvanveen/gameoflife).

## Things I've learned
Here is the list of things I learned from this project:

* I've worked with ES6 classes and modules.
* Learned to compile ES6 into plain Javascript (for compatibility with most browsers) using Gulp, Babel, and Rollup.
* I've built a package that is available on Bower and [Npm](https://www.npmjs.com/package/gameoflife-es6).

## Play it
If you want to play the Game Of Life game, please visit the [examples page on Github](https://barryvanveen.github.io/gameoflife/).