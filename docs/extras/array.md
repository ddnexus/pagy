---
title: Array
---
# Array Extra

This extra adds a specialized pagination for arrays without the need to override the `pagy_get_items` in your controller, and without the need to use any expensive array-wrapping or patching.

### WARNING!

_This warning may sound obvious, but I keep finding people improperly using this extra, so let me write it explicitly._

The `array` extra is efficient if you really need to paginate an array, but if the data in the array comes from some DB or other persisted storage (i.e. not some in-memory storage), then you should definitely review your code!

You should not pull the whole collection into an array (potentially wasting tons of memory), when you can pull just a single page of it by using the standard `@page, @records = pagy(your_scope)`.

And if you think that it's the only way to do what you need, then... think again. ;)

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/array'
```

In a controller:

```ruby
@pagy_a, @items   = pagy_array(an_array, ...)

# independently paginate some other collections as usual
@pagy_b, @records = pagy(some_scope, ...)
```

## Files

- [array.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/array.rb)

## Methods

This extra adds the `pagy_array` method to the `Pagy::Backend` to be used in place (or in parallel) of the `pagy` method when you have to paginate an array. It also adds a `pagy_array_get_variables` sub-method, used for easy customization of variables by overriding.

**Notice**: there is no `pagy_array_get_items` method to override, since the items are fetched directly by the specialized `pagy_array` method.

### pagy_array(array, vars=nil)

This method is the same as the generic `pagy` method, but specialized for an Array. (see the [pagy doc](../api/backend.md#pagycollection-varsnil))

### pagy_array_get_vars(array)

This sub-method is the same as the `pagy_get_vars` sub-method, but it is called only by the `pagy_array` method. (see the [pagy_get_vars doc](../api/backend.md#pagy_get_varscollection-vars)).
