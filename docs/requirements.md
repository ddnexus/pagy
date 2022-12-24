---
order: 3
title: Requirements
icon: unverified-24
---

## Ruby
+++ Pagy 4.0+
!!! success
Ruby `2.7+`
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

+++ Non Rack

!!! success
Your app does not use a `Rack` based framework.
!!!

Require the [standalone extra](extras/standalone.md), and pass a `:url` variable.

+++ Irb

!!! success
With or without any app nor configuration
!!!

Use the [Pagy::Console](api/console.md).
+++

### Special cases

- If the collection to paginate is not a collection supported out of the box like ActiveRecord scope, [array](extras/array.md), [elasticsearch_rails](extras/elasticsearch_rails.md), [searchkick](extras/searchkick.md), [meilisearch](extras/meilisearch.md), ... you may need to override the `pagy_*get_vars` backend method.
- If the collection you are paginating doesn't respond to `offset` and `limit` and is not yet supported by any extra, you may need to override the `pagy_get_items` method in your controller (to get the items out of your specific collection)
- If your framework doesn't have a `params` method you can use the [standalone extra](extras/standalone.md) or you may need to define the `params` method or override the `pagy_get_vars` (which uses the `params` method) in your controller
- If your framework doesn't have a `request` method you can use the [standalone extra](extras/standalone.md) or you may need to override the `pagy_url_for` (which uses `Rack` and `request`) in your view

!!!
The total overriding you may need is usually just a handful of lines at worse, and it doesn't need monkey patching or writing any sub-class or module
!!!
