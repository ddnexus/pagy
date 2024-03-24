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

Available with `pagy demo` (or `bundle exec pagy demo`). You can use it to check the look and the functionalities of all the
components of the different styles.

#### 2. Repro.ru

A pagy-ready, no-setup, single-file, minimalistic app that you can use as a starting point for prototyping or reproducing issues,
in order to get support or file bugs reports.

||| Create a new `repro.ru` app

```sh
pagy new repro
```

You should find the `./repro.ru` new app file in the current dir. Feel free to rename or move it as you like.

|||
||| Develop it

This command runs your `rackup` app with a `puma` server, with `rerun` that auto-restart it when it changes:

```sh
pagy path/to/your/renamed-repro.ru
```

Point a browser to `http://0.0.0.0:8000`

Edit it at will.

|||

### Pagy help

```txt
$ pagy -h

  Pagy utility to run, create and develop pagy demo apps

  USAGE
    pagy new [demo|repro]
    pagy [demo|repro|**/*.ru] [options]

  Rackup options
    -o, --host      Custom host (default: 0.0.0.0)
    -p, --port      Custom port (default: 8000)

  Rerun options
    -c, --clear     Clear screen before each rerun
        --no-rerun  Disable rerun

  Other options
    -q, --quiet     Quiet mode
    -h, --help      Print this message and exit
    -v, --version   Print the version and exit

  EXAMPLES
    pagy demo       Run the demo app at http://0.0.0.0:8000
    pagy repro      Run the repro app at http://0.0.0.0:8000
    pagy new repro  Create a new repro app at ./repro.ru
    pagy ~/my-repro.ru -o 127.0.0.1 -p 8001
                    Run your app at http://127.0.0.1:8001
```

### Rerun

[Rerun](https://github.com/alexch/rerun) is used for restarting your app during development.

That's very convenient, but it may still have some rough edges:

!!!warning ** ERROR: directory is already being watched! **

Your app is in a dir with looping simlinks, and the `listen` gem cannot handle it.

!!!success Move your app in a different dir
!!!

!!!warning On certain filesystems...

It might not work properly or it may require additional dependencies.

!!!success
Pass the `--no-rerun` option to work with rackup only.

```sh
pagy ./my-repro.ru --no-rerun
```

!!!
