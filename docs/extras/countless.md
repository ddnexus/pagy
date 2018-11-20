---
title: Countless
---
# Countless Extra

This extra uses the `Pagy::Countless` subclass in order to avoid to execute an otherwise needed count query. It is especially useful when used with large DB tables, where [Caching the count](../how-to.md#caching-the-count) may not be an option.

Its usage is practically the same as the regular `Pagy::Backend` module (see the [backend doc](../api/backend.md).

The pagination resulting from this extra has some limitation as documented in the [Pagy::Countless Caveats doc](../api/countless.md#caveats).

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/countless'
```

In a controller:

```ruby
@pagy, @records  = pagy_countless(some_scope, ...)
```

## Files

This extra is composed of 1 file:

- [countless.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/countless.rb)

## Methods

All the methods in this module are prefixed with the `"pagy_countless"` string, to avoid any possible conflict with your own methods when you include the module in your controller. They are also all private, so they will not be available as actions. The methods prefixed with the `"pagy_countless_get_"` string are sub-methods/getter methods that are intended to be overridden, not used directly.

### pagy_countless(collection, vars=nil)

This method is the same as the generic `pagy` method. (see the [pagy doc](../api/backend.md#pagycollection-varsnil))

### pagy_countless_get_vars(_collection, vars)

This sub-method is similar to the `pagy_get_vars` sub-method, but it is called only by the `pagy_countless` method. (see the [pagy_get_vars doc](../api/backend.md#pagy_get_varscollection-vars)).

### pagy_countless_get_items(collection, pagy)

This sub-method is similar to the `pagy_get_items` sub-method, but it is called only by the `pagy_countless` method. (see the [pagy_get_items doc](../api/backend.md#pagy_get_itemscollection-pagy)).

**Notice**: This method calls `to_a` on the collection in order to `pop` the eventual extra item from the result, so it returns an `Array`. That's different than the regular `pagy_get_items` method which doesn't need to call `to_a` on the collection.

