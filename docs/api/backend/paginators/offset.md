---
title: pagy_offset
categories: 
- Backend
- Paginators
---

`pagy_offset` is a generic OFFSET paginator method, usable with ORMs collections.

It uses the full OFFSET pagination technique, which triggers two SQL queries: 

- a `COUNT` query to get the count
- an `OFFSET` + `LIMIT` query to get the records

It **fully** supports **ALL** the helpers and navigators.

```ruby Controller
@pagy, @records = pagy_offset(collection, **options)
```

==- Options

- `count_over: true`
  - Use this option with `GROUP BY` collections to get the total number of results using `COUNT(*) OVER ()`.
- `:count_args`
  - The arguments passed to the `collection.count` (default `[:all]`). You may want to set it to `[]` in ORMs different from `ActiveRecord` 

See also [Common Options](../paginators.md#common-options)

==- Readers

- `offset`
  - The OFFSET used in the SQL query
- `from`
  - The position in the collection of the first item in the page. Different Pagy classes can use diffrent value-types for it
- `to`
  - The position in the collection of the last item in the page. Different Pagy classes can use diffrent value-types for it

See also [Common Readers](../paginators.md#common-readers)

===
