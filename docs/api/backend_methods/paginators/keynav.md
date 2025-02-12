---
title: pagy_keynav
categories: 
- Backend
- Paginators
---

`pagy_keyset` is a KEYSET paginator usable with `ActiveRecord::Relation` and `Sequel::Dataset` ordered set.

It uses the fastest pagination technique, which triggers two SQL queries:

It **does not** support **ANY** helpers nor navigators.

```ruby Controller
@pagy, @records = pagy_keyset(set, **options)
```

#### Related Methods

- `pagy_keyset_first_url(@pagy, **options)`
  - Returns the url of the first page.
- `pagy_keyset_next_url(@pagy, **options)`
  - Returns the url of the next page.
