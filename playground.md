---
title: Try the demo now! 🆕
order: 4
icon: play-24
---

# Pagy Playground

You can showcase, clone and develop a few pagy APPs without the need to setup anything on your side!

```sh
$ pagy --help
```

!!!warning `bundle exec pagy`
Depending on your environment you may need to prepend `bundle exec` in all the examples shown in this page
!!!

### Pagy Apps

We have a few single-file apps ready to run in your browser for various purposes...

#### 1. Repro App

Starting point app to try pagy or reproduce issues, in order to get support or file bugs reports.

||| Clone the `repro` app

```sh
pagy clone repro
```

You should find the `./repro.ru` cloned app file in the current dir. Feel free to rename or move it as you like.

|||
||| Develop it

This command runs your `rackup` app with a `puma` server, with `rerun` that auto-restart it when it changes:

```sh
pagy path/to/your-repro.ru
```

Point a browser to http://0.0.0.0:8000

Edit it at will.

|||

#### 2. Rails App

Starting point app to reproduce **rails related** pagy issues. Same usage as the [Repro App](#1-repro-app).

#### 3. Demo App

Interactive showcase for all the pagy helpers and CSS styles.

!!!success Try it now!

Run the interactive demo from your terminal:

```sh
pagy demo
# or bundle exec pagy demo (depending on your env)
```

...and point your browser to http://0.0.0.0:8000
!!!

_Run `pagy clone demo` to inspect the app file_

If you want to see how your CSSs changes look, you can follow the same usage as the [Repro App](#1-repro-app) to iterate through
changes.

#### 4. Calendar App

Interactive showcase/repro for the calendar extra:

!!!success Try it now!

Run the interactive demo from your terminal:

```sh
pagy calendar
```

...and point your browser to http://0.0.0.0:8000
!!!

_Run `pagy clone calendar` to inspect the app file._

If you need to reproduce calendar related issues, you can follow the same usage as the [Repro App](#1-repro-app).

### Troubleshooting

==- Bundler inline

All the pagy apps use [bundler/inline](https://bundler.io/guides/bundler_in_a_single_file_ruby_script.html).

Depending on your environment you might get this message for some gem:

```txt
You have already activated GEMNAME v1, but your Gemfile requires GEMNAME v2. 
Prepending `bundle exec` to your command may solve this.
```

If `bundle exec` doesn't solve it, then try `bundle update` and `gem cleanup`.

If after that you get into another error:

```txt
... `find_spec_for_exe': can't find gem GEMNAME (>= 0.x) with executable EXEC (Gem::GemNotFoundException)
```

then `gem pristine GEMNAME` should solve the problem.

==- Rerun

[Rerun](https://github.com/alexch/rerun) is used for restarting your app automatically during development.

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
===
