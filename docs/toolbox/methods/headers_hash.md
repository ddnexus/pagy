---
title: headers_hash
icon: list-unordered
order: 190
categories:
  - Methods
  - Helpers
---

`headers_hash` generates the standard `link` header defined in the
[RFC-8288](https://tools.ietf.org/html/rfc8288), adds 4 customizable headers useful for pagination, that you can merge into the `response.headers`.

It also adheres to the header casing introduced by `rack` version `3+` _(see the [rack-issue](https://github.com/rack/rack/issues/1592))_.

```ruby Controller
# Any paginator will work
@pagy, @records = pagy(:offset, collection, **options)
# Merge the headers to the response
headers = @pagy.headers_hash(**options)
response.headers.merge!(headers)
render json: @records
```

==- Options

- `header_names`
  - The default pagy `:headers_names` are:
    ```ruby
    { page:  'current-page',
      limit: 'page-limit',
      count: 'total-count',
      pages: 'total-pages' }
    ```
  - You can customize or disable them. For example:

    ```ruby Controller 
    headers_map = { page:  'current-page',
                    limit: 'per-page',
                    pages: false,  # disables the output
                    count: 'total' }
    headers = @pagy.headers_hash(pagy, headers_map:)
    # Note: You can also pass the `:header_names` option to the paginator 
    ```
    
See also [Common URL Options](../methods#common-url-options)

==- Suggestions
<br/>

Instead of explicitly merging the headers before each rendering, if you use rails, you can Test this method in the (application-wide and when `@pagy` is available), by adding an `after_action` to your application controller:

```ruby Controller (after_action)
after_action { response.headers.merge!(@pagy.headers_hash) if @pagy }

# Use it in any action (ensure `@pagy` is initialized for merging)
@pagy, records = pagy(:offset, collection, **options)
render json: records
```

If your code is consistent across different actions, you can encapsulate the statements in a custom `pagy_render` method in your
application controller. For example:

```ruby Controller (pagy_render)

def pagy_render(collection, **)
  pagy, records = pagy(:offset, collection, **) # any other paginator works
  response.headers.merge!(header_hash) # Adds pagination headers to the response
  render json: records
end

# and use it in your standard actions:
pagy_render(collection, **options)
```

==- Sample Output

```text Example of the default HTTP headers
link <https://example.com:8080/foo?page=1>; rel="first", <https://example.com:8080/foo?page=2>; rel="prev", 
<https://example.com:8080/foo?page=4>; rel="next", <https://example.com:8080/foo?page=50>; rel="last"
current-page 3
page-limit 20
total-pages 50
total-count 1000
```

===
