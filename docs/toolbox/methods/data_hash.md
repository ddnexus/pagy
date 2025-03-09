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

`data_hash` extracts a hash of key-value pairs that you pluck from the pagy object. It is useful for exporting pagination
data to JavaScript frameworks like Vue.js, React.js, etc.

!!!success It works with all paginators
!!!

```ruby Controller
@pagy, @records = pagy(:offset, collection, **options)
pagy_hash       = @pagy.data_hash(data_keys: %i[page previous next previous_url next_url ...])
#=> { page: 3, previous: 2, next: 4, previous_url: ... } 
render json: { data: @records, pagy: pagy_hash }
```

==- Options

- `data_keys`
  - For efficiency, always set the `:data_keys` option to restrict the output to ONLY the keys you need.
    Note that you can also add other pagy method names not included in the default list below:
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

See also [Common URL Options](../paginators.md#common-url-options)

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
