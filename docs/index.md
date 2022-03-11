---
title: Documentation
icon: book-24
---
 
!!! success
Pagy `4.0+` runs on ruby `2.5+`
!!!
!!! info
Older versions run on ruby `1.9+` or `jruby 1.7+` till `ruby <2.5`
!!!

### Rack environments

Pagy works out of the box in a web app assuming that:

- You are using a `Rack` based framework (Rails, Sinatra, Padrino, etc.)
- The collection to paginate is an ORM collection (e.g. ActiveRecord scope) or other collections supported by some backend extra ([array](extras/array.md), [elasticsearch_rails](extras/elasticsearch_rails.md), [searchkick](extras/searchkick.md), [meilisearch](extras/meilisearch.md), ...)
- The controller where you include `Pagy::Backend` responds to a `params` method
- The view where you include `Pagy::Frontend` responds to a `request` method returning a `Rack::Request` instance.

### Non Rack environments

- Require the [standalone extra](extras/standalone.md), and pass a `:url` variable and you can use it without Rack in your app or exotic API, with or without the other extras you might need. You can even use every feature/helper right in the irb/rails console.
- Besides Rack the other assumptions above apply

### Irb/rails console environment

Standard pagination requires controller, model, view and request to work, however you don't have to satisfy all that requirements in order to get any helper working in the irb/rails console. Just use the [Pagy::Console](api/console.md) and you can try any feature right away, even without any app nor configuration.

### Any other environment

Pagy can also work in any other scenario assuming that:

- If your framework doesn't have a `params` method you can use the [standalone extra](extras/standalone.md) or you may need to define the `params` method or override the `pagy_get_vars` (which uses the `params` method) in your controller
- If the collection you are paginating doesn't respond to `offset` and `limit` and is not yet supported by any extra, you may need to override the `pagy_get_items` method in your controller (to get the items out of your specific collection)
- If your framework doesn't have a `request` method you can use the [standalone extra](extras/standalone.md) or you may need to override the `pagy_url_for` (which uses `Rack` and `request`) in your view

!!!
The total overriding you may need is usually just a handful of lines at worse, and it doesn't need monkey patching or writing any sub-class or module
!!!
