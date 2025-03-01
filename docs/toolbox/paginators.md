---
label: pagy 🐸 Paginators
icon: database
order: 90
categories:
  - Paginators
---

#

## 🐸 Paginators

---

The `pagy` method starts every pagination. It paginates a collection and returns the `@pagy` instance and the page of `@records`.

Include the `Pagy::Method` where you are going to use it _(usually in ApplicationContoller)_:

```ruby
include Pagy::Method
```

Now, you can use it to paginate ANY collection, with ANY technique:

```ruby
@pagy, @records = pagy(:offset, collection, **options)
@pagy, @records = pagy(:keyset, set, **options)
@pagy, @records = pagy(...)
```
- `:offset`, `:keyset`, etc. are symbols identifying the [paginator](#paginators) to use, i.e. the internal method handling that type of pagination.
- `@pagy` is the pagination istance. It provides methods for every UI components and helpers to use in your code.
- `@records` are the records belonging to the requested page


==- Common Options

!!! Common Options for Paginators

Individual paginators may offer additional options, which are documented with the paginator itself.
!!!

- `:page`
  - Set it only to force the current `:page`. _(It is set automatically from the request params)_.
- `:limit`
  - Specifies the number of items per page (default: `20`)
- `requestable_limit: max_limit`
  - Allows the client to set the `:limit` in the `request` params, up to the `max_limit` value
- `:max_pages`
  - Restricts pagination to only `:max_pages`. (`Pagy::Calendar::*` unit objects ignore it)
- `jsonapi: true`
  - Enables JSON:API-compliant URLs and query_params
- `:page_sym`
  - Set it to change the symbol of the `:page` in URLs and query_params (default `:page`).
- `:limit_sym`
  - Set it to change the symbol of the `:limit` in URLs and query_params (default `:limit`).
- `:params`
  - Set it to a `Hash` of params to merge with the query params.
  - Set it to  a `Lambda` to edit/add/delete the request params (modify the query_params directly: the result is ignored). Keys
    must be strings.
- `:request_path`
  - Overrides the request path in pagination URLs. Pass the path only (not the absolute URL). _(see [Pass the request path](../guides/how-to.md#paginate-multiple-independent-collections))_
- `:request`
  - **Set this hash only in non-rack environments** or when instructed by the docs. _(It is set automatically from the request)_. For example:
    ```ruby
     { base_url:     'http://www.example.com',
       path:         '/path',
       query_params: { 'param1' => 1234 } } # string keys only
    ```

==- Common Readers

!!! Common Readers for Paginators

Individual paginators may offer additional readers, which are documented with the paginator itself.
!!!

- `page`
  - The current page
- `limit`
  - The items per page
- `options`
  - The options of the object
- `next`
  - The next page

==- Common Exceptions

!!! Common Exceptions for Paginators

Individual paginators may raise specific exceptions, which are documented with the paginator itself.
!!!
- `Pagy::OptionError`
  - A subclass of `ArgumentError` that offers information to rescue invalid options passed to the constructor.
  - For example: `rescue Pagy::OptionError => e`
    - `e.pagy` the pagy object
    - `e.option` the offending option symbol (e.g. `:page`)
    - `e.value` the value of the offending option (e.g. `-3`)

==- Troubleshooting

##### Records may repeat in different pages (or sometimes be missing)

<br/>

!!!danger Don't Paginate Unordered PostgreSQL Collections!

```rb
@pagy, @records = pagy(:offset, unordered)

# behind the scenes, pagy selects the page of records with: 
unordered.offset(pagy.offset).limit(pagy.limit)
```

!!! warning

Citation: [PostgreSQL Documentation](https://www.postgresql.org/docs/16/queries-limit.html#:~:text=When%20using%20LIMIT,ORDER%20BY)

When using LIMIT, always include an ORDER BY clause to constrain the result rows into a unique order. Otherwise, the subset of rows retrieved may be unpredictable.

!!!

!!! success Ensure the PostgreSQL collection is ordered!

```rb
# Results will be consistent and predictable with #order
ordered         = unordered.order(:id)
@pagy, @records = pagy_offset(ordered)
```

!!!

=== Paginators

  !!!success Paginators are autoloaded only if used!

  Unused code consumes no memory.
  !!!

[:icon-list-ordered: :offset](paginators/offset.md)<br/>
[:icon-list-ordered: :countless](paginators/countless.md)<br/>
[:icon-list-ordered: :keynav_js](paginators/keynav_js)<br/>
[:icon-infinity: :keyset](paginators/keyset.md)<br/>
[:icon-calendar: :calendar](paginators/calendar.md)<br/>
[:icon-search: :elasticsearch_rails](paginators/elasticsearch_rails.md)<br/>
[:icon-search: :meilisearch](paginators/meilisearch.md)<br/>
[:icon-search: :searchkick](paginators/searchkick.md)<br/>

===
