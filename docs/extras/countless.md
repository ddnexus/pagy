---
title: Countless
categories:
- Backend
- Extra
---

# Countless Extra

Paginate without the need of any count, saving one query per rendering.

!!!success
If you don't need any frontend you should consider the [Pagy::Keyset pagination](/docs/api/keyset.md) that is even faster than countless, especially with big data
!!!

## Setup

```ruby pagy.rb (initializer)
require 'pagy/extras/countless'
```

## Modes

This extra uses the [Pagy::Countless subclass](/docs/api/countless.md) internally. You can use it in two different modes by
enabling the `:countless_minimal` option (or not).

+++ Default mode

!!! success
Your app needs a full classic pagination UI
!!!

### Usage

<br>

```ruby Controller (eager loading)
@pagy, @records = pagy_countless(some_scope, ...)
```

This mode fetches `limit + 1` and uses the number of fetched records to calculate the options. It then removes the eventual
extra item from the result, so deducing whether there is a `next` page or not without the need of an extra query.

!!! info

- The `@records` collection is an eager-loaded `Array` of records.
- The `@pagy` object can be used with any supported helper.

!!!
+++ Minimal mode

!!! success
Your app uses no or limited pagination UI
!!!

### Set Up countless_minimal mode

<br>

```ruby pagy.rb (initializer)
require 'pagy/extras/countless'
# optionally enable the minimal mode by default
# Pagy::DEFAULT[:countless_minimal] = true
```

### Usage

<br>

```ruby Controller (lazy loading)
@pagy, @records = pagy_countless(some_scope, countless_minimal: true, ...)
```

This mode is enabled by the `:countless_minimal` option.

!!! info

- The `@records` collection is a regular scope.
- The `@pagy` object cannot be used with any helpers.
- The collection is over when `@records.size < @pagy.limit`

!!!

+++

## Variables

| Variable             | Description                       | Default |
|:---------------------|:----------------------------------|:--------|
| `:countless_minimal` | enable the countless minimal mode | `false` |

## Methods

==- `pagy_countless(collection, **opts)`

This method is the same as the generic `pagy` method (see the [pagy doc](/docs/api/backend.md#pagy-collection-opts-nil)), however
its returned objects will depend on the value of the `:countless_minimal` option (see [Modes](#modes))

==- `pagy_countless_get_items(collection, pagy)`

This sub-method is similar to the `pagy_get_items` sub-method, but it is called only by the `pagy_countless` method. (see
the [pagy_get_items doc](/docs/api/backend.md#pagy-get-limit-collection-pagy)).

===
