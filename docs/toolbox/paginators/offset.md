---
label: :offset
icon: move-to-end
order: 100
---

#

## :icon-move-to-end:&nbsp;&nbsp;:offset

---

`:offset` is a generic [OFFSET](/guides/choose-right/#offset) paginator usable with ORM collections or regular `Array` objects.

It uses the complete [OFFSET](/guides/choose-right/#offset) pagination technique, which triggers two SQL queries per request:

- a `COUNT` query to get the count;
- an `OFFSET` + `LIMIT` query to get the records.

It **fully** supports all the helpers and navigators.

!!!warning Consider using the `:countish` paginator when possible!
The [:countish](countish) paginator offers identical UI features, but it's up to 2x faster.
!!!

=== :icon-tools:&nbsp; Usage

```ruby Controller
@pagy, @records = pagy(:offset, collection, **options)
```

- `@pagy` is the pagination instance. It provides the [readers](#readers) and the [helpers](../helpers) to use in your code.
- `@records` represents the paginated collection of records for the page (lazy-loaded records).

==- :icon-sliders:&nbsp; Options

{{ include "options/offset" }}

==- :icon-mention:&nbsp; Readers

{{ include "snippets/offset-readers" }}

===
