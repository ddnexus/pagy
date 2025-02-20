---
title: Paginators
icon: database
order: 100
---

**Paginators** are methods that wrap a collection and return a pagy object and the page of results/records.

Include the module in `ApplicationController`:

```ruby Controller
include Pagy::Paginators
```

!!!success Pagy's methods are autoloaded on demand. Unused methods consume no memory.
!!!

```ruby Controller Action
@pagy, @records = pagy_offset(collection, **options)
@pagy, @records = pagy_keyset(set, **options)
...
```

- `@pagy` is the pagination object: the first argument required by every `Backend` or `Frontend` helper/navigator method
- `@records` are the records belonging to the requested page

!!!warning Avoid direct instantiation of Pagy classes.

Instead, use the provided paginator methods, which handle the correct class selection and initialization.
!!!

==- Common Options

!!! Options for all paginators

Individual paginators may offer additional options, which are documented with the paginator itself.
!!!

- `:page`
  - Set it only to force the current `:page`. _(It is set automatically from the request params)_.
- `:limit`
  - Set the number of items per page (default `20`)
- `requestable_limit: max_limit`
  - Allow the client to set the `:limit` in the `request` params, up-to the `max_limit` value
- `jsonapi: true`
  - Enable JSON:API-compliant URLs and query_params
- `:params`
  - Set it to a `Hash` of params to merge with the query params, or a `Lambda` that can edit/add/delete the request params (modify the query_params: yhe result is ignored). Keys
    must be strings.
- `:max_pages`
  - Allow only `:max_pages`
- `:page_sym`
  - Set it to change the symbol of the `:page` in URLs and query_params (default `:page`).
- `:limit_sym`
  - Set it to change the symbol of the `:limit` in URLs and query_params (default `:limit`).
- `:request`
  - **Set this hash only for non-rack environments** _(It is set automatically from the request)_. For example: 
    ```ruby
     { base_url:     'http://www.example.com',
       path:         '/path',
       query_params: { 'param1' => 1234 } } # string keys only
    ```

==- Common Readers

!!! Readers for all paginators

Individual paginators may offer additional readers, wich are documented with the paginator itself.
!!!

- `page`
  - The current page
- `limit`
  - The items per page
- `options`
  - The options of the object
- `next`
  - The next page

=== Paginators

- [pagy_array](paginators/array.md)
- [pagy_calendar](paginators/calendar.md)
- [pagy_countless](paginators/countless.md)
- [pagy_keynav](paginators/keynav.md)
- [pagy_keyset](paginators/keyset.md)
- [pagy_offset](paginators/offset.md)
- [pagy_elasticsearch_rails](paginators/searches/elasticsearch_rails.md)
- [pagy_meilisearch](paginators/searches/meilisearch.md)
- [pagy_searchkick](paginators/searches/searchkick.md)

===
