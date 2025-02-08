---
title: Standalone
categories:
- Feature
- Extra
---

# Standalone Extra

Use pagy completely standalone.

!!! success
You can use pagy without any request object, nor Rack environment/gem, nor any defined `params` method, even in the irb/rails
console without an app (see the [Pagy::Console](/docs/api/console.md) module).
!!!

You may need it in order to paginate a collection outside a regular rack request or controller, like in an unconventional API
module, or in the irb/rails console or for testing/playing with backend and frontend methods.

## How it works

This extra creates a dummy `params` method (if not already defined) in the module where you will include
the `Pagy::Backend` (usually a controller).

Besides that you have just to define a `:url` option and the [pagy_url_for](/docs/api/frontend.md#pagy-url-for) method will assume there is no `request` object, so in order to produce the final URL, it will use the `:url` option verbatim, only adding the query string from the `params` (if any).

## Synopsis

```ruby pagy.rb (initializer)
require 'pagy/extras/standalone'

# optional: set a default url
Pagy::DEFAULT[:url] = 'http://www.example.com/subdir'
```

```ruby Controller
# pass a :url option to work in standalone mode (no need of any request object nor Rack env)
@pagy, @products = pagy(collection, url: 'http://www.example.com/subdir', params: {...})
```

## Methods

==- Dummy `params` method

The method is called by `pagy` to fetch the backend options coming from the request, and expects a hash, so the dummy param method returns an empty hash avoiding an error.

===
