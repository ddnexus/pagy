---
title: pagy_array
icon: arrow-left
categories:
  - Backend
  - Paginators
---

`pagy_array` is a special offset-like paginator usable with Arrays collections.

It **fully** supports **ALL** the helpers and navigators.

```ruby Controller
@pagy, @records = pagy_array(array, **options)
```

!!!danger Bad!

```rb
def index
  @pagy, @comments = pagy_array(Comment.all.to_a) # your code is wasting memory!
end
```

Do not use `pagy_array` with any persistent storage collection (database, elastic search, Meilisearch, etc.)!
!!!

!!!success Good

```rb
def index
  @pagy, @special_items = pagy_array(array_from_memory)
end
```

Use with collections that are already loaded in memory. (e.g. arrays of cached indices, keys of hashes, pointers, etc.).
!!!

==- Options

See [pagy_offset options](offset.md#specific-options)

==- Readers

See [pagy_offset readers](offset.md#specific-readers)
                           
===
