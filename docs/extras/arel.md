---
title: Arel
category: Backend Extras
---
# Arel Extra

This extra adds a specialized pagination for collections from sql databases with `GROUP BY` clauses, by computing the total number of results with `COUNT(*) OVER ()`. It was tested against MySQL (8.0.17) and Postgres (11.5). Before using in a different database, make sure the sql `COUNT(*) OVER ()` performs a count of all the lines after the `GROUP BY` clause is applied.

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/arel'
```

In a controller:

```ruby
@pagy_a, @items   = pagy_arel(a_collection, ...)

# independently paginate some other collections as usual
@pagy_b, @records = pagy(some_scope, ...)
```

## Files

- [arel.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/arel.rb)

## Methods

This extra adds the `pagy_arel` method to the `Pagy::Backend` to be used in place (or in parallel) of the `pagy` method when you want to paginate a collection with sql `GROUP BY` clause, where the number of groups/rows is big (for instance when group by day of the last 3 years). It also adds a `pagy_arel_get_variables` sub-method, used for easy customization of variables by overriding.

**Notice**: there is no `pagy_arel_get_items` method to override, since the items are fetched directly by the specialized `pagy_arel` method.

### pagy_arel(collection, vars=nil)

This method is the same as the generic `pagy` method, but with improved speed for SQL `GROUP BY` collections. (see the [pagy doc](../api/backend.md#pagycollection-varsnil))

### pagy_arel_get_vars(collection)

This sub-method is the same as the `pagy_get_vars` sub-method, but it is called only by the `pagy_arel` method. (see the [pagy_get_vars doc](../api/backend.md#pagy_get_varscollection-vars)).

### pagy_arel_count(collection)

This sub-method it is called only by the `pagy_get_vars` method. It will detect which query to perform based on the active record groups (sql `GROUP BY`s). In case there aren't group values performs a normal `.count(:all)`, otherwise it will perform a `COUNT(*) OVER ()`. The last tells database to perform a count of all the lines after the `GROUP BY` clause is applied.
