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
pagy demo
# or bundle exec pagy demo (depending on your env)
```

...and point your browser to http://0.0.0.0:8000
!!!

### Demo Apps

At the moment we have a couple of single-file sinatra apps ready to run in your browser...

#### 1. Demo.ru

An interactive showcase of all the helpers and styles.

Available with `pagy demo` (or `bundle exec pagy demo`). You can use it to check the look and the functionalities of 
all the components of the different styles.

#### 2. Repro.ru

A minimalistic app that you can use as a starting point for prototyping or reproducing issues, in order
to get support or file bugs reports.

||| Create a new `repro.ru` app

```sh
pagy new repro
```

You should find the `./repro.ru` new app file in the current dir. Feel free to rename or move it as you like.

|||
||| Develop it

This command runs a puma server that logs and auto-restart your app when it changes:

```sh
pagy path/to/your/renamed-repro.ru
```

Point a browser to `http://0.0.0.0:8000`

Edit it at will.

|||

### Pagy help

```txt
$ pagy

Pagy utility to run, create and develop pagy demo apps

USAGE  
  pagy [demo|repro|**/*.ru] [\d+|8000] 
                Run an app on port (default 8000)
  pagy new [demo|repro] 
                Create a demo or repro app   

EXAMPLES
  pagy          Print this message
  pagy demo     Run the demo app on port 8000
  pagy repro    Run the repro app on port 8000
  pagy new repro 
                Create a new repro app at ./repro.ru 
  pagy ~/my-repro.ru 8001
                Run your app at http://0.0.0.0:8001
```

!!!warning ** ERROR: directory is already being watched! **

Your app is in a dir with looping simlinks, and the `listen` gem cannot handle it.

!!!success Move your app in a different dir
!!!
