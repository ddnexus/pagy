---
title: Pagy::Keyset::Cached
category:
  - Feature
  - Class
---

# Pagy::Keyset::Cached

!!!warning Experimental: the API might change in minor versions
!!!

Add UI support to the [Pagy::Keyset](keyset.md) like `pagy_*nav` helpers and numeric pages.

## Overview

This subclass provides an interface layer for the UI. It caches the `cutoffs` and maps them to page `numbers`, allowing the backend to work with the
faster keyset technique and the frontend with the usual numeric based UI helpers, such as the `pagy_*navs`, `prev` and `next`
buttons, etc.

It may require a slightly more involved setup, but it offers the best performance AND functionality together.

Its UI capabilities are similar to the [Pagy::Countless](countless.md)/[countless extra](/docs/extras/countless.md) but the
pagination is faster because of the keyset technique.

!!!
The API is documented here, however you may prefer to use the [keyset_cached extra](/docs/extras/keyset_cached.md)
wrapper to easily integrate it with your app.

You should also familiarize with the [Pagy::Keyset](keyset.md) class.
!!!

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#5-keyset-apps)

## Concept

The biggest limitation of the standard "keyset" pagination technique, is that basically you can only go to the next page,

pk only know how to fetch a fixed number of record starting from a very 
has only one very local parameter: the cutoff, i.e. the pointer to a very specific record in the collection. It finds it very efficiently

The basic cycle of KP is pulling a fixed number of records and memorizing the identifier of the last reteived record

KP is efficient because it is very local to a specific part of the collection: the :cutoff. 

## Setup

First follow the same basic [Keyset Setup](keyset.md#setup).

### Set up the `:cache` variable

This class requires a `:cache` variable set to a hash-like object (responding to `:[]=` and `[]`) that should persist between
requests. If you use the [keyset_cached extra](/docs/extras/keyset_cached.md) wrapper, it will set it to the `session` object by
default, however you can pass any persisted hash-like object of your preference.

Notice that besides writing and reading from it, Pagy does not expire nor handle the cache in any way: you or your app should manage it
like it does with the `session`.

!!! success

If you would like Pagy to support an object that write/read from the cache in ny way other than `:[]=` and `[]`, please open
a [feature request](https://github.com/ddnexus/pagy/discussions/categories/feature-requests).
!!!

!!!warning Warning!

With the default cookie-based `session`, depending on the size of your cutoffs, your session cookie might overflow the 4k max
size. In that case you should use some other storage for the session.
!!!

### Set up the `:cache_key` variable

The `:cache_key` must be a string **deterministically generated** from all the params/variables that may determine any variation
in the paginated result. For example:

```ruby
# If you have just a "search" field, the :cache_key may be assigned like:
cache_key = params(:search)

# If you have also a possibly changing :limit variable:
cache_key = ->(vars) { [params(:search), vars[:limit]].to_json }

# If your key could potentially grow too big:
key       = Digest::SHA2.hexdigest([huge, list, of, variables].to_json)
cache_key = ->(_) { key }
```

Pagy uses the `cache_key` to store an array of `cutoffs` of the already visited pages. If any of the pagination
parameters changes, the `:cache_key` must change, so the `cutoffs` will be consistent with the displayed page of records.

## ORMs

`Pagy::Keyset::Cached` implements the subclasses for `ActiveRecord::Relation` and `Sequel::Dataset` sets and instantiate them internally:

```ruby
Pagy::Keyset::Cached.new(active_record_set)
#=> #<Pagy::Keyset::Cached::ActiveRecord:0x00000001066215e0>
 
Pagy::Keyset.new(sequel_set) 
#=> #<Pagy::Keyset::Cached::Sequel:0x00000001066545e0>
```

## Methods

==- `Pagy::Keyset::Cached.new(set, **vars)`

The constructor takes the `set`, and an optional hash of [variables](#variables). It returns a `Pagy::Keyset::Cached::ActiveRecord` or
`Pagy::Keyset::Cached::Sequel` object (depending by the `set` class).

==- `records`

The `Array` of fetched records for the current page.

===

## Variables

See the [Pagy::Keyset variables](keyset.md#variables), plus the following:

==- `:cache`

Mandtory hash-like object (responding to `:[]=` and `[]`) that should persist between requests.
The [keyset_cached extra](/docs/extras/keyset_cached.md) sets it to the `session` object by defult.

==- `:cache_key`

Mandatory string **deterministically generated** from all the params/variables that may determine any variation in the paginated
result. It is used as cache key to store the array of `cutoffs` of the already visited pages.

==- `:max_pages`

Paginate only `:max_pages` ignoring the rest.

===

## Attribute Readers

`limit`, `page`, `vars`, `next`, `prev`, `last`, `in`

## Troubleshooting

See the [Pagy::Keyset Troubleshooting](keyset.md#variables)
