#

## :icon-list-unordered:&nbsp;&nbsp;headers_hash

---

`headers_hash` generates the standard `link` header defined in [RFC-8288](https://tools.ietf.org/html/rfc8288), and adds 4 customizable headers useful for pagination, which you can merge into the `response.headers`.

It also adheres to the header casing introduced by `rack` version `3+` _(see the [rack-issue](https://github.com/rack/rack/issues/1592))_.

!!!success It works with all paginators
!!!

=== :icon-tools:&nbsp; Usage

```rb Controller
# Any paginator will work
@pagy, @records = pagy(:offset, collection, **options)

# Merge the headers to the response
response.headers.merge!(@pagy.headers_hash)
render json: @records
```

==- :icon-pin:&nbsp; Examples

```ruby Console
require 'pagy/console'
=> true

>> @pagy, @records = pagy(:offset, collection.new, page: 3)
=> [#<Pagy::Offset:0x00007f0802c9a020 @request=#<Pagy::Request:0x00007f0802c84e28 @options={page: 3, request: #<Pagy::Request:0x00007f0802c84e28 ...>, client_limit: nil, limit: 20, count: 1000}, @base_url="http://www.example.com", @path="/path", @params={example: "123"}, @cookie=nil>, @options={limit: 20, limit_key: "limit", page_key: "page", page: 3, client_limit: nil, count: 1000}, @limit=20, @count=1000, @page=3, @last=50, @offset=40, @in_range=true, @from=41, @to=60, @in=20, @previous=2, @next=4>, [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]]

>> @pagy.headers_hash(absolute: true)
=> {"link" => "<http://www.example.com/path?example=123>; rel=\"first\", <http://www.example.com/path?example=123&page=2>; rel=\"prev\", <http://www.example.com/path?example=123&page=4>; rel=\"next\", <http://www.example.com/path?example=123&page=50>; rel=\"last\"", "current-page" => "3", "page-limit" => "20", "total-count" => "1000", "total-pages" => "50"}
```

```text Example of default output
link <https://example.com:8080/foo?page=1>; rel="first", <https://example.com:8080/foo?page=2>; rel="prev",
<https://example.com:8080/foo?page=4>; rel="next", <https://example.com:8080/foo?page=50>; rel="last"
current-page 3
page-limit 20
total-pages 50
total-count 1000
```

==- :icon-sliders:&nbsp; Options

`headers_map: {...}`
: Customize the headers:

    ```rb
    default_map = { page:  'current-page',
                    limit: 'page-limit',
                    count: 'total-count',
                    pages: 'total-pages' }

    # Optional customization
    headers_map = { page:  'current-page',
                    limit: 'per-page',
                    pages: false,  # disable the output
                    count: 'total' }
    headers = @pagy.headers_hash(headers_map:)
    # Note: You can also pass the `:headers_map` option to the paginator
    ```

`absolute: true`
: Makes the URL absolute.

`path: '/my_path'`
: Overrides the request path in pagination URLs. Use the path only (not the absolute URL). _(see [Override the request path](/guides/how-to#override-the-request-path))_

`fragment: '...'`
: URL fragment string.

`querify: tweak`
: Set it to a `lambda` to directly edit the passed string-keyed params hash itself. Its result is ignored.
  ```ruby
  tweak = ->(q) { q.except!('not_useful').merge!('custom' => 'useful') }
  ```

==- :icon-light-bulb:&nbsp; Suggestions

>>> Instead of explicitly merging the headers before each rendering...

If you use Rails, you can add an `after_action` to your application controller:

```ruby Controller (after_action)
# It merges the headers if `@pagy` is initialized
after_action { response.headers.merge!(@pagy.headers_hash) if @pagy }

# Paginate normally in your action
@pagy, records = pagy(:offset, collection, **options)
render json: records
```

>>> If your code is consistent across different actions...

You can encapsulate the statements in a custom `pagy_render` method in your application controller. For example:

```ruby Controller (method)
def pagy_render(collection, **)
  pagy, records = pagy(:offset, collection, **) # Any other paginator works as well
  response.headers.merge!(pagy.headers_hash)    # Adds pagination headers to the response
  render json: records
end

# And use it in your standard actions:
pagy_render(collection, **options)
```

>>>

===
