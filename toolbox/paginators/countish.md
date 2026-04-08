#

## :icon-move-to-end:&nbsp;&nbsp;:countish

---

`:countish` is an [OFFSET](/guides/choose-right/#offset) paginator that memoizes the result of the `COUNT` query in the page links, running it only once per collection (instead of once per page), optionally recounting it when it's stale.

It **fully** supports all the helpers and navigators.

=== :icon-tools:&nbsp; Usage

```ruby Controller
# count only once and memoize for all pages
@pagy, @records = pagy(:countish, collection, **options)
# count once, memoize, and recount when the memoized count is older than ttl
@pagy, @records = pagy(:countish, collection, ttl: 300, **options)
```

- `@pagy` is the pagination instance. It provides the [readers](#readers) and the [helpers](../helpers) to use in your code.
- `@records` represents the paginated collection of records for the page (lazy-loaded records).
- `:ttl` is the Time To Live of the memoized count. Counts only once if `nil`.

==- :icon-sliders:&nbsp; Options

`ttl: 180`
: A positive number of seconds enables recounting. Set to `nil` (falsey) queries the DB for the COUNT only once, and reuse it for all the other pages served.

  !!!warning Recounting/TTL
  - Recounting gets the user more precise info and minimizes the page differences with lengthy page-browsing and abundant DB insertions/deletions.
    - It does not fix the OFFSET-intrinsic "drift" of records on active DB insertions/deletions.

`count_over: true`
: Use this option with `GROUP BY` collections to calculate the total number of results using `COUNT(*) OVER ()`.

`raise_range_error: true`
: Enable the `Pagy::RangeError` (which is otherwise rescued to an empty page by default).

`limit: 10`
: Specifies the number of items per page (default: `20`)

`max_limit: 200`
: Allow the client to request a `:limit` up to `:max_limit`. A higher requested `:limit` is silently capped.

  **IMPORTANT** If falsey or zero, the client cannot request any `:limit`.

`page: force_page`
: Set it only to force the current `:page`. _(It is set automatically from the request param)_.

`request: request || hash`
: Pagy tries to find the `Rake::Request` at `self.request`. Set it only when it's not directly available in your code (e.g., Hanami, standalone app, test,...). For example:
  ```ruby
  hash_request = { base_url: 'http://www.example.com',
                     path:     '/path',
                     params:   { 'param1' => 1234 }, # The string-keyed params hash from the request
                     cookie:   'xyz' }               # The 'pagy' cookie, only for keynav
  ```

`jsonapi: true`
: Enables JSON:API-compliant URLs with nested query string (e.g., `?page[number]=2&page[size]=100`).

`root_key: 'my_root'`
: Set it to enable nested URLs with nested query string `?my_root[page]=2&my_root[limit]=100`)). Use it to handle multiple pagination objects in the same request.

`page_key: 'my_page'`
: Set it to change the key string used for the `:page` in URLs (default `'page'`).

`limit_key: 'my_limit'`
: Set it to change the key string used for the `:limit` in URLs (default `'limit'`).

==- :icon-mention:&nbsp; Readers

`offset`
: The OFFSET used in the SQL query

`count`
: The collection count

`from`
: The position in the collection of the first item on the page. _(Different Pagy classes may use different value types for it)._

`to`
: The position in the collection of the last item on the page. _(Different Pagy classes may use different value types for it)._

`last`
: The last page.

`pages`
: The number of pages.

`previous`
: The previous page

`next`
: The next page

`page`
: The current page

`limit`
: The items per page

`in`
: The actual items in the page

`records`
: The fetched records for the current page.

`options`
: The hash of options of the object

===
