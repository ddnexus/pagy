---
title: pagy_keyset
icon: arrow-left
categories: 
- Backend
- Paginators
---

`pagy_keyset` is the fastest paginator for paginating a SQL collection.

Unlikely the classic OFFSET pagination, its performance are reliably fast from start to end, no matter how big is your table.

It's also completely accurate. Even with insertions or deletion of records during the browsing, you will never have repeating or
missing records from the pages, nor the expected `RangeError` of OFFSET pagination.

It **does not** support **ANY** helpers nor navigators, only API and infinite scrolling. However, for KEYSET pagination with all the `pagy_*nav` helpers, check out the [pagy_keynav](keynav.md)

```ruby Controller
@pagy, @records = pagy_keyset(set, **options)
```

#### Related Methods

- `pagy_keyset_first_url(@pagy, **options)`
  - Returns the url of the first page.
- `pagy_keyset_next_url(@pagy, **options)`
  - Returns the url of the next page.
