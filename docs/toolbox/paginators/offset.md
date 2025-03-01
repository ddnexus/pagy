---
label: :offset
icon: list-ordered
order: 100
categories: 
  - Paginators
---

#

## :icon-list-ordered: :offset

---

`:offset` is a generic OFFSET paginator usable with ORM collections and regular `Array` objects.

It uses the complete OFFSET pagination technique, which triggers two SQL queries:

- a `COUNT` query to get the count
- an `OFFSET` + `LIMIT` query to get the records

It **fully** supports all the helpers and navigators.

```ruby Controller
@pagy, @records = pagy(:offset, collection, **options)
```

==- Options

- `:count_arguments`
  - The arguments passed to the `collection.count` (default: `[:all]`). You may want to set it to `[]` in ORM systems other than `ActiveRecord`. 
- `count_over: true`
  - Use this option with `GROUP BY` collections to calculate the total number of results using `COUNT(*) OVER ()`.
- `raise_range_error: true`
  - Enable the `Pagy::RangeError` (which is rescued to an empty page by default).

See also [Common Options](../paginators#common-options)

==- Readers

- `offset`
  - The OFFSET used in the SQL query
- `count`
  - The collection count
- `from`
  - The position in the collection of the first item on the page. _(Different Pagy classes may use different value types for it)._
- `to`
  - The position in the collection of the last item on the page. _(Different Pagy classes may use different value types for it)._
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
  - A subclass of `Pagy::OptionError`. Raised for out-of-range `:page` requests when the `raise_range_error: true` option is enabled.

See also [Common Exceptions](../paginators#common-exceptions)

===
