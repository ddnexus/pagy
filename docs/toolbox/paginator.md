---
title: pagy • Paginator
icon: database
order: 200
categories:
  - Paginators
---

The `pagy` method starts every pagination. It wraps a collection and returns a pagy object and the page of results/records.

You get access to it by including the `Pagy::Backend` module in `ApplicationController`:

```ruby Controller
include Pagy::Backend
```

Then you use it in your actions:

```ruby Controller Action
@pagy, @records = pagy(:offset, collection, **options)
@pagy, @records = pagy(:keyset, set, **options)
@pagy, @records = pagy(...)
```
- `:offset`, `:keyset`, etc. are symbols identifying the [paginator](#paginators) to use, i.e. the internal method handling that type of pagination.
- `@pagy` is the pagination object. It provides an instance method for every UI components and helpers to use in your code.
- `@records` are the records belonging to the requested page


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
- `:max_pages`
  - Allow only `:max_pages`
- `jsonapi: true`
  - Enable JSON:API-compliant URLs and query_params
- `:page_sym`
  - Set it to change the symbol of the `:page` in URLs and query_params (default `:page`).
- `:limit_sym`
  - Set it to change the symbol of the `:limit` in URLs and query_params (default `:limit`).
- `:params`
  - Set it to a `Hash` of params to merge with the query params, or a `Lambda` that can edit/add/delete the request params (modify the query_params directly: the result is ignored). Keys
    must be strings.
- `:request_path`
  - Override the request path in pagination URLs. Pass the path only (not the absolute url). _(see [Pass the request path](/docs/Practical%20Guide/how-to.md#pass-the-request-path))_
- `:request`
  - **Set this hash only for non-rack environments**. _(It is set automatically from the request)_. For example:
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

==- Common Exceptions

!!! Exception for all paginators

Individual paginators may raise specific exceptions, wich are documented with the paginator itself.
!!!
- `Pagy::OptionError`
  - A subclass of `ArgumentError` that offers information to rescue invalid options passed to the constructor.
  - For example: `rescue Pagy::OptionError => e`
    - `e.pagy` the pagy object
    - `e.option` the offending option symbol (e.g. `:page`)
    - `e.value` the value of the offending option (e.g. `-3`)

==- Troubleshooting

##### Records may randomly repeat in different pages (or be missing)

<br/>

!!!danger Don't Paginate Unordered PostgreSQL Collections!

```rb
@pagy, @records = pagy_offset(unordered)

# behind the scenes, pagy selects the page of records with: 
unordered.offset(pagy.offset).limit(pagy.limit)
```

!!! warning

From the [PostgreSQL Documentation](https://www.postgresql.org/docs/16/queries-limit.html#:~:text=When%20using%20LIMIT,ORDER%20BY)

When using LIMIT, it is important to use an ORDER BY clause that constrains the result rows into a unique order. Otherwise, you
will get an unpredictable subset of the query's rows.

!!!

!!! success Ensure the PostgreSQL collection is ordered!

```rb
# results will be predictable with #order
ordered         = unordered.order(:id)
@pagy, @records = pagy_offset(ordered)
```

!!!

##### Invalid HTML

<br/>

!!!danger Don't rely on ARIA default with multiple nav elements!

Pagy sets the `aria-label` attribute of its `nav` elements with the translated and pluralized `pagy.aria_label.nav` that finds in
the locale files. That would be (always) `"Page"/"Pages"` for the `en` locale.

Since the `nav` or `role="navigation"` elements of a HTML document are considered `landmark  roles`, they should be uniquely
aria-identified in the page.
!!!

!!!success Pass your own `aria_label` to each nav!

```erb
<%# Explicitly set the aria_label string %>
<%== pagy_nav(@pagy, aria_label: 'Search result pages') %>
```

!!!
<hr>

!!!danger Don't duplicate attributes with the `:a_string_attributes`!

```erb
<%== pagy_bootstrap_nav(@pagy, a_string_attributes: 'class="my-class"', **opts) %>
```

The `class` attribute with a value of `"pagination"` is already added by the `pagy_bootstrap_nav` so it's a duplicate HTML
attribute which is invalid html.
!!!

!!!success Easily check the native component attributes!

```sh
pagy demo
# or: bundle exec pagy demo
# ...and point your browser at http://0.0.0.0:8000
```

!!!primary In the specific `bootstrap` example you could override the default bootstrap `"pagination"` class by adding other
classes with:

```ruby
@pagy, @records = pagy_bootstrap_nav(collection, classes: 'pagination my-class')
```

!!!

=== Paginators

[:icon-list-ordered: :offset](paginator/offset.md)<br/>
[:icon-list-ordered: :countless](paginator/countless.md)<br/>
[:icon-list-ordered: :keynav_js](paginator/keynav_js)<br/>
[:icon-infinity: :keyset](paginator/keyset.md)<br/>
[:icon-calendar: :calendar](paginator/calendar.md)<br/>
[:icon-search: :elasticsearch_rails](paginator/elasticsearch_rails.md)<br/>
[:icon-search: :meilisearch](paginator/meilisearch.md)<br/>
[:icon-search: :searchkick](paginator/searchkick.md)<br/>

===
