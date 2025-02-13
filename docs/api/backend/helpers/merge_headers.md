---
title: pagy_merge_headers
---

`pagy_merge_headers` generates the standard `link` header defined in the
[RFC-8288](https://tools.ietf.org/html/rfc8288), adds 4 customizable headers useful for pagination, and merges them into the `response.headers`.

It also follows the header casing introduced by `rack` version `3+` _(see the [rack-issue](https://github.com/rack/rack/issues/1592))_.

```ruby Controller
# Paginate as usual with ANY pagy_* backend paginator
pagy, records = pagy_offset(collection, **options)
# Merge the headers to the response
pagy_merge_headers(pagy, **options)
render json: records
```

==- Options

- `header_names`
  - The default pagy `:headers_names` are:
    ```ruby
    { page:  'current-page',
      limit: 'page-items',
      count: 'total-count',
      pages: 'total-pages' }
    ```
  - You can customize or suppress them. For example:

    ```ruby Controller
    pagy_merge_header(pagy, header_names: { page:  'current-page',
                                            limit: 'per-page',
                                            pages: false,  # suppress the output
                                            count: 'total' })
    # Notice that you can pass the `:header_names` option also to the paginator 
    ```
- `absolute: true`
  - URL absolute
- `fragment: '#...'`
  - URL fragment string

==- Customization
<br/>

`pagy_headers_hash` is the method that does the heavy lifting to prepare the hash of headers. You can use it directly if you need to customize your header further, before manually merging them.

```ruby Controller (action)
header_hash = pagy_headers_hash(pagy, **options)
# do something with the header_hash
# then nerge them manually
response.headers.merge!(header_hash)
render json: records
```

==- Suggestions
<br/>

Instead of explicitly merging the headers before each rendering, if you use rails, you can get them automatically merged (application-wide and when `@pagy` is available), by adding an `after_action` in your application controller:

```ruby Controller (after_action)
after_action { pagy_merge_headers(@pagy) if @pagy }

# and use it in any action (notice @pagy that enables the merging)
@pagy, records = pagy_offset(collection, **options)
render json: records
```

If your code is similar enough in different actions, you can encapsulate the statements in a custom `pagy_render` method in your
application controller. For example:

```ruby Controller (pagy_render)

def pagy_render(collection, **)
  pagy, records = pagy_offset(collection, **) # any other paginator works
  pagy_merge_headers(pagy, **)
  render json: records
end

# and use it in your standard actions:
pagy_render(collection, **options)
```

==- Output

```text Example of the default HTTP headers
link <https://example.com:8080/foo?page=1>; rel="first", <https://example.com:8080/foo?page=2>; rel="prev", <https://example.
com:8080/foo?page=4>; rel="next", <https://example.com:8080/foo?page=50>; rel="last"
current-page 3
page-items 20
total-pages 50
total-count 1000
```

===
