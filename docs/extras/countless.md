---
title: Countless
categories:
- Backend
- Extras
---

# Countless Extra

Save one count query per request using the [Pagy::Countless subclass](/docs/api/countless.md) internally.

## Setup

||| pagy.rb (initializer)
```ruby
require 'pagy/extras/countless'
# optionally enable the minimal mode by default
# Pagy::DEFAULT[:countless_minimal] = true
```
|||


## Modes

This extra can be used in two different modes by enabling or not the `:countless_minimal` variable.

+++ Default mode

!!! success
Your app needs a full classic pagination UI
!!!

### Usage

||| Controller (eager loading)
```ruby
@pagy, @records = pagy_countless(some_scope, ...)
```
|||

This mode retrieves `items + 1`, and uses the number of retrieved items to calculate the variables. It then removes the extra item from the result.

!!! info
- The `@records` collection is an eager-loaded `Array` of records.
- The `@pagy` object can be used with any supported helper.
!!!
+++ Minimal mode

!!! success
Your app uses no or limited pagination UI
!!!

### Usage

||| Controller (lazy loading)
```ruby
@pagy, @records = pagy_countless(some_scope, countless_minimal: true, ...)
```
|||

This mode is enabled by the `:countless_minimal` variable.

!!! info
- The `@records` collection is a regular scope.
- The `@pagy` object cannot be used with any helpers.
- The collection is over when `@records.size < @pagy.vars[:items]`. 
!!!

+++

## Variables

| Variable             | Description                       | Default |
|:---------------------|:----------------------------------|:--------|
| `:countless_minimal` | enable the countless minimal mode | `false` |

## Files

- [countless.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/countless.rb)

## Methods

==- `pagy_countless(collection, vars=nil)`

This method is the same as the generic `pagy` method (see the [pagy doc](/docs/api/backend.md#pagycollection-varsnil)), however its returned objects will depend on the value of the `:countless_minimal` variable (see [Modes](#modes))

==- `pagy_countless_get_vars(_collection, vars)`

This sub-method is similar to the `pagy_get_vars` sub-method, but it is called only by the `pagy_countless` method. (see the [pagy_get_vars doc](/docs/api/backend.md#pagy_get_varscollection-vars)).

==- `pagy_countless_get_items(collection, pagy)`

This sub-method is similar to the `pagy_get_items` sub-method, but it is called only by the `pagy_countless` method. (see the [pagy_get_items doc](/docs/api/backend.md#pagy_get_itemscollection-pagy)).

===
