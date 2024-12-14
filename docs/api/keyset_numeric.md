---
title: Pagy::Keyset::Numeric
category:
  - Feature
  - Class
---

# Pagy::Keyset::Numeric

A [Pagy::Keyset](keyset.md) subclass with numeric pages supporting `pagy_*nav` and the other Frontend helpers.

!!!warning Experimental: the API might change in minor versions
!!!

## Overview

The regular `Pagy::Keyset` uses the fastest technique for pagination, but it cannot work with any Frontend helper because they require numeric
pages. 

That's why we created `Pagy::Keyset::Numeric`: it uses keyset pagination AND supports `pagy_*navs` and the other Frontend
helpers.

!!!
The API is documented here, however you should use the [keyset_numeric extra](/docs/extras/keyset_numeric)
wrapper to handle the cache and easily integrate it with your app.

You should also familiarize with the [Pagy::Keyset](keyset.md) class.
!!!

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#5-keyset-apps)

## Glossary

Integrates the [Keyset Glossary](keyset_numeric.md#glossary)

| Term                        | Description                                                                                                                                                                                   |
|-----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `keyset numeric pagination` | The pagy exclusive technique to use `keyset pagination` with numeric pages, supporting `pagy_*navs` and the other Frontend helpers.<br/>The best technique for performance AND functionality! |
| `page`                      | The current page **number**                                                                                                                                                                   |
| `cutoffs`                      | The `cutoff`s of the pagination known so far, used to keep track of the visited pages.                                                                                                           |

## How Pagy::Keyset::Numeric works

### Caching the known cutoffs

`Pagy::Keyset::Numeric` keeps track of the state of the pagination using the `cutoffs`Array. As soon as a page is visited, its `cutoff` gets added to the `cutoffs` array (which is cached) hence it can be retrieved by numeric index in future requests.

While the `cutoffs` data must persist between requests for this class to work, this class does not handle the persistency at all: that is a concern of the [keyset_numeric extra](/docs/extras/keyset_numeric). Here is a simplified example of what must happen with the `cutoffs` at each request:

```ruby
cutoffs = read_from_cache(cache_key)
pagy = Keyset::Numeric.new(set, cutoffs:, **vars)
write_to_cache(cache_key, pagy.cutoffs)
```

!!! Notice

The cache handling is external to the `Pagy::Keyset::Numeric` class for easy overriding. See [Understanding the cache](/docs/extras/keyset_numeric#understanding-the-cache) for more details.
!!!

### Numeric variables for the Frontend Helpers

Keeping track of the state through the `cutoffs` allows to set the numeric variables that the Frontend helpers require (see [Attribute Readers](#attribute-readers)).

However, it's still keyset pagination, which doesn't know any future page after the `next` page, so we add more pages on the go like we do with `Pagy::Countless`... just better for two reasons:

1. We don't lose the future pages when we jump back because we can count on the cache.
2. Keyset pagination is A LOT faster than offset pagination.

### Accurate queries

`Pagy::Keyset::Numeric` knows all the `cutoffs` of the current pagination. If the `cutoffs` don't contain the current page's `cutoff`, then it's a new requested page, and it proceeds exactly like the standard `Pagy::Keyset` class.

However, if the `cutoffs` contain the current page's `cutoff` then it's an already requested page, and  the number of records pulled with LIMIT may have changed since the time of the first request.

Querying with the LIMIT again, might cause records to get skipped or to appear twice! So, to get it right, it pulls the records BETWEEN the `prev_cutoff` and the `cutoff` avoiding the LIMIT and inluding the right records regardless.

## Setup

See the [Keyset Setup](keyset.md#setup).

## ORMs

`Pagy::Keyset::Numeric` implements the subclasses for `ActiveRecord::Relation` and `Sequel::Dataset` sets and instantiate them
internally:

```ruby
Pagy::Keyset::Numeric.new(active_record_set)
#=> #<Pagy::Keyset::Numeric::ActiveRecord:0x00000001066215e0>

Pagy::Keyset.new(sequel_set)
#=> #<Pagy::Keyset::Numeric::Sequel:0x00000001066545e0>
```

## Methods

==- `Pagy::Keyset::Numeric.new(set, **vars)`

The constructor takes the `set`, and an optional hash of [variables](#variables). It returns a
`Pagy::Keyset::Numeric::ActiveRecord` or
`Pagy::Keyset::Numeric::Sequel` object (depending on the `set` class).

==- `records`

The `Array` of fetched records for the current page.

===

## Variables

This section ontegrates the [Pagy::Keyset variables](keyset.md#variables):

==- `:cutoffs`

Mandatory array that must persist between requests.

==- `:max_pages`

Paginate only `:max_pages` ignoring the rest.

==- `:reset_overflow`

Resets the pagination in case of overflow, instead of raising a `Pagy::OverflowError`. Use it when you don't need to `rescue` and handle the event in any particular way. Notice: it keeps the current `cache_key`

===

## Attribute Readers

`cutoffs`, `in`, `last`, `limit`, `next`, `page`, `prev`, `vars`

## Troubleshooting

See the [Pagy::Keyset Troubleshooting](keyset.md#troubleshooting)

## TODO

- Add automatic compacting of empty (or almost empty) visited pages
- Add automatic splitting of eccesively grown visited pages
