---
title: Paginators
icon: database
order: -50
---

**Paginators** are methods that wrap a collection and return a pagy object and the page of results/records.

Use them in your app by including the module in `ApplicationController`:

```ruby Controller
include Pagy::Paginators
```

!!!success Pagy's methods are loaded on demand. Unused methods consume no memory.
!!!

```ruby Controller Action
@pagy, @records = pagy_offset(collection, **options)
```

- `@pagy` is the pagination object: the first argument required by every `Backend` or `Frontend` helper/navigator method
- `@records` are the records belonging to the requested page

!!!warning Avoid direct instantiation of Pagy classes.

Instead, use the provided paginator methods, which handle the correct class selection and initialization.
!!!

==- Options (for all paginators)

- `:page`
  - Set it only to force the current `:page`. _(It is sets automatically from the request params)_.
- `:limit`
  - Set the number of items per page (default `20`)
- `requestable_limit: max_limit`
  - Allow the client to set the `:limit` in the `request` params, up-to the `max_limit` value
- `jsonapi: true`
  - Enable JSON:API-compliant URLs and query_params
- `:params`
  - Set it to a `Hash` of params to merge with the query params, or a `Lambda` that can edit/add/delete the request params. Keys
    must be strings.
- `:max_pages`
  - Allow only `:max_pages`
- `:page_sym`
  - Set it to change the symbol of the `:page` in URLs and query_params (default `:page`).
- `:limit_sym`
  - Set it to change the symbol of the `:limit` in URLs and query_params (default `:limit`).

!!! Individual paginators may offer additional options, which are documented with the paginator itself.
!!!

==- Readers (for all paginators)

- `page`
  - The current page
- `previous`
  - The previous page
- `next`
  - The next page
- `last`
  - The last page
- `limit`
  - The items per page
- `in`
  - The actual items in the page
- `options`
  - The options of the object
- `count`
  - The collection count. `nil` for countless pagination techniques

!!! Individual paginators may offer additional readers, wich are documented with the paginator itself.
!!!

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
