---
title: Try the demo now! 🆕
order: 4
icon: play-24
---

# Pagy Executable

We added a small `pagy` executable that can run browser-demos from the installed gem: no need to setup
anything on your side!

!!!success Try it now!

Run the interactive demo from your terminal:

```sh
pagy run demo
# or bundle exec pagy run demo (depending on your env)
```

...and point your browser to http://0.0.0.0:8000
!!!

### Demo Apps

At the moment we have a couple of single-file sinatra apps ready to run in your brower...

#### 1. Demo.ru

An interactive showcase of all the helpers and styles.

Available with `pagy run demo` (or `bundle exec pagy run demo`). You can use it to check the look and the functionalities of 
all the components of the different styles.

#### 2. Repro.ru

A minimalistic app that you can use as a starting point for prototyping or reproducing issues, in order
to get support or file bugs reports.

||| Create a new `repro.ru` app

```sh
pagy create repro
```

You should find the `./repro.ru` new app file in the current dir. Feel free to rename or move it as you like.

|||
||| Develop it

This command runs a puma server that logs and auto-restart your app when it changes:

```sh
pagy develop path/to/your/renamed-repro.ru
```

Point a browser to `http://0.0.0.0:8000`

Edit it at will.

|||

### Pagy help

```txt
$ pagy help

Pagy utility to run, create, develop pagy demo apps

USAGE
  pagy [command [app [port]]]
  pagy [run|create|develop|help] [demo|repro|**/*.ru] [8000|\d+]

  command:
      run       Run the app at http://0.0.0.0:8000
      create    Create a new app (repro|demo)
      develop   Run, log and auto-restart the app at http://0.0.0.0:8000
      help      Print this message
  app:
      repro     Pagy app to reproduce issues
      demo      Pagy app to showcase all helpers and styles (default)
      **/*.ru   Path to your created/renamed/edited *.ru app file
  port:
      8000      Server port (default)

EXAMPLES
  pagy          Print the help message
  pagy help     Print the help message
  pagy run      Run the demo app on port 8000
  pagy run demo
                Run the demo app on port 8000
  pagy create repro
                Create a new repro app at ./repro.ru
  pagy develop ~/issues/my-repro.ru 8001
                Develop your app at http://0.0.0.0:8001
```
