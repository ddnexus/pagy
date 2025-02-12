---
title: Headers
categories:
- Backend
- Extra
---

# Headers Extra

Add [RFC-8288](https://tools.ietf.org/html/rfc8288) compliant http response headers (and other helpers) useful for API
pagination. It also follows the header casing introduced by `rack` version `3+` (see https://github.com/rack/rack/issues/1592).

!!!success
This extra works also with the [Pagy::Keyset API](/docs/api/keyset.md)
!!!

## Synopsis

```ruby pagy.rb (initializer)
require 'pagy/extras/headers'
```

```ruby Controller (action)
# paginate as usual with any pagy_* backend constructor
pagy, records = pagy(collection)
# explicitly merge the headers to the response
pagy_merge_headers(pagy)
render json: records
```

### Suggestions

Instead of explicitly merging the headers before each rendering, if you use rails you can get them automatically merged (
application-wide and when `@pagy` is available), by adding an `after_action` in your application controller:

```ruby Controller (after_action)
after_action { pagy_merge_headers(@pagy) if @pagy }

# and use it in any action (notice @pagy that enables the merging)
@pagy, records = pagy(collection)
render json: records
```

If your code in different actions is similar enough, you can encapsulate the statements in a custom `pagy_render` method in your
application controller. For example:

```ruby Controller (pagy_render)
def pagy_render(collection, **opts)
  pagy, records = pagy(collection, opts) # any pagy_* backend constructor works
  pagy_merge_headers(pagy)
  render json: records
end

# and use it in your standard actions:
pagy_render(collection)
```

## Headers

This extra generates the standard `link` header defined in the
[RFC-8288](https://tools.ietf.org/html/rfc8288), and adds 4 customizable headers useful for pagination: `current-page`,
`page-items`, `total-pages` and `total-count` headers.

```text Example of the default HTTP headers
link <https://example.com:8080/foo?page=1>; rel="first", <https://example.com:8080/foo?page=2>; rel="prev", <https://example.
com:8080/foo?page=4>; rel="next", <https://example.com:8080/foo?page=50>; rel="last"
current-page 3
page-items 20
total-pages 50
total-count 1000
```

### Customize the header names

If you are replacing any of the existing API-pagination gems in some already working app, you may want to customize the header
names so you will not have to change the client app that consumes them. You can do so by using the `:headers` option _(
see [options](#options) below)_

!!!warning Countless and Keyset Pagination

If you use the `headers` extra with the [contless](countless.md) or [keyset](keyset.md) extras, a few heder will not be available (e.g. the last link)
!!!


## Variables

| Variable   | Description                                              | Default                                                                                     |
|:-----------|:---------------------------------------------------------|:--------------------------------------------------------------------------------------------|
| `:headers` | Hash option to customize/suppress the optional headers | `{ page: 'current-page', limit: 'page-items', count: 'total-count', pages: 'total-pages' }` |

As usual, depending on the scope of the customization, you can set the options globally or for a single pagy instance.

For example, the following will change the header names and will suppress the `:pages` ('Total-Pages') header:

```ruby pagy.rb (initializer)
# global
Pagy::DEFAULT[:headers] = {page: 'current-page', 
                           limit: 'per-page', 
                           pages: false, 
                           count: 'total'}
```

```ruby Controller
# or for single instance
pagy, records = pagy(collection, 
                     headers: {page: 'current-page', 
                               limit: 'per-page', 
                               pages: false, 
                               count: 'total'})
```

## Methods

==- `pagy_merge_headers(pagy)`

This method relies on the `response` method in your controller returning a `Rack::Response` object.

You should use it before rendering: it simply merges the `pagy_headers_hash` to the `response.headers` internally.

If your app doesn't implement the `response` object that way, you should override the `pagy_merge_headers` method in your
controller or use the `pagy_headers_hash` method directly.

==- `pagy_headers_hash(pagy)`

This method generates a hash of [RFC-8288](https://tools.ietf.org/html/rfc8288) compliant http headers to send with the
response. It is internally used by the `pagy_merge_headers` method, so you usually don't need to use it directly. However, if you
need to edit the headers that pagy generates (for example adding extra `link` headers), you can override it in your own
controller.
   
==- `pagy_link_header(pagy)`

Return only the `link` header as a single key Hash.

===
