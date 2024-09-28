---
title: Keyset
categories:
- Backend
- Extra
---

# Keyset Extra

Paginate with the Pagy keyset pagination technique.

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#5-keyset-apps)

## Overview

This is a tiny wrapper around the [Pagy::Keyset API](/docs/api/keyset.md). Please refer to the class documentation for a 
fuller understanding of keyset pagination:

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

# Minimal unique ordering with the primary key: it works fast out of the box 
set = Product.order(:id)
# See the Pagy::Keyset docs for other variables
@pagy, @records = pagy_keyset(set, **vars)

# Using same-direction order keyset (all :asc, or all :desc) 
# Notice the primary key added as the last column as a tie-breaker for uniqueness
set = Product.order(:brand, :model, :id)
# Allow using the tuple_comparison e.g. (brand, model, id) > (:brand, :model, :id)
@pagy, @records = pagy_keyset(set, tuple_comparison: true)

# Ordering with mixed-direction order keyset
set = Product.order(brand: :asc, model: :desc, id: :asc) 
@pagy, @records = pagy_keyset(set, **vars)

# URL Helpers
pagy_keyset_first_url(@pagy, absolute: true)
#=> "http://example.com/foo?page" 

pagy_keyset_next_url(@pagy)
#=> "/foo?page=eyJpZCI6MzB9"
```

## Variables

See the [Pagy::Keyset variables](/docs/api/keyset.md#variables)

## Methods

==- `pagy_keyset(set, **vars)`

This method is similar to the offset `pagy` method. It returns the `pagy` object (instance of `Pagy::Keyset::ActiveRecord` or 
`Pagy::Keyset::Sequel`, depending on the set class) and the array of `records` pulled from the DB.

==- `pagy_keyset_first_url(pagy, absolute: false)`

Return the first page URL string. (See also the [headers](headers.md) and [jsonapi](jsonapi.md) extras for more complete solutions)

==- `pagy_keyset_next_url(pagy, absolute: false)`

Return the next page URL string or nil. (See also the [headers](headers.md) and [jsonapi](jsonapi.md) extras for more complete solutions)

===
