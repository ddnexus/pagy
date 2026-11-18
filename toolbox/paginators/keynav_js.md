#

## :icon-key:&nbsp;&nbsp;:keynav_js&nbsp;&nbsp;[!button variant="info" icon="alert" size="s" corners="pill" text="JavaScript Setup Required!"](/resources/javascript)

---

`:keynav_js` is a fast [KEYSET](/guides/choose-right/#keyset) paginator that supports the UI. It's a Pagy-exclusive technique.

The Keynav pagination adds the numeric variables (`@page`, `@last`, `@previous`, `@next`, `@in`) to its instances, supporting their usage with the UI. It does so by transparently exchanging data with the client, which stores the state of the pagination.

If something goes wrong on the client side, it falls back to the [:countless](countless.md) paginator seamlessly.

[!button corners="pill" variant="info" icon="play-24" text="Check it out with `bundle exec pagy keynav`"](/sandbox/playground/#keysets)

!!!warning This documentation extends the [:keyset](keyset.md) documentation.
It's easier to understand if you are familiar with the [:keyset](keyset.md) docs.
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
: Specifies the number of items per page (default: `20`).

`client_limit: 200`
: Allow the client to request a `:limit` up to `:client_limit`. A higher requested `:limit` is silently capped.

  **IMPORTANT** If falsey or zero, the client cannot request any `:limit`.

`page: force_page`
: Set it only to force the current `:page`. _(It is set automatically from the request param)_

`request: request || hash`
: Pagy tries to find the `Rack::Request` at `self.request`. Set it only when it's not directly available in your code (e.g., Hanami, standalone app, test,...). For example:
    ```ruby
    hash_request = { base_url: 'http://www.example.com',
                     path:     '/path',
                     params:   { 'param1' => 1234 }, # The string-keyed params hash from the request
                     cookie:   'xyz' }               # The 'pagy' cookie, only for keynav
    ```

`jsonapi: true`
: Enables JSON:API-compliant URLs with nested query string (e.g., `?page[number]=2&page[size]=100`).

`root_key: 'my_root'`
: Set it to enable nested URLs with nested query string `?my_root[page]=2&my_root[limit]=100`. Use it to handle multiple pagination objects in the same request.

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
: The next page.

`page`
: The current page.

`limit`
: The items per page.

`in`
: The actual items in the page.

`records`
: The fetched records for the current page.

`options`
: The hash of options of the object.

==- :icon-log:&nbsp; In Depth: Cutoffs Filtering

Let's take a new look at the diagram of the keyset pagination explained in the [Keyset documentation](keyset#in-depth-cutoffs):

```
                  │ first page (10)  >│ second page (10) >│ last page (9)  >│
beginning of set >[· · · · · · · · · X]· · · · · · · · · Y]· · · · · · · · ·]< end of set
                                      ▲                   ▲
                                   cutoff-X            cutoff-Y
```

Let's suppose that we navigate to page #3 (i.e., the last page), and we click on the link for page #2. We have stored the `cutoff-X`, so we can pull the 10 records after `cutoff-X` again as we did the first time... but are we sure that we would get the same results?

Let's suppose that the database just changed: 1 record was inserted before `cutoff-X`, and 2 records were deleted after `cutoff-X`...

```
                  │ page #1 (11)       >│ page #2 (8)  >│ page #3 (9)    >│
beginning of set >[· · · · · · · · · · X]· · · · · · · Y]· · · · · · · · ·]< end of set
                                        ▲               ▲
                                   cutoff-X        cutoff-Y
```

At this point, pulling 10 records from the `cutoff-X` would also get the first 2 records of page #3, and if you then navigate to page #3, you would pull the same 2 records again.

Indeed, not only have the results changed, but the cutoffs appear to have also shifted their absolute position in the set. In reality, the cutoffs have the same value as before, so they maintained their relative position in the set. However, now there is a different number of records falling into the same pages, which is totally consistent with the changes, but possibly unexpected. That is... if you have the mindset of OFFSET pagination, where the pages are split by number of records (absolute position) and not by their position relative to the records in the set.

!!!
The main goal of pagination is to split the results into manageable chunks and ensure it is as fast and accurate as possible, so the variation in the page size doesn't seem relevant to that. However, should it be relevant to you, you can always use the classic OFFSET pagination and accept its slowness and inaccuracy.
!!!

Pagy keynav pulls the records of the already visited pages with the same filter used for the `beginning` of the page, compounded with the negated filter of the `ending` of the page. It also keeps the LIMIT, so a page never holds more records than the limit.

For example, the filtering of the page could be logically described like:

```
- Page #1 `WHERE NOT AFTER CUTOFF-X LIMIT 10`                    <- only ending filter
- Page #2 `WHERE AFTER CUTOFF-X AND NOT AFTER CUTOFF-Y LIMIT 10` <- combined beginning + ending filter
- Page #3 `WHERE AFTER CUTOFF-Y LIMIT 10`                        <- regular beginning filter (no cutoff for last page)
```

==- :icon-log:&nbsp; In Depth: Page Rebalancing

When the number of records of a visited page has changed, Pagy rebalances that page at the moment you navigate to it.

##### Splitting a grown page

Let's suppose that 5 records were inserted in page #2, which now holds more records than the limit of 10:

```
                  │ page #1 (10)     >│ page #2 (15)               >│ page #3 (9)    >│
beginning of set >[· · · · · · · · · X]· · · · · · · · · · · · · · Y]· · · · · · · · ·]< end of set
                                      ▲                             ▲
                                   cutoff-X                      cutoff-Y
```

When you navigate to page #2, Pagy pulls only its first 10 records and adds the new `cutoff-W` after them. The remaining 5 records become the new page #3, and the pages after it keep their records and shift their number by one:

```
                  │ page #1 (10)     >│ page #2 (10)     >│ #3 (5) >│ page #4 (9)    >│
beginning of set >[· · · · · · · · · X]· · · · · · · · · W]· · · · Y]· · · · · · · · ·]< end of set
                                      ▲                   ▲         ▲
                                   cutoff-X            cutoff-W  cutoff-Y
```

##### Merging a short page

Let's suppose that 5 records were deleted from page #2:

```
                  │ page #1 (10)     >│ #2 (5) >│ #3 (5) >│ page #4 (9)    >│
beginning of set >[· · · · · · · · · X]· · · · W]· · · · Y]· · · · · · · · ·]< end of set
                                      ▲         ▲         ▲
                                   cutoff-X  cutoff-W  cutoff-Y
```

When you navigate to page #2, Pagy finds that its records and the records of page #3 fit together in the limit. It pulls them all as page #2 and removes the `cutoff-W`. The pages after it keep their records and shift their number back by one:

```
                  │ page #1 (10)     >│ page #2 (10)     >│ page #3 (9)    >│
beginning of set >[· · · · · · · · · X]· · · · · · · · · Y]· · · · · · · · ·]< end of set
                                      ▲                   ▲
                                   cutoff-X            cutoff-Y
```

##### Rules

- A page that holds more records than the limit is split.
- A page that holds fewer records than the limit is merged with the next page, when the records of both fit in the limit. Otherwise it keeps its records.
- An empty page is always removed, and the records of the next page take its place.
- A page followed by the last page is filled with the records that follow it.

Pagy never moves the cutoff between two visited pages that hold records, because that would change the records of all the pages after it.

!!!warning Keep the Pagy JavaScript in sync with the gem
The page rebalancing requires the [JavaScript](/resources/javascript.md) file of the same version of the gem. With an older file, a grown page is still limited, but its cutoff is moved instead of adding a new one, and the short and empty pages are not merged.
!!!

==- :icon-alert:&nbsp; Caveat

!!!warning Nav bar links beyond the highest visited page are not known/displayed.
!!!

!!!warning Only the page you navigate to is rebalanced.
Each one of a few consecutive empty pages is removed when you navigate to it.
!!!

===
