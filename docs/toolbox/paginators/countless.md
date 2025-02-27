---
title: :countless
icon: list-ordered
order: 90
categories:
  - Paginators
---

!!!warning Consider using the `:keynav_js` paginator when possible!

The [:keynav_js](paginator/keynav.md) has exactly the same UI features, but it uses the fastest `keyset` pagination, particularly convenient with big, slow collection results. 
!!!

`:countless` is an OFFSET paginator that skips the `COUNT` query, saving one query per rendering.

- It offers an **almost complete** support for **almost all** the navigation helpers, with just these limitations:
  1. The nav bar links after the last/higher visited page are not shown
  2. The `pagy_info` helper is not supported

```ruby Controller 
@pagy, @records = pagy(:countless, collection, **options)
```

- `@pagy` is the pagination object. It provides the [instance methods](../methods#instance-methods) to use in your code.
- `@records` is the eager-loaded `Array` of the page records.

==- Options

- `headless: true`
  - Use this option when you don't need any UI (e.g. infinite scrolling) and/or to avoid eager loading. In that case:
    - `@pagy` cannot be used with any helpers
    - `@records` is a regular collection
    - The collection is over when `@records.size < @pagy.limit`

See also [Offset Options](offset.md#options)

==- Readers

See [Offset Readers](offset.md#readers)

===
