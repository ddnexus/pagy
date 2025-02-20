---
title: pagy
icon: database
order: 200
categories:
  - Paginators
---

# pagy (method)

The `pagy` method starts every pagination. It wraps a collection and returns a pagy object and the page of results/records.

You get access to it by including the `Pagy::Backend` module in `ApplicationController`:

```ruby Controller
include Pagy::Backend
```

Then you use it in your actions:

```ruby Controller Action
@pagy, @records = pagy(:offset, collection, **options)
@pagy, @records = pagy(:keyset, set, **options)
...
```
- `:offset`, `:keyset`, etc. are symbols identifying the paginator to use, i.e. the internal method handling that type of pagination.
- `@pagy` is the pagination object. It provides all the UI components and helpers to use in your code, as instance methods.
- `@records` are the records belonging to the requested page


!!!success All the pagy methods are autoloaded on demand. Unused methods consume no memory.
!!!

!!!warning Avoid direct instantiation of Pagy classes.

Instead, use the `pagy` method, which handle the correct class selection and initialization.
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
  - Set it to a `Hash` of params to merge with the query params, or a `Lambda` that can edit/add/delete the request params (modify the query_params directly: the result is ignored). Keys
    must be strings.
- `:max_pages`
  - Allow only `:max_pages`
- `:page_sym`
  - Set it to change the symbol of the `:page` in URLs and query_params (default `:page`).
- `:limit_sym`
  - Set it to change the symbol of the `:limit` in URLs and query_params (default `:limit`).
- `:request_path`
  - Override the request path in pagination URLs. Pass the path only (not the absolute url). _(see [Pass the request path](/docs/Practical%20Guide/how-to.md#pass-the-request-path))_
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

==- Exceptions

- `Pagy::OptionError`
  - A subclass of `ArgumentError` that offers information to rescue invalid options passed to the constructor.
  - For example: `rescue Pagy::OptionError => e`
    - `e.pagy` the pagy object
    - `e.option` the offending option symbol (e.g. `:page`)
    - `e.value` the value of the offending option (e.g. `-3`)

=== Paginators

- [:offset](paginators/offset.md)
- [:countless](paginators/countless.md)
- [:keyset](paginators/keyset.md)
- [:keynav](paginators/keynav.md)
- [:calendar](paginators/calendar.md)
- [:elasticsearch_rails](paginators/elasticsearch_rails.md)
- [:meilisearch](paginators/meilisearch.md)
- [:searchkick](paginators/searchkick.md)

===
