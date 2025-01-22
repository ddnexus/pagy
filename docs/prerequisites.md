---
order: 10
title: Prerequisites
icon: shield-check-24
---

## Ruby

+++ Pagy 7.0+
!!! success
Pagy follows the [ruby end-of-life](https://endoflife.date/ruby) supported rubies.
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

Read how to [Use Pagy with non-rack apps](how-to.md#use-pagy-with-a-non-rack-app).

+++ Irb

!!! success
With or without any app nor configuration
!!!

Use the [Pagy::Console](api/console.md)
+++

## Supported collections

Out of the box pagy supports:

### Offset pagination with:

- `ActiveRecord::Relation`
- [array](extras/array.md)
- [elasticsearch_rails](extras/elasticsearch_rails.md)
- [searchkick](extras/searchkick.md)
- [meilisearch](extras/meilisearch.md)

### Keyset and Keynav pagination with:

- `ActiveRecord::Relation`
- `Sequel::Dataset`

In order to paginate other collections, search for "paginate" in the search field above.
