---
order: 3
title: Prerequisites
icon: shield-check-24
---

## Ruby
+++ Pagy 4.0+
!!! success
- Tested on ruby `3.0+`
- Working on ruby `2.5+`
!!!

!!! info
For CI reasons, tests cover only the [ruby end-of-life](https://endoflife.date/ruby) supported rubies. However the current version still works with ruby 2.5+ (rubocop checked), but it will be phased out in v7 and will be kept in sync with the official [ruby end-of-life](https://endoflife.date/ruby).
!!!

+++ Old Pagy
!!! info
Older versions run on:

* ruby `1.9+` or
* `jruby 1.7+` till `ruby <2.5`
!!!

+++

## Working environments

+++ Rack

!!! success
Your app uses a `Rack` based framework (Rails, Sinatra, Padrino, etc.)
!!!

Use pagy normally

+++ Non Rack

!!! success
Your app does not use a `Rack` based framework.
!!!

Use the [standalone extra](extras/standalone.md)

+++ Irb

!!! success
With or without any app nor configuration
!!!

Use the [Pagy::Console](api/console.md)
+++

## Supported collections

Out of the box pagy supports `ActiveRecord::Relation`, [array](extras/array.md), [elasticsearch_rails](extras/elasticsearch_rails.md), [searchkick](extras/searchkick.md) and [meilisearch](extras/meilisearch.md) collections.

In order to paginate other collections, search for "paginate" in the search field above.
