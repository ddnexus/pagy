---
title: Array
categories:
  - Backend
  - Extra
---

# Array Extra

Paginate arrays efficiently.

!!!danger Bad!

```rb

def index
  @pagy, @comments = pagy_array(Comment.all.to_a) # your code is wasting memory!
end
```

Do not use `pagy_array` with any persistent storage collection (database, elastic search, Meilisearch etc)!
!!!

!!!success Good

```rb

def index
  @pagy, @special_items = pagy_array(array_from_memory)
end
```

Use with collections that are already loaded in memory. (e.g. arrays of cached indices, keys of hashes, pointers, etc.).
!!!

## Synopsis

```ruby pagy.rb (initializer)
require 'pagy/extras/array'
```

```ruby Controller
@pagy, @items = pagy_array(an_array, **vars)
```

## Methods

==- `pagy_array(array, vars=nil)`

This method is the same as the generic `pagy` method, but specialized for an Array. (see
the [pagy doc](/docs/api/backend.md#pagy-collection-vars-nil))

==- `pagy_array_get_vars(array)`

This sub-method is the same as the `pagy_get_vars` sub-method, but it is called only by the `pagy_array` method. (see
the [pagy_get_vars doc](/docs/api/backend.md#pagy-get-vars-collection-vars)).

===
