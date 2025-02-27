---
title: :offset
icon: list-ordered
order: 100
categories: 
  - Paginators
---

`:offset` is a generic OFFSET paginator usable with ORMs collections, and regular `Array` objects.

It uses the full OFFSET pagination technique, which triggers two SQL queries: 

- a `COUNT` query to get the count
- an `OFFSET` + `LIMIT` query to get the records

It **fully** supports **ALL** the helpers and navigators.

```ruby Controller
@pagy, @records = pagy(:offset, collection, **options)
```

==- Options

- `count_over: true`
  - Use this option with `GROUP BY` collections to get the total number of results using `COUNT(*) OVER ()`.
- `:count_arguments`
  - The arguments passed to the `collection.count` (default `[:all]`). You may want to set it to `[]` in ORMs different from `ActiveRecord` 
- `raise_range_error: true`
  - Enable the `Pagy::RangeError` (wich is rescued to an empty page by default)

See also [Common Options](../paginators#common-options)

==- Readers

- `offset`
  - The OFFSET used in the SQL query
- `count`
  - The collection count
- `from`
  - The position in the collection of the first item in the page. Different Pagy classes can use diffrent value-types for it
- `to`
  - The position in the collection of the last item in the page. Different Pagy classes can use diffrent value-types for it
- `in`
  - The actual items in the page
- `previous`
  - The previous page
- `last`
  - The last page
- `records`
  - The fetched records for the current page.  

See also [Common Readers](../paginators#common-readers)

==- Exceptions

- `Pagy::RangeError`
  - A subclass of `Pagy::OptionError`. Raised for out-of-range `:page` requests, with `raise_range_error: true` option.

See also [Common Exceptions](../paginators#common-exceptions)

===
