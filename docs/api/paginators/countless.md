---
title: pagy_countless
icon: arrow-left
categories:
  - Backend
  - Paginators
---

!!!warning Consider using `pagy_keynav` when possible!
It has exactly the same UI features, but it uses the fastest `keyset` pagination, particular convenient with big, slow collection results. 
!!!

`pagy_countless` is an OFFSET paginator that skips the `COUNT` query, saving one query per rendering.

- It offers an **almost complete** support for **almost all** the navigation helpers, with just these limitations:
  - The nav bar links after the last known page are not shown
  - The `pagy_info` helper is not supported

```ruby Controller 
@pagy, @records = pagy_countless(collection, **options)
```

- `@pagy` can be used with any supported helper.
- `@records` is an eager-loaded `Array` of records.

==- Options

- `headless: true`
  - Use this option when you don't need any UI (e.g. infinite scrolling) and/or to avoid eager loading. In that case:
    - `@pagy` cannot be used with any helpers
    - `@records` is a regular scope
    - The collection is over when `@records.size < @pagy.limit`
 
See also [Common Options](../paginators.md#common-options)
===
