---
title: data_hash
icon: list-unordered
order: 200
categories:
- Instance Methods
- Helpers
---

`data_hash` extracts a hash of the key/values that you pluck from the pagy object. It is useful to export the pagination
data to Javascript frameworks like Vue.js, react.js, etc.

```ruby Controller (action)
@pagy, @records = pagy(:offset, collection, **options)
pagy_hash       = @pagy.data_hash(data_keys: %i[page previous next previous_url next_url ...])
#=> { page: 3, previous: 2, next: 4, previous_url: ... } 
render json: { data: @records, pagy: pagy_hash }
```

==- Options

- `data_keys`
  - For efficiency reasons you should always set the `:data_keys` option to restrict the output to ONLY the keys that you use.
    Notice that you can also add other pagy method names not included in the default below:
    - count
    - first_url
    - from
    - in
    - last
    - last_url
    - limit
    - next
    - next_url
    - options
    - page
    - page_url
    - pages
    - previous
    - previous_url
    - sequels
    - series
    - to
    - url_template
- `absolute: true`
  - URL absolute
- `fragment: '#...'`
  - URL fragment string


==- Usage of `:url_template`

This is a URL string containing the `"P "` page token in place of the page value. 

For example: `'/foo?page=P &bar=baz'`).

Replace it with Javascript to create the actual page URLs:

```js
pageUrl = url_template.replace("P ", '123')
// '/foo?page=123&bar=baz'
```

!!!warning You may not need it for simple cases!

Consider to use the few `:*_url` data_keys directly, instead of using the `:url_template`.
!!!

===
