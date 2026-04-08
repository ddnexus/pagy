#

## :icon-key:&nbsp;&nbsp;:keynav_js&nbsp;&nbsp;[!button variant="info" icon="alert" size="s" corners="pill" text="JavaScript Setup Required!"](/resources/javascript)

---

`:keynav_js` is a fast [KEYSET](/guides/choose-right/#keyset) paginator that supports the UI. It's a pagy exclusive technique.

The Keynav pagination adds the numeric variables (`@page`, `@last`, `@previous`, `@next`, `@in`) to its instances, supporting their usage with the UI. It does so by transparently exchanging data with the client, that stores the state of the pagination.

If something goes wrong on the client side, it falls back to the [:countless](countless.md) paginator seamlessly.

[!button corners="pill" variant="info" icon="play-24" text="Check it out with `bundle exec pagy keynav`"](/sandbox/playground/#keysets)

!!!warning This documentation extends the [:keyset](keyset.md) documentation.
It's easier to understand if you familiarize with the [:keyset](keyset.md) docs.
!!!

==- :icon-list-ordered:&nbsp; Setup

>>> [Keyset Setup](keyset#setup)

>>> [JavaScript Support](/resources/javascript.md)

>>>

=== :icon-tools:&nbsp; Usage

```ruby Controller
@pagy, @records = pagy(:keynav_js, collection, **options)
```

- `@pagy` is the pagination instance. It provides the [readers](#readers) and the [helpers](../helpers) to use in your code.
- `@records` is the eager-loaded `Array` of the page records.

==- :icon-sliders:&nbsp; Options

`keyset: {...}`
: Set it only to force the `keyset` hash of column/order pairs. _(It is set automatically from the set order)_

`tuple_comparison: true`
: Enable the tuple comparison e.g. `(brand, id) > (:brand, :id)`. It works only with the same direction order, hence, it's ignored for mixed order. Check how your DB supports it (your `keyset` should include only `NOT NULL` columns).

`pre_serialize: serialize`
: Set it to a `lambda` that receives the `keyset_attributes` hash. Modify this hash directly to customize the serialization of specific values (e.g., to preserve `Time` object precision). The lambda's return value is ignored.
  ```ruby
  serialize = lambda do |attributes|
    # Convert it to a string matching the stored value/format in SQLite DB
    attributes[:created_at] = attributes[:created_at].strftime('%F %T.%6N')
  end
  ```

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

==- :icon-log:&nbsp; In-depth: Cutoffs Filtering

Let's take a new look at the diagram of the keyset pagination explained in the [Keyset documentation](keyset#in-depth-cutoffs):

```
                  │ first page (10)  >│ second page (10) >│ last page (9)  >│
beginning of set >[· · · · · · · · · X]· · · · · · · · · Y]· · · · · · · · ·]< end of set
                                      ▲                   ▲
                                   cutoff-X            cutoff-Y
```

Let's suppose that we navigate till page #3 (i.e., the last page), and we click on the link for page #2. We have stored the `cutoff-X`, so we can pull the 10 records after `cutoff-X` again as we did the first time... but are we sure that we would get the same results?

Let's suppose that the database just changed: 1 record was inserted before `cutoff-X`, and 2 records were deleted after `cutoff-X`...

```
                  │ page #1 (11)       >│ page #2 (8)  >│ page #3 (9)    >│
beginning of set >[· · · · · · · · · · X]· · · · · · · Y]· · · · · · · · ·]< end of set
                                        ▲               ▲
                                   cutoff-X        cutoff-Y
```

At this point pulling 10 records from the `cutoff-X` would get also the first 2 records from page 3, if you navigate on page 3, you will pull the same 2 records again also for page #3.

Indeed, not only the results have changed, but the cutoffs appear to have also shifted their absolute position in the set. In reality, the cutoffs have the same value as before, so they maintained their relative position in the set. However, now there is a different number of records falling into the same pages, which is totally consistent with the changes, but possibly unexpected. That is... if you have the mindset of OFFSET pagination, where the pages are split by number of records (absolute position) and not by their position relative to the records in the set.

!!!
The main goal of pagination is to split the results into manageable chunks and ensure it is as fast and accurate as possible, so the variation in the page size seems not relevant to that. However, should it be relevant to you, you can always use the classic OFFSET pagination and accept its slowness and inaccuracy.
!!!

Pagy keynav doesn't use the LIMIT to pull the records of already visited pages. Instead, it replaces the LIMIT with the same filter used for the `beginning` of the page, but it just compounds it with the negated filter of the `ending` of the page.

For example, the filtering of the page could be logically described like:

```
- Page #1 `WHERE NOT AFTER CUTOFF-X`                    <- only ending filter
- Page #2 `WHERE AFTER CUTOFF-X AND NOT AFTER CUTOFF-Y` <- combined beginning + ending filter
- Page #3 `WHERE AFTER CUTOFF-Y LIMIT 10`               <- regular beginning filter (no cutoff for last page)
```

!!! Implementing page-rebalancing
When the number of records on a visited page has drastically changed, it would be helpful to mitigate the surprise effect on the user by:

- Automatically compacting the empty (or almost empty) visited pages.
- Automatically splitting the excessively grown visited pages.
!!!

==- :icon-alert:&nbsp; Caveat

!!!warning Nav bar links beyond the highest visited page are not known/displayed.
!!!

===
