---
title: Headers
---
# Headers Extra

This extra implements the [RFC-8288](https://tools.ietf.org/html/rfc8288) compilant http response headers (and other helpers) useful for API pagination.

- It removes the need for an extra dependency
- No need to learn yet another interface
- It saves quite a lot of memory and CPU
- It works with any type of collection and/or `pagy_*` constructor (even `pagy_countless`)
- It offers more explicit flexibility and simplicity

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/headers'
```

In your controller action:

```ruby
# paginate as usual with any pagy_* backend constructor
pagy, records = pagy(Product.all)
pagy_headers_merge(pagy)
render json: records
```

Or if you can reuse it (e.g. in a pure API app with very standard actions), you are encouraged to define a custom `pagy_render` method in your application controller like:

```ruby
def pagy_render(collection, vars={})
  pagy, records = pagy(collection, vars) # any pagy_* backend constructor works
  pagy_headers_merge(pagy)
  render json: records
end

# and use it in your standard actions:
pagy_render(Product.all)
```

## Files

This extra is composed of 1 small file:

- [headers.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/headers.rb)

## Headers

This extra adds the standard/legacy headers used by various API-pagination gems with `Link`, `Per-Page` and `Total` headers, so it is a convenient replacement for legacy apps that use external gems.

For new apps, and for consistency with the Pagy naming, you may want to use the `Items` (instead of Per-Page) and `Count` (instead of Total) aliases.

Example of HTTP headers produced:

```
Link <https://example.com:8080/foo?page=1>; rel="first", <https://example.com:8080/foo?page=2>; rel="prev", <https://example.com:8080/foo?page=4>; rel="next", <https://example.com:8080/foo?page=50>; rel="last"
Items 20 
Per-Page 20 
Count 1000 
Total 1000
```

#### Countless Pagination

If your requirements allow to save one count-query per rendering by using the `pagy_countless` constructor, the headers will miss only the `rel="last"` link and the `Total`/`Count` (unknown with countless pagination).

Example of HTTP headers produced from a `Pagy::Countless` object:

```
Link <https://example.com:8080/foo?page=1>; rel="first", <https://example.com:8080/foo?page=2>; rel="prev", <https://example.com:8080/foo?page=4>; rel="next"
Items 20 
Per-Page 20 
```

## Methods

This extra adds a few methods available in your controllers.

### pagy_headers_merge(pagy)

This method relies on the `response` method in your controller returning a `Rack::Response` object.

You should use it before rendering: it simply merges the `pagy_headers` to the `response.headers` internaly.

**Notice**: If your app doesn't implement the `response` object that way, you can still use the hash returned by the `pagy_headers` method to custom-send the http headers with whatever is your app way.

### pagy_headers(pagy)

This method generates a hash of [RFC-8288](https://tools.ietf.org/html/rfc8288) compliant http headers to send with the response. It is internally used by the `pagy_headers_merge` method, so you usually don't need to use it directly.

### pagy_headers_hash(pagy)

This method generates a hash of headers, useful if you want to include some meta-data within your json. For example:

```ruby
render json: records.as_json.merge!(meta: {pagination: pagy_headers_hash(pagy)})
```


