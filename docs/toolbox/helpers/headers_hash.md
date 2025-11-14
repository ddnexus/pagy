---
label: headers_hash
icon: list-unordered
order: 190
categories:
  - Methods
  - Helpers
---

#

## :icon-list-unordered: headers_hash

---

`headers_hash` generates the standard `link` header defined in the
[RFC-8288](https://tools.ietf.org/html/rfc8288), and adds 4 customizable headers useful for pagination, that you can merge into the `response.headers`.

It also adheres to the header casing introduced by `rack` version `3+` _(see the [rack-issue](https://github.com/rack/rack/issues/1592))_.

!!!success It works with all paginators
!!!

```ruby Controller
# Any paginator will work
@pagy, @records = pagy(:offset, collection, **options)
# Merge the headers to the response
headers = @pagy.headers_hash(**options)
response.headers.merge!(headers)
render json: @records
```

==- Examples

```ruby Console
require 'pagy/console'
=> true

>> @pagy, @records = pagy(:offset, collection.new, page: 3)
=> [#<Pagy::Offset:0x00007feb987636e0 @count=1000, @from=41, @in=20, @in_range=true, @last=50, @limit=20, @next=4, @offset=40, @options={limit: 20, limit_key: "limit", page_key: "page", page: 3, count: 1000}, @page=3, @previous=2, @request=#<Pagy::Request:0x00007feb98dcf1a0 @base_url="http://www.example.com", @cookie=nil, @jsonapi=nil, @path="/path", @params={example: "123"}>, @to=60>, [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]]

>> @pagy.headers_hash(absolute: true)
=> {"link" => "<http://www.example.com/path?example=123>; rel=\"first\", <http://www.example.com/path?example=123&page=2>; rel=\"previous\", <http://www.example.com/path?example=123&page=4>; rel=\"next\", <http://www.example.com/path?example=123&page=50>; rel=\"last\"", "current-page" => "3", "page-limit" => "20", "total-pages" => "50", "total-count" => "1000"}
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
    
See also [Common URL Options](../paginators#common-url-options)

==- Suggestions
<br/>

Instead of explicitly merging the headers before each rendering, if you use rails, you can add an `after_action` to your application controller:

```ruby Controller (after_action)
# It merges the headers if `@pagy` is initialized
after_action { response.headers.merge!(@pagy.headers_hash) if @pagy }

@pagy, records = pagy(:offset, collection, **options)
render json: records
```

If your code is consistent across different actions, you can encapsulate the statements in a custom `pagy_render` method in your
application controller. For example:

```ruby Controller

def pagy_render(collection, **)
  pagy, records = pagy(:offset, collection, **) # Any other paginator works as well
  response.headers.merge!(header_hash) # Adds pagination headers to the response
  render json: records
end

# And use it in your standard actions:
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
