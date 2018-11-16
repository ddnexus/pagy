---
title: infinite
---
# Infinite Extra

This extra intend to resolve problem with slow `COUNT(*)` SQL query for large tables.
Infinite-extra changes pagination in a way that, a user can navigate only to "Next" page. And does not know what actual "Total count" is.
It worls with all `Pagy::Frontend` extras.

It is compatible with ActiveRecord ORM.

## Synopsys

See [extras](../extras.md) for general usage info.

In a controller:

```ruby
@pagy_a, @items   = pagy_infinite(some_scope, ...)

# independently paginate some other collections as usual
@pagy_b, @records = pagy(some_scope, ...)
```

**Notice**: Frontend will render only "Prev" and "Next" buttons. And `Frontend#pagy_info` method is not recommended to use. Because it will show wrong "Total number".

## Files

This extra is composed of 1 file:

- [infinite.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/infinite.rb)

## Methods

This extra adds the `pagy_infinite` method to the `Pagy::Backend` to be used in place (or in parallel) of the `pagy` method when you have to paginate large table without need of showing "Total count". It also adds a `pagy_infinite_get_variables` sub-method, used for easy customization of variables by overriding.

**Notice**: The `pagy_infinite_get_varuables` returns "count", but it does not show real COUNT and mustn't be used for showing "Total count: N"

### pagy_infinite(some_scope, vars={})

This method is the same as the generic `pagy` method, but instead of execution COUNT-query, it checks if "Next page" exists
(for example: `Post.all.limit(...).offset(...next-offset...).exist?` [API Doc](https://apidock.com/rails/ActiveRecord/FinderMethods/exists%3F) )

### pagy_infinite_get_vars(some_scope)

This sub-method is the same as the `pagy_get_vars` sub-method, but it is called only by the `pagy_infinite` method. (see the [pagy_get_vars doc](../api/backend.md#pagy_get_varscollection-vars)).
