---
title: Arel
categories:
  - Backend
  - Extra
---

# Arel Extra

Provides better performance of grouped ActiveRecord collections.

Add a specialized pagination for collections from sql databases with `GROUP BY` clauses by computing the total number of results
with `COUNT(*) OVER ()`.

!!! warning
Tested against MySQL (8.0.17) and Postgres (11.5).
Before using in a different database, make sure the sql `COUNT(*) OVER ()` performs a count of all the lines after the `GROUP BY`
clause is applied.
!!!

## Synopsis

```ruby pagy.rb (initializer)
require 'pagy/extras/arel'
```

```ruby Controller
@pagy, @records = pagy_arel(collection, **vars)
```

## Methods

==- `pagy_arel(collection, **vars)`

This method is the same as the generic `pagy` method, but with improved speed for SQL `GROUP BY` collections. (see
the [pagy doc](/docs/api/backend.md#pagy-collection-vars-nil))

==- `pagy_arel_count(collection)`

This sub-method detects which query to perform based on the active record groups (sql `GROUP BY`s). In case there aren't 
group values performs a normal `.count(:all)`, otherwise it will perform a `COUNT(*) OVER ()`. The last tells database to 
perform a count of all the lines after the `GROUP BY` clause is applied.

===
