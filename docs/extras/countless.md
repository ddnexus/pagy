---
title: Countless
---
# Countless Extra

This extra uses the `Pagy::Countless` subclass in order to save one count query per request. It is especially useful when used with large DB tables, where [Caching the count](../how-to.md#cache-the-count) may not be an option, or when there is no need to have a classic UI. Please read also the [Pagy::Countless doc](../api/countless.md) for a fuller understanding of its features and limitations.

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/countless'
# optionally enable the minimal mode by default
# Pagy::DEFAULT[:countless_minimal] = true
```

In a controller:

```ruby
# default mode (eager loading)
@pagy, @records = pagy_countless(some_scope, ...)

# OR
# enable minimal mode for this instance (lazy loading)
@pagy, @records = pagy_countless(some_scope, countless_minimal: true, ...)
```

## Modes

This extra can be used in two different modes by enabling or not the `:countless_minimal` variable.

### Default mode

This is the preferred automatic way to save one query per request, while keep using the classic pagination UI helpers.

By default this extra will try to finalize the `pagy` object with all the available variables in a countless pagination. It will do so by retrieving `items + 1`, and using the resulting number to calculate the variables, while eventually removing the extra item from the result.

That means:

- The `pagy` object will know whether the current page is the last one or there will be a next page so you can use it right away with any supported helper
- The returned paginated collection (`@records`) will be an `Array` instead of a scope (so the records are already eager-loaded from the DB)

### Minimal mode

This is the preferred mode used to implement navless and automatic incremental/infinite-scroll pagination, where there is no need to use any UI.

If you enable the `:countless_minimal` variable, then:

- The returned `pagy` object will contain just a handful of variables and will miss the finalization, so you cannot use it with any helpers
- The returned paginated collection (`@records`) will be a regular scope (i.e. no record has been load yet) so an eventual fragment caching can work as expected
- You will need to check the size of the paginated collection (`@records`) in order to know if it is the last page or not. You can tell it by checking `@records.size < @pagy.vars[:items]`. Notice that IF the last page has exactly the `@pagy.vars[:items]` in it you will not be able to know it. In infinite scroll that would just try to load the next page returning 0 items, so it will be perfectly acceptable anyway.

## Variables

| Variable             | Description                       | Default |
|:---------------------|:----------------------------------|:--------|
| `:countless_minimal` | enable the countless minimal mode | `false` |

## Files

- [countless.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/countless.rb)

## Methods

All the methods in this module are prefixed with the `"pagy_countless"` string, to avoid any possible conflict with your own methods when you include the module in your controller. They are also all private, so they will not be available as actions. The methods prefixed with the `"pagy_countless_get_"` string are sub-methods/getter methods that are intended to be overridden, not used directly.

### pagy_countless(collection, vars=nil)

This method is the same as the generic `pagy` method (see the [pagy doc](../api/backend.md#pagycollection-varsnil)), however its returned objects will depend on the value of the `:countless_minimal` variable (see [Modes](#modes))

### pagy_countless_get_vars(_collection, vars)

This sub-method is similar to the `pagy_get_vars` sub-method, but it is called only by the `pagy_countless` method. (see the [pagy_get_vars doc](../api/backend.md#pagy_get_varscollection-vars)).

### pagy_countless_get_items(collection, pagy)

This sub-method is similar to the `pagy_get_items` sub-method, but it is called only by the `pagy_countless` method. (see the [pagy_get_items doc](../api/backend.md#pagy_get_itemscollection-pagy)).
