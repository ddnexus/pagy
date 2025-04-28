---
label: :countless
icon: list-ordered
order: 90
categories:
  - Paginators
---

#

## :icon-list-ordered: :countless

---

`:countless` is an OFFSET paginator that avoids the `COUNT` query, reducing the number of queries per request by one.

!!!warning Consider using the `:keynav_js` paginator when possible!

The [:keynav_js](keynav_js.md) offers identical UI features but utilizes the faster `keyset` pagination.
!!!

```ruby Controller 
@pagy, @records = pagy(:countless, collection, **options)
```

- `@pagy` is the pagination instance. It provides the [readers](#readers) and the [instance methods](../methods#methods) to use in your code.
- `@records` represents the eager-loaded `Array` of records for the page.

==- Options

- `headless: true`
  - Use this option when UI is unnecessary (e.g., for infinite scrolling) and/or to skip eager loading. In this scenario:
    - `@pagy` is incompatible with any helpers.
    - `@records` behaves like a standard collection.
    - The collection ends when `@records.size < @pagy.limit`.

See also [Offset Options](offset#options)

==- Readers

See [Offset Readers](offset#readers)

==- Caveat

Nav bar links beyond the last or highest visited page are not displayed.

===
