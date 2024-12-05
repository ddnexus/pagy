---
title: Keyset Cached
categories:
  - Backend
  - Extra
---

# Keyset Cached Extra

Paginate with the Pagy Keyset Cached pagination technique.

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#5-keyset-apps)

## Overview

This is a tiny wrapper around the [Pagy::Keyset::Cached API](/docs/api/keyset_cached.md). Please refer to the class documentation
for a fuller understanding of keyset pagination:

[!ref Keyset Cached Pagination: Overview](/docs/api/keyset_cached.md)

This extra adds a `pagy_keyset_cached` constructor method that can be used in your controllers and provides the automatic setting of the
variables from the request `params`.

## Synopsis

See first the [Keyset Extra Synopsis](/docs/extras/keyset.md)

```ruby Controller (action)
# Basic defaults
@pagy, @records = pagy_keyset_cached(set)

# Optional custom session :cache hash
@pagy, @records = pagy_keyset_cached(set, cache: my_persistent_hash)

# Deterministic :cache_key variable
# Example of a complete :cache_key variables:
# INCLUDE all the items that might change the records, order or pagination 
# DO NOT INCLUDE params that change between pages, without actually 
# changing the composition of the results (e.g. the page param)
cache_key = lambda do |vars|
  [ request.path, 
    params.slice(:search, :category, :year, ...),
    vars[:limit]  # not in the params on page 1, so taken from vars
  ].to_json
end
# use Digest::SHA2.hexdigest to compress it a bit
@pagy, @records = pagy_keyset_cached(set, "pagy-#{Digest::SHA2.hexdigest(cache_key:)}")
```

## Variables

See the [Pagy::Keyset::Cached variables](/docs/api/keyset_cached.md#variables)

## Methods

==- `pagy_keyset_cached(set, **vars)`

This method is similar to the offset `pagy` method. It returns the `pagy` object and the array of `records` pulled from the DB.

===
