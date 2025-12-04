---
label: :countish
icon: list-ordered
order: 95
categories:
  - Paginators
---

#

## :icon-list-ordered: :countish

---

`:countish` is an OFFSET paginator that memoizes the result of the `COUNT` query, running it only once per collection (instead of once per page), and optionally recounting it when it's stale.

It **fully** supports all the helpers and navigators.


```ruby Controller 
# count only once and memoize for all pages
@pagy, @records = pagy(:countish, collection, **options)
# count once, memoize, and recount when the memoized count is older than ttl
@pagy, @records = pagy(:countish, collection, ttl: 300, **options)
```

- `@pagy` is the pagination instance. It provides the [readers](#readers) and the [helpers](../helpers) to use in your code.
- `@records` represents the paginated collection of records for the page (lazy-loaded records).
- `:ttl` is the Time To Live of the memoized count. Counts only once if `nil`.

==- Options

- `:ttl` (Time To Live in seconds)
  - Let it `nil` (falsey) to query the DB for the COUNT only once, and reuse it for all the other pages served.
  - Set it to a positive number of seconds to enable recounting.

!!!warning Recounting/TTL

- Recounting gets the user more precise info and minimizes the page differences with lengthy page-browsing and abundant DB insertions/deletions.
- It does not fix the OFFSET-intrinsic "drift" of records on active DB insertions/deletions.

!!!

See also [Offset Options](offset#options)

==- Readers

See [Offset Readers](offset#readers)

===
