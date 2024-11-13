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

You may need it in order to paginate a collection outside of a regular rack request or controller, like in an unconventional API
module, or in the irb/rails console or for testing/playing with backend and frontend methods.

You trigger the standalone mode by setting an `:url` variable, which will be used directly and verbatim, instead of extracting it
from the `request` `Rack::Request` object. You can also pass other params by using the `:params` variable as usual. That will be
used to produce the final URLs in the usual way.

This extra will also create a dummy `params` method (if not already defined) in the module where you will include
the `Pagy::Backend` (usually a controller).

## Synopsis

```ruby pagy.rb (initializer)
require 'pagy/extras/standalone'

# optional: set a default url
Pagy::DEFAULT[:url] = 'http://www.example.com/subdir'
```

```ruby Controller
# pass a :url variable to work in standalone mode (no need of any request object nor Rack env)
@pagy, @products = pagy(collection, url: 'http://www.example.com/subdir', params: {...})
```

## Variables

| Variable | Description                              | Default |
|:---------|:-----------------------------------------|:--------|
| `:url`   | url string (can be absolute or relative) | `nil`   |

You can use the :params variable to add params to the final URLs.

## Methods

==- Overridden `pagy_url_for`

The `standalone` extra overrides the `pagy_url_for` method used internally. If it finds a set `:url` variable it assumes there is
no `request` object, so it uses the `:url` variable verbatim to produce the final URL, only adding the query string, composed by
merging the `:page` param to the `:params` variable. If there is no `:url` variable set it works like usual, i.e. it uses the
rake `request` object to extract the base_url, path from the request, merging the params returned from the `params` controller
method, the `:params` variable and the `:page` param to it.

==- Dummy `params` method

This extra creates a dummy `params` method (if not already defined) in the module where you include the `Pagy::Backend` (usually a controller). The method is called by pagy to fetch the backend variables coming from the request, and expects a hash, so the dummy param method returns an empty hash avoiding an error.

===
