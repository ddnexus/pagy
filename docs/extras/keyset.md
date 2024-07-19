---
title: Keyset
categories:
- Backend
- Extra
---

# Keyset Extra

Paginate with the Pagy keyset pagination technique. 

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#3-demo-app)

## Overview

This is a tiny wrapper around the [Pagy::Keyset API](/docs/api/keyset.md) that implements and documents the actual pagination 
for `ActiveRecord::Relation` or `Sequel::Dataset` sets.  Please refer to the class documentation for a fuller undersanding of 
keyset pagination:

[!ref Keyset Pagination: Concepts and Overview](/docs/api/keyset.md)

This extra adds a `pagy_keyset` constructor method that can be used in your controllers and provides the automatic setting of the 
variables from the request `params`.

## Synopsis

```ruby pagy.rb (initializer)
require 'pagy/extras/keyset'

# useful optional extras for APIs
# require 'pagy/extras/limit'
# require 'pagy/extras/jsonapi'
# require 'pagy/extras/headers'
```

```ruby Controller (action)
# The set argument must be an uniquely ORDERED Activerecord Scope or Sequel Dataset 

# Minimal unique ordering with the primary key
set = Product.order(:id)
@pagy, @records = pagy_keyset(set, **vars)

# Using same-direction order keyset (all :asc, or all :desc) 
# Notice the primary key added as the last column as a tie-breaker for uniqueness
set = Product.order(:brand, :model, :id)
# Allow using the tuple_comparison e.g. (brand, model, id) > (:brand, :model, :id)
@pagy, @records = pagy_keyset(set, tuple_comparison: true)

# Ordering with mixed-direction order keyset
set = Product.order(brand: :asc, model: :desc, id: :asc) 
@pagy, @records = pagy_keyset(set, **vars)
```

## Variables

See the [Pagy::Keyset variables](/docs/api/keyset.md#variables)

## Methods

==- `pagy_keyset(set, **vars)`

This method is similar to the offset `pagy` method. It returns the `pagy` object (instance of `Pagy::Keyset`), and the array 
of `records` pulled from the DB.

==- `pagy_keyset_get_vars(vars)`

This sub-method is internally called only by the `pagy_keyset` method. It automatically sets the `:page` variable and - if you 
use the [limit extra](limit.md) also the `:limit` variables from the request `params`. Documented only for 
overriding.

==- `pagy_keyset_first_url(pagy, absolute: false)`

Return the first page URL string. (See also the [headers](headers.md) and [jsonapi](jsonapi.md) extras for more complete solutions)

==- `pagy_keyset_next_url(pagy, absolute: false)`

Return the next page URL string or nil. (See also the [headers](headers.md) and [jsonapi](jsonapi.md) extras for more complete solutions)

===
