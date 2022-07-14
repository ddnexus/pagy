---
title: Array
category: Backend Extras
---
# Array Extra

Paginate arrays.

!!! warning WARNING
This warning may sound obvious, but I keep finding people improperly using this extra, so let me write it explicitly.

The `array` extra is efficient if you really need to paginate an array, but if the data in the array comes from some DB or other persisted storage (i.e. not some in-memory storage), then you should definitely review your code!

You should not pull the whole collection into an array (potentially wasting tons of memory), when you can pull just a single page of it by using the standard `@page, @records = pagy(your_scope)`.

And if you think that it's the only way to do what you need, then... think again. 🧐
!!!

## Synopsis

See [extras](/docs/extras.md) for general usage info.

||| pagy.rb (initializer)
```ruby
require 'pagy/extras/array'
```
|||

||| Controller
```ruby
@pagy, @items = pagy_array(an_array, ...)
```
|||

## Files

- [array.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/array.rb)

## Methods

==- pagy_array(array, vars=nil)

This method is the same as the generic `pagy` method, but specialized for an Array. (see the [pagy doc](/docs/api/backend.md#pagycollection-varsnil))

==- pagy_array_get_vars(array)

This sub-method is the same as the `pagy_get_vars` sub-method, but it is called only by the `pagy_array` method. (see the [pagy_get_vars doc](/docs/api/backend.md#pagy_get_varscollection-vars)).

===
