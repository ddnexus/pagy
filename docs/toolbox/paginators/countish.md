---
label: :countish
icon: move-to-end-24
order: 95
nav:
  badge:
    text: "NEW"
    variant: info
---

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
: A positive number of seconds enables recounting. Setting it to `nil` (falsey) queries the DB for the COUNT only once, and reuses it for all the other pages served.

  !!!warning Recounting/TTL
  - Recounting gets the user more precise info and minimizes the page differences with lengthy page-browsing and abundant DB insertions/deletions.
  - It does not fix the OFFSET-intrinsic data-shift of records on active DB insertions/deletions.
  !!!

{{ include "options/offset" }}

==- :icon-mention:&nbsp; Readers

{{ include "snippets/offset-readers" }}

===
