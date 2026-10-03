---
label: :countless
icon: move-to-end-24
order: 90
---

#

## :icon-move-to-end:&nbsp;&nbsp;:countless

---

`:countless` is an [OFFSET](/guides/choose-right/#offset) paginator that avoids the `COUNT` query, cutting the number of queries per page in half. UI helpers work with some limitations (see [Caveat](#caveat)).

!!!warning Consider using the `:keynav_js` paginator when possible!
The [:keynav_js](keynav_js.md) offers identical UI features but uses the faster [KEYSET](/guides/choose-right/#keyset) pagination.
!!!

=== :icon-tools:&nbsp; Usage

```ruby Controller
@pagy, @records = pagy(:countless, collection, **options)
```

- `@pagy` is the pagination instance. It provides the [readers](#readers) and the [helpers](../helpers) to use in your code.
- `@records` represents the eager-loaded `Array` of records for the page.

==- :icon-sliders:&nbsp; Options

`headless: true`
: Use this option when UI is unnecessary (e.g., for infinite scrolling) and/or to skip eager loading. In this scenario:
  - `@pagy` is incompatible with any helpers.
  - `@records` behaves like a standard collection.
  - The collection ends when `@records.size < @pagy.limit`.

{{ include "options/offset" }}

==- :icon-mention:&nbsp; Readers

{{ include "snippets/offset-readers" }}

==- :icon-alert:&nbsp; Caveat

!!!warning Nav bar links beyond the highest visited page are not known/displayed.
!!!

===
