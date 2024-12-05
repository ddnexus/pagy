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

This subclass provides an interface layer for the UI. It maps `cursors` to page `numbers`, allowing the backend to work with the
faster keyset technique and the frontend with the usual numeric based UI helpers, such as the `pagy_*navs`, `prev` and `next`
buttons, etc.

It may require a slightly more involved setup, but it offers the best performance AND functionality together.

Its UI capabilities are similar to the [Pagy::Countless](countless.md)/[countless extra](/docs/extras/countless.md) but the
pagination is faster because of the keyset technique.

!!!
The API is documented here, however you may prefer to use the [keyset_cached extra](/docs/extras/keyset_cached.md)
wrapper to easily integrate it with your app.

You should also familiarize with the  [Pagy::Keyset](keyset.md) class.
!!!

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#5-keyset-apps)

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

With the default cookie-based `session`, depending on the size of your cursors, your session cookie might overflow the 4k max
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

Pagy uses the `cache_key` to store an array of `cursors` pointing to the already visited pages. If any of the pagination
parameters changes, the `:cache_key` must change, so the `cursors` will be consistent with the displayed page of records.

## Methods

==- `Pagy::Keyset::Cached.new(set, **vars)`

The constructor takes the `set`, and an optional hash of [variables](#variables). It returns a `Pagy::Keyset::Cached` object.

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
result. It is used as cache key to store the array of `cursors` pointing to the already visited pages.

==- `:max_pages`

Paginate only `:max_pages` ignoring the rest.

===

## Attribute Readers

`limit`, `page`, `vars`, `next`, `prev`, `last`, `in`

## Troubleshooting

See the [Pagy::Keyset Troubleshooting](keyset.md#variables)
