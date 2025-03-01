---
label: Playground
order: 100
icon: play
---

# 

## Pagy Playground

---

You can showcase, clone, and develop a few Pagy apps without needing to set anything up on your side!

```sh
$ pagy --help
```

### Pagy Apps

We have a few single-file apps ready to run in your browser for various purposes. These are all tested and used to run
the [E2e Test](https://github.com/ddnexus/pagy/blob/master/.github/workflows/e2e-test.yml) workflow.

#### 1. Repro App

You can use this app as a starting point to try Pagy or reproduce issues to get support or file bug reports.

||| Clone the `repro` app

```sh
pagy clone repro
```

You should find the `./repro.ru` cloned app file in the current directory. Feel free to rename or move it as you wish.

|||
||| Develop it

This command runs your `rackup` app with a `puma` server. On Linux platforms, it also uses `rerun` to auto-restart it when changes are made:

```sh
pagy path/to/your-repro.ru
```

Open a browser and navigate to http://0.0.0.0:8000

Edit it at will.

!!! Tip

Bundler installs the required gems during the first run.

!!!

|||

#### 2. Rails App

You can use this app as a starting point to reproduce **Rails-related** Pagy issues. It has the same usage as the [Repro App](#1-repro-app), i.e.:

```sh
pagy clone rails
pagy ./rails.ru
```

#### 3. Demo App

This is the interactive showcase for all the pagy helpers and CSS styles.

!!! success Try it now!

Run the interactive demo from your terminal:

```sh
pagy demo
```

...and point your browser to http://0.0.0.0:8000
!!!

_Run `pagy clone demo` to inspect the app file_

If you want to see how your CSS changes look, you can follow the same usage as the [Repro App](#1-repro-app) to iterate through
them.

#### 4. Calendar App

This is the interactive showcase and reproduction tool for the `:calendar` paginator:

!!!success Try it now!

Run the interactive demo from your terminal:

```sh
pagy calendar
```

...and point your browser to http://0.0.0.0:8000
!!!

_Run `pagy clone calendar` to inspect the app file._

If you need to reproduce any calendar related issue, you can follow the same usage as the [Repro App](#1-repro-app).

#### 5. Keyset Apps

These are the interactive showcase/repro for the `:keyset` paginator with `ActiveRecord` or `Sequel` sets:

!!!success Try it now!

Run the interactive demo from your terminal:

```sh      
pagy | grep key   
  keynav                     Showcase the Keynav pagination (ActiveRecord example)
  keyset                     Showcase the Keyset pagination (ActiveRecord example)
  keyset_sequel              Showcase the Keyset pagination (Sequel example)
 
pagy keynav
pagy keyset
pagy keyset_sequel
```

...and point your browser to http://0.0.0.0:8000
!!!

_Run for example `pagy clone keyset` to inspect the keyset app file._

### Troubleshooting

==- Bundler inline

All the pagy apps use [bundler/inline](https://bundler.io/guides/bundler_in_a_single_file_ruby_script.html).

Depending on your environment you might get this message for some gem:

```txt
You have already activated GEMNAME v1, but your Gemfile requires GEMNAME v2. 
Prepending `bundle exec` to your command may solve this.
```

If `bundle exec` doesn't solve it, then try `bundle update` and `gem cleanup`.
If you encounter another error after that:


```txt
... `find_spec_for_exe': can't find gem GEMNAME (>= 0.x) with executable EXEC (Gem::GemNotFoundException)
```

then `gem pristine GEMNAME` should solve the problem.

==- Rerun
[Rerun](https://github.com/alexch/rerun) is used to restart your app automatically during development (only on Linux
platforms).

That's very convenient, but it may still have some rough edges:

!!! warning ** ERROR: Directory is already being watched! **

Your app is in a directory with looping symlinks, and the `listen` gem cannot handle it.

!!!success Move your app in a different dir
!!!

===
