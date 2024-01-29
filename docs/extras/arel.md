---
title: Arel
categories:
- Backend
- Extra
---

# Arel Extra

Provides better performance of grouped ActiveRecord collections.

Add a specialized pagination for collections from sql databases with `GROUP BY` clauses by computing the total number of results with `COUNT(*) OVER ()`.

!!! warning
Tested against MySQL (8.0.17) and Postgres (11.5).
Before using in a different database, make sure the sql `COUNT(*) OVER ()` performs a count of all the lines after the `GROUP BY` clause is applied.
!!!

## Synopsis

||| pagy.rb (initializer)
```ruby
require 'pagy/extras/arel'
```
|||

||| Controller
```ruby
@pagy, @items = pagy_arel(a_collection, **vars)
```
|||

## Files

- [arel.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/arel.rb)

## Methods


==- `pagy_arel(collection, vars=nil)`

This method is the same as the generic `pagy` method, but with improved speed for SQL `GROUP BY` collections. (see the [pagy doc](/docs/api/backend.md#pagy-collection-vars-nil))

==- `pagy_arel_get_vars(collection)`

This sub-method is the same as the `pagy_get_vars` sub-method, but it is called only by the `pagy_arel` method. (see the [pagy_get_vars doc](/docs/api/backend.md#pagy-get-vars-collection-vars)).

==- `pagy_arel_count(collection)`

This sub-method it is called only by the `pagy_get_vars` method. It will detect which query to perform based on the active record groups (sql `GROUP BY`s). In case there aren't group values performs a normal `.count(:all)`, otherwise it will perform a `COUNT(*) OVER ()`. The last tells database to perform a count of all the lines after the `GROUP BY` clause is applied.

===
