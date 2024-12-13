---
title: Keyset Numeric
categories:
  - Backend
  - Extra
---

# Keyset Numeric Extra

Paginate with the [Pagy Keyset Numeric](/docs/api/keyset_numeric) pagination technique, using numeric pages to support `pagy_*nav`
and the other Frontend helpers.

!!!warning Experimental: the API might change in minor versions
!!!

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#5-keyset-apps)

## Overview

This extra manages the cache used by the `Pagy::Keyset::Numeric` instance, allowing easy customization and integration with your
app.

It also adds a `pagy_keyset_numeric` constructor method that can be used in your controllers, and provides the automatic setting
of the variables from the request `params`.

Please refer to the following resource:

[!ref Keyset Numeric: Documentation](/docs/api/keyset_numeric.md)

[!ref Keyset Pagination: Concepts and Overview](/docs/api/keyset.md)

## Synopsis

This section integrates the [Keyset Extra Synopsis](/docs/extras/keyset.md)

```ruby Controller (action)
# Basic defaults (uses the session object as the cache)
@pagy, @records = pagy_keyset_numeric(set)

# Other variables
@pagy, @records = pagy_keyset_numeric(set, reset_overflow: true, max_pages: 100, **vars)
```

```ruby ApplicationController
# Overriding custom cache read/write
def pagy_cache_read(key) = my_custom_cache(key)

def pagy_cache_write(key, value) = my_custom_cache(key, value)

# Overriding custom cache_key
def pagy_cache_new_key = my_custom_cache.generate_key
```

## Understanding the cache

This extra uses the `session` object as the cache for the `cuts` by default, because it's simple and works in any app, at least for
prototyping.

Notice that the `cuts` array can potentially grow big if you don't use `:max_pages`, especially if your `keyset` contains
multiple ordered columns and more if their size is big. You must be aware of it.

!!!danger Do not use the cookie-based session as the cache

Your session cookie will likely overflow the 4k max size. You should probably use some other storage if you are fine using the
session as the cache (e.g. `ActiveRecord::SessionStore`).
!!!

### Overriding

!!!warning

Besides writing and reading from it, Pagy does not expire nor handle the cache in any way. Your app should manage it like it does
with the `session` object.
!!!

This extra uses only 3 simple methods to handle the cache:

- `pagy_cache_new_key`
- `pagy_cache_read(key)`
- `pagy_cache_write(key, value)`

You can override them in your own `ApplicationController` (as shown in the synopsys), not only changing the cache, but also
handling other aspects of it (e.g. expiration, etc.)

!!!primary Notice

We are considering the implementation of a client-side cache using the Browser's `sessionStorage`.

It might simplify the handling of the cache considerably, but it will require some time to design it properly, so please, hang tight and cheer for us!
!!!

## Variables

This section integrates the [Pagy::Keyset::Numeric variables](/docs/api/keyset_numeric#variables).

==- `:cache_key`

The key used to locate the `cuts` in the cache storage.

==- `:cache_key_param`

The name of the cache key param. It is `:cache_key` by default. Pass a different symbol to change it.

===

## Methods

==- `pagy_keyset_numeric(set, **vars)`

This method is similar to the `pagy` (for offset pagination) method. It returns the `pagy` object and the array of `records`
pulled from the DB.

==- `pagy_cache_read(key)`

This method handles cache reading. It uses the `session` cache by default. Customize your cache by overridig it in yor app.

==- `pagy_cache_write(key, value)`

This method handles cache writing. It uses the `session` cache by default. Customize your cache by overridig it in yor app.

==- `pagy_cache_new_key`

This method must generate and return a new cache key. It is called when a new cache entry is needed. It uses a simple algorithm
that allows 1B number shortened to max 5 letters. Customize it by adding expiration or other property to the new entry, before
returning the key.

===
