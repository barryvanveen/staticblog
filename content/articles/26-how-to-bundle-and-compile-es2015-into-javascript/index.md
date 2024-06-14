---
title: "How to bundle and compile ES2015 into JavaScript"
date: 2016-06-25T20:00:00+02:00
draft: false
summary: "Not all features of ES2015 are widely supported. That is why it's necessary to bundle modules yourself and compile it into ordinary JavaScript. This blog post describes how to accomplish this."
types: ['tutorial']
subjects: ['javascript', 'npm', 'tools']
params:
  outdated_warning: true
---

Recently I worked on [my first project in ES2015](/articles/24-game-of-life-javascript-plugin). Because not all browsers support all features of ES2015, you need to compile it into "normal" JavaScript. Also, because the code is divided into modules, these need to be bundled. This blog post describes the tools and configuration I used.

## Automating your workflow with Gulp

Gulp is my task runner of choice. It can run different tasks (concat and minimize Javascript, compile SASS into CSS, etc) and watch for changes in your source files. Gulp also has plugins for a variety of tools, like Rollup and Babel.

## Bundle modules with Rollup

Modules allow you to separate your logic into multiple files. In your scripts, you can [import classes and functions](http://exploringjs.com/es6/ch_modules.html) from other files. Browsers don't support this new way of importing modules. Therefore we need rollup to bundle all necessary files into one.

From the rollup website:
> Rollup is a JavaScript module bundler. It allows you to write your application or library as a set of modules – using modern ES2015 import/export syntax – and bundle them up into a single file that you can easily include on an HTML page as a `<script>` tag, or distribute via package managers like npm.

With the [rollup-stream](https://github.com/Permutatrix/rollup-stream) plugin, we can incorporate this tool into our gulp tasks.

## Compile ES2015 with Babel

Babel is a JavaScript compiler. It can transform ES2015 code into ordinary JavaScript without loss of functionality. This ensures that we can use the newest features and still support all major browsers.

With the [gulp-babel](https://github.com/babel/gulp-babel) plugin, we can automate this step within our gulp workflow.

## Dependencies
The GameOfLife plugin has the following npm dependencies:

```json
"devDependencies": {
    "babel-preset-es2015": "^6.9.0",
    "gulp": "3.9.*",
    "gulp-babel": "^6.1.2",
    "gulp-rename": "1.2.*",
    "gulp-sourcemaps": "1.6.*",
    "rollup-stream": "^1.8.0",
    "vinyl-buffer": "^1.0.0",
    "vinyl-source-stream": "^1.1.0"
}
```

## Configuration
And the gulpfile looks like this:

```javascript
var babel = require("gulp-babel");
var gulp = require('gulp');
var rename = require("gulp-rename");
var rollup = require('rollup-stream');
var sourcemaps = require('gulp-sourcemaps');
var source = require('vinyl-source-stream');
var buffer = require('vinyl-buffer');

gulp.task('build-js', function () {
    rollup({
            entry: './src/gameoflife.js',
            sourceMap: true,
            format: 'iife',
            moduleName: 'GameOfLife',
            banner: `//  GameOfLife JavaScript Plugin v1.0.3
//  https://github.com/barryvanveen/gameoflife
//
//  Released under the MIT license
//  http://choosealicense.com/licenses/mit/`
        })

        // print errors to console, this makes sure Gulp can keep watching and running
        .on('error', e => {
            console.error(`${e.stack}`);
        })

        // point to the entry file
        .pipe(source('gameoflife.js', './src'))

        // buffer the output, needed for gulp-sourcemaps
        .pipe(buffer())

        // tell gulp-sourcemaps to load the inline sourcemap produced by rollup-stream
        .pipe(sourcemaps.init({loadMaps: true}))

        // compile es2015 into plain javascript
        .pipe(babel({presets: ['es2015']}))

        // rename output file
        .pipe(rename('gameoflife.min.js'))

        // write source map
        .pipe(sourcemaps.write('.'))

        // output to /dist
        .pipe(gulp.dest('dist'));
});

gulp.task('watch-js', function(){
    gulp.watch('src/**/*.js', ['build-js']);
});

gulp.task('default', ['build-js', 'watch-js']);
```

Some points of interest:
1. Rollup supports multiple output formats.  I've chosen for the IIFE (Immediately-Invoked Function Expression) format. It allows anyone to instantiate the plugin using `new GameOfLife()` without forcing the use of a RequireJS/CommonJS system.
2. The `moduleName` option decides the name of the IIFE function, in this case, "GameOfLife".
3. The [Babel es2015 preset](http://babeljs.io/docs/plugins/preset-es2015/) is all the configuration you probably need. Babel also provides a preset for react and a polyfill for more advanced features.

## Further reading
* [Rollup guide](http://rollupjs.org/guide/)
* [Babel homepage](http://babeljs.io/)