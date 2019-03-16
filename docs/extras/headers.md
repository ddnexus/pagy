---
title: Headers
---
# Headers Extra

This extra implements the [RFC-8288](https://tools.ietf.org/html/rfc8288) compliant http response headers (and other helpers) useful for API pagination.

- No need for an extra dependency
- No need to learn yet another interface
- It saves quite a lot of memory and CPU
- It works with any pagy object (including `Pagy::Countless`) regardless the type of collection
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
# explicitly merge the headers to the response 
pagy_headers_merge(pagy)
render json: records
```

### Suggestions

Instead of explicitly merging the headers before each rendering, you can get them automatically merged (application-wide and when `@pagy` is available), by overriding the `render` method in your application controller:

```ruby
def render(*args, &block)
  pagy_headers_merge(@pagy) if @pagy
  super
end

# and use it in any action (notice @pagy)
@pagy, records = pagy(Product.all)
render json: records
```

If your code in different actions is similar enough, you can encapsulate the statements in a custom `pagy_render` method in your application controller. For example:

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

- [headers.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/headers.rb)

## Headers

This extra generates the standard `Link` header defined in the
[RFC-8288](https://tools.ietf.org/html/rfc8288), and adds 4 customizable headers useful for pagination: `Current-Page`, `Page-Items`, `Total-Pages` and `Total-Count` headers.

Example of the default HTTP headers produced:

```
Link <https://example.com:8080/foo?page=1>; rel="first", <https://example.com:8080/foo?page=2>; rel="prev", <https://example.com:8080/foo?page=4>; rel="next", <https://example.com:8080/foo?page=50>; rel="last"
Current-Page 3
Page-Items 20
Total-Pages 50 
Total-Count 1000 
```

#### Customize the header names

If you are replacing any of the existing API-pagination gems in some already working app, you may want to customize the header names so you will not have to change the client app that consumes them. You can do so by using the `:headers` variable _(see [variables](#variables) below)_

#### Countless Pagination

If your requirements allow to save one count-query per rendering by using the `pagy_countless` constructor, the headers will not have the `rel="last"` link, the `Total-Count` and the `Total-Pages` that are unknown with countless pagination.

Example of HTTP headers produced from a `Pagy::Countless` object:

```
Link <https://example.com:8080/foo?page=1>; rel="first", <https://example.com:8080/foo?page=2>; rel="prev", <https://example.com:8080/foo?page=4>; rel="next"
Current-Page 3
Page-Items 20 
```

## Variables

| Variable   | Description                                              | Default                                                                                     |
|:-----------|:---------------------------------------------------------|:--------------------------------------------------------------------------------------------|
| `:headers` | Hash variable to customize/suppress the optional headers | `{ page: 'Current-Page', items: 'Page-Items', count: 'Total-Count', pages: 'Total-Pages' }` |

As usual, depending on the scope of the customization, you can set the variables globally or for a single pagy instance.

For example, the following will change the header names and will suppres the `:pages` ('Total-Pages') header:

```ruby
# globally
Pagy::VARS[:headers] = {page: 'Current-Page', items: 'Per-Page', pages: false, count: 'Total'}

# or for single instance
pagy, records = pagy(collection, headers: {page: 'Current-Page', items: 'Per-Page', pages: false, count: 'Total'})
```

## Methods

This extra adds a few methods to the `Pagy::Backend` (available in your controllers).

### pagy_headers_merge(pagy)

This method relies on the `response` method in your controller returning a `Rack::Response` object.

You should use it before rendering: it simply merges the `pagy_headers` to the `response.headers` internaly.

**Notice**: If your app doesn't implement the `response` object that way, you can still use the hash returned by the `pagy_headers` method in the way that your app/framework provides.

### pagy_headers(pagy)

This method generates a hash of [RFC-8288](https://tools.ietf.org/html/rfc8288) compliant http headers to send with the response. It is internally used by the `pagy_headers_merge` method, so you usually don't need to use it directly.

### pagy_headers_hash(pagy)

This method generates a hash structure of the headers, useful if you want to include some meta-data within your json. For example:

```ruby
render json: records.as_json.merge!(meta: {pagination: pagy_headers_hash(pagy)})
```
