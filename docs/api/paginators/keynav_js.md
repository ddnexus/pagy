---
title: :keynav_js
icon: list-ordered
order: 80
categories:
  - Paginators
---

`:keynav_js` is a fast KEYSET paginator to use for the UI.

- It offers an **almost complete** support for **almost all** the navigation helpers, with just these limitations:
  - The nav bar links after the last known page are not shown
  - The `pagy_info` helper is not supported

```ruby Controller 
@pagy, @records = pagy(:keynav_js, collection, **options)
```

- `@pagy` is the pagination object. It provides the [instance methods](../pagy.md#instance-methods) to use in your code.
- `@records` is the eager-loaded `Array` of the page records.
