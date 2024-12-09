---
title: Keyset Numeric
categories:
  - Backend
  - Extra
---

# Keyset Numeric Extra

Paginate with the Pagy Keyset Numeric pagination technique.

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#5-keyset-apps)

## Overview

This is a tiny wrapper around the [Pagy::Keyset::Numeric API](/docs/api/keyset_numeric). Please refer to the class documentation
for a fuller understanding of keyset pagination:

[!ref Keyset Numeric Pagination: Overview](/docs/api/keyset_numeric)

This extra adds a `pagy_keyset_numeric` constructor method that can be used in your controllers and provides the automatic setting of the
variables from the request `params`.

## Synopsis

This section integrates the [Keyset Extra Synopsis](/docs/extras/keyset.md)

```ruby Controller (action)
# Basic defaults (uses the session object as the cache)
@pagy, @records = pagy_keyset_numeric(set)

# Optional custom session :cache hash
@pagy, @records = pagy_keyset_numeric(set, cache: my_persistent_hash)

# CUstom cache_key
# If you have just a "search" field, the :cache_key may be assigned like:
cache_key = ->(_vars) { params(:search) }

# If you have also other fields 
# and a possibly changing :limit and order (:keyset) variables:
cache_key = lambda do |vars|
  [ params.slice(:search, :category, :year, ...), # search params
    vars.slice(:limit, :keyset),  # vars that change the page records
  ].to_json
end
@pagy, @records = pagy_keyset_numeric(set, cache_key:)
```

## Variables

See the [Pagy::Keyset::Numeric variables](/docs/api/keyset_numeric#variables)

## Methods

==- `pagy_keyset_numeric(set, **vars)`

This method is similar to the `pagy` (for offset pagination) method. It returns the `pagy` object and the array of `records` pulled from the DB.

===
