---
title: Try the demo now! 🆕
order: 4
icon: play-24
---

# Pagy Playground

You can showcase, clone and develop a few pagy APPs without the need to set up anything on your side!

```sh
$ bundle exec pagy --help
```

### Pagy Apps

We have a few single-file apps ready to run in your browser for various purposes: they are all tested and used to run 
the [E2e Test](https://github.com/ddnexus/pagy/blob/master/.github/workflows/e2e-test.yml) workflow.

#### 1. Repro App

You can use this app as a starting point to try pagy or reproduce issues, in order to get support or file bugs reports.

||| Clone the `repro` app

```sh
bundle exec pagy clone repro
```

You should find the `./repro.ru` cloned app file in the current dir. Feel free to rename or move it as you like.

|||
||| Develop it

This command runs your `rackup` app with a `puma` server. It also uses `rerun` to auto-restart it when it changes (only on 
linux platforms):

```sh
bundle exec pagy path/to/your-repro.ru
```

Point a browser to http://0.0.0.0:8000

Edit it at will.

!!! Tip

Bundler installs the required gems during the first run. After that you can skip the rubygem 
checks by passing the `--no-istall` flag

!!!

|||

#### 2. Rails App

You can use this app as a starting point to reproduce **rails related** pagy issues. It has the same usage as the [Repro App](#1-repro-app). i.e.:

```sh
bundle exec pagy clone rails
bundle exec pagy ./rails.ru
```

#### 3. Demo App

This is the interactive showcase for all the pagy helpers and CSS styles.

!!!success Try it now!

Run the interactive demo from your terminal:

```sh
pagy demo
# or bundle exec pagy demo (depending on your env)
```

...and point your browser to http://0.0.0.0:8000
!!!

_Run `bundle exec pagy clone demo` to inspect the app file_

If you want to see how your CSSs changes look, you can follow the same usage as the [Repro App](#1-repro-app) to iterate through
changes.

#### 4. Calendar App

This is the interactive showcase/repro for the calendar extra:

!!!success Try it now!

Run the interactive demo from your terminal:

```sh
bundle exec pagy calendar
```

...and point your browser to http://0.0.0.0:8000
!!!

_Run `bundle exec pagy clone calendar` to inspect the app file._

If you need to reproduce any calendar related issue, you can follow the same usage as the [Repro App](#1-repro-app).

#### 5. Keyset Apps

This are the interactive showcase/repro for the keyset extra with `ActiveRecord` or `Sequel` sets:

!!!success Try it now!

Run the interactive demo from your terminal:

```sh      
bundle exec pagy | grep keyset
  keyset                     Showcase the Keyset pagination (ActiveRecord example)
  keyset_for_ui        Showcase the Keyset Numeric pagination (ActiveRecord example)
  keyset_sequel              Showcase the Keyset pagination (Sequel example)

bundle exec pagy keyset
bundle exec pagy keyset_for_ui
bundle exec pagy keyset_sequel
```

...and point your browser to http://0.0.0.0:8000
!!!

_Run `pagy clone keyset_ar` or `pagy clone keyset_s` to inspect the app file._


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

[Rerun](https://github.com/alexch/rerun) is used for restarting your app automatically during development (only on linux 
platforms).

That's very convenient, but it may still have some rough edges:

!!!warning ** ERROR: directory is already being watched! **

Your app is in a dir with looping symlinks, and the `listen` gem cannot handle it.

!!!success Move your app in a different dir
!!!

===
