---
label: data_hash
icon: list-unordered
order: 200
categories:
- Methods
- Helpers
---

#

## :icon-list-unordered: data_hash

---

`data_hash` plucks a hash of key-value pairs from the pagy object. It is useful for exporting pagination
data to JavaScript frameworks like Vue.js, React.js, etc.

!!!success It works with all paginators
!!!

```ruby Controller
@pagy, @records = pagy(:offset, collection, **options)
pagy_hash       = @pagy.data_hash(data_keys: %i[page previous next previous_url next_url ...])
#=> { page: 3, previous: 2, next: 4, previous_url: ... } 
render json: { data: @records, pagy: pagy_hash }
```

==- Examples

```ruby Console
require 'pagy/console'
=> true

>> @pagy, @records = pagy(:offset, collection.new, page: 3)
=> [#<Pagy::Offset:0x00007ff5843036e0 @count=1000, @from=41, @in=20, @in_range=true, @last=50, @limit=20, @next=4, @offset=40, @options={limit: 20, limit_key: "limit", page_key: "page", page: 3, count: 1000}, @page=3, @previous=2, @request=#<Pagy::Request:0x00007ff58497f230 @base_url="http://www.example.com", @cookie=nil, @jsonapi=nil, @path="/path", @params={example: "123"}>, @to=60>, [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]]

>> @pagy.data_hash(data_keys: %i[page previous next previous_url next_url])
=> {page: 3, previous: 2, next: 4, previous_url: "/path?example=123&page=2", next_url: "/path?example=123&page=4"}
```

==- Options

- `data_keys`
  - For efficiency, always set the `:data_keys` option to restrict the output to ONLY the keys you need among the default list:
    - `:count`
    - `:first_url`
    - `:from`
    - `:in`
    - `:last`
    - `:last_url`
    - `:limit`
    - `:next`
    - `:next_url`
    - `:options`
    - `:page`
    - `:page_url`
    - `:pages`
    - `:previous`
    - `:previous_url`
    - `:to`
    - `:url_template`
  - Notice that you can also add other pagy method names not included in the default list (see [this discussion](https://github.com/ddnexus/pagy/discussions/812) for an example)  

See also [Common URL Options](../paginators#common-url-options)

==- Usage of `:url_template`

This is a URL string containing the `"P "` page token as a placeholder for the page value.

For example: `'/foo?page=P &bar=baz'`.

Replace it with JavaScript to generate the actual page URLs:

```javascript
pageUrl = url_template.replace("P ", '123')
// Result: '/foo?page=123&bar=baz'
```

!!!warning You may not need it for simple cases!

Consider using the available `:*_url` data_keys directly instead of relying on the `:url_template`.
!!!

===
