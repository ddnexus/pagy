---
label: "pagy(:✳) Paginators" 
icon: database
order: 90
categories:
  - Paginators
---

#

##  pagy(<span style="font-size: .65em; vertical-align: middle">:✳</span>) Paginators

---

### The `pagy` Method

The `pagy` method provides a common interface to all paginators. Include it where you are going to paginate a collection _(usually in ApplicationController)_:

```ruby
include Pagy::Method
```
You can use it to paginate ANY collection, with ANY technique. For example:

```ruby
@pagy, @records = pagy(:offset, collection, **options)
@pagy, @records = pagy(:keyset, set, **options)
@pagy, @records = pagy(...)
```

- `:offset`, `:keyset`, etc. are symbols identifying the [paginator](#paginators). They implement the specific pagination. 
- `@pagy` is the pagination istance. It provides all the instance helper methods to use in your code.
- `@records` are the records belonging to the requested page.

!!!success

The `pagy` method expects to find the rack request at `self.request`, however, you can also use pagy [outside controllers or views](../guides/how-to/#use-pagy-outside-controllers-or-views), or even [with a non-rack app](../guides/how-to/#use-pagy-with-non-rack-apps).
!!!

### Paginators

The `paginators` are symbolic names of different pagination types/contexts (e.g., `:offset`, `:keyset`, `countless`, etc.). You pass the name to the `pagy` method and pagy will internally instantiate and handle the appropriate paginator class.

!!!warning Avoid instantiating Pagy classes directly

Instantiate paginator classes only if the documentation explicitly suggests it.
!!!

!!!success Paginators and classes are autoloaded only if used!

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

==- Common Options

!!!success Paginators can inherit and override options

See [Options](options)
!!!

!!! Common Options for Paginators

Individual paginators may offer additional options, which are documented with the paginator itself.
!!!

- `limit: 10`
  - Specifies the number of items per page (default: `20`)
- `max_pages: 500`
  - Restricts pagination to only `:max_pages`. _(Ignored by `Pagy::Calendar::*` unit instances)_
- `page: 3`
  - Set it only to force the current `:page`. _(It is set automatically from the request param)_.
- `client_max_limit: 1_000`
  - Set the maximum `:limit` that the client is allowed to `request`. Higher requested `:limit`s are silently capped. (If falsey, the client cannot request the `:limit`)
- `request: rake_request || hash`
  - Pagy tries to find the `Rake::Request` at `self.request`. Set it only when it's not directly available in your code (e.g., Hanami, standalone app, test,...). For example:
    ```ruby
    hash_request = { base_url: 'http://www.example.com',
                     path:     '/path',
                     params:   { 'param1' => 1234 }, # The string-keyed params hash from the request
                     cookie:   'xyz' }               # The 'pagy' cookie, only for keynav  
    ```

==- Common URL Options

!!! Common URL options for all [paginators](#paginators) and `@pagy` [helpers](helpers)

These options control give you full control over the URL composition.
!!!

- `absolute: true`
  - Makes the URL absolute.
- `fragment: '...'`
  - URL fragment string.
- `jsonapi: true`
  - Enables JSON:API-compliant URLs with nested query string (e.g., `?page[number]=2&page[size]=100`).
- `limit_key: 'custom_limit'`
  - Set it to change the key string used for the `:limit` in URLs (default `'limit'`).
- `page_key: 'custom_page'`
  - Set it to change the key string used for the `:page` in URLs (default `'page'`).
- `root_key: 'custom_root`
  - Set it to enable nested URLs with nested query string `?custom_root[page]=2&custom_root[limit]=100`)). Use it to handle multiple pagination objects in the same request.
- `path: '/custom_path'`
  - Overrides the request path in pagination URLs. Use the path only (not the absolute URL). _(see [Override the request path](../guides/how-to#paginate-multiple-independent-collections))_
- `querify: tweak`
  - Set it to a `Lambda` to directly edit the passed string-keyed params hash itself. Its result is ignored.
    ```ruby
    tweak = ->(q) { q.except!('not_useful').merge!('custom' => 'useful') }
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
  - A subclass of `ArgumentError` that offers information to rescue invalid options.
  - For example: `rescue Pagy::OptionError => e`
    - `e.pagy` the pagy object
    - `e.option` the offending option symbol (e.g. `:page`)
    - `e.value` the value of the offending option (e.g. `-3`)

==- Troubleshooting

##### Records may repeat in different pages be missing

<br/>

!!!danger Don't Paginate Unordered PostgreSQL Collections!

```rb
@pagy, @records = pagy(:offset, unordered)

# behind the scenes, pagy selects the page of records with: 
unordered.offset(pagy.offset).limit(pagy.limit)
```

!!!warning

Citation: [PostgreSQL Documentation](https://www.postgresql.org/docs/16/queries-limit.html#:~:text=When%20using%20LIMIT,ORDER%20BY)

When using LIMIT, always include an ORDER BY clause to constrain the result rows into a unique order. Otherwise, the subset of rows retrieved may be unpredictable.

!!!

!!!success Ensure the PostgreSQL collection is ordered!

```rb
# Results will be consistent and predictable with #order
ordered         = unordered.order(:id)
@pagy, @records = pagy_offset(ordered)
```

!!!

===
