---
title: Countless
categories:
- Backend
- Extra
---

# Countless Extra

Paginate without the need of any count, saving one query per rendering.

## Setup

```ruby pagy.rb (initializer)
require 'pagy/extras/countless'
```

## Modes

This extra uses the [Pagy::Countless subclass](/docs/api/countless.md) internally. You can use it in two different modes by
enabling the `:countless_minimal` variable (or not).

+++ Default mode

!!! success
Your app needs a full classic pagination UI
!!!

### Usage

<br>

```ruby Controller (eager loading)
@pagy, @records = pagy_countless(some_scope, ...)
```

This mode retrieves `items + 1` and uses the number of retrieved items to calculate the variables. It then removes the eventual
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

This mode is enabled by the `:countless_minimal` variable.

!!! info

- The `@records` collection is a regular scope.
- The `@pagy` object cannot be used with any helpers.
- The collection is over when `@records.size < @pagy.vars[:items]`

!!!

+++

## Variables

| Variable             | Description                       | Default |
|:---------------------|:----------------------------------|:--------|
| `:countless_minimal` | enable the countless minimal mode | `false` |

## Methods

==- `pagy_countless(collection, vars=nil)`

This method is the same as the generic `pagy` method (see the [pagy doc](/docs/api/backend.md#pagy-collection-vars-nil)), however
its returned objects will depend on the value of the `:countless_minimal` variable (see [Modes](#modes))

==- `pagy_countless_get_vars(_collection, vars)`

This sub-method is similar to the `pagy_get_vars` sub-method, but it is called only by the `pagy_countless` method. (see
the [pagy_get_vars doc](/docs/api/backend.md#pagy-get-vars-collection-vars)).

==- `pagy_countless_get_records(collection, pagy)`

This sub-method is similar to the `pagy_get_records` sub-method, but it is called only by the `pagy_countless` method. (see
the [pagy_get_records doc](/docs/api/backend.md#pagy-get-items-collection-pagy)).

===
