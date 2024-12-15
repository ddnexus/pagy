---
title: Pagy::KeysetForUI
category:
  - Feature
  - Class
---

# Pagy::KeysetForUI

A [Pagy::Keyset](keyset.md) subclass with numeric pages supporting `pagy_*nav` and the other Frontend helpers.

!!!warning Experimental: the API might change in minor versions
!!!

## Overview

The regular `Pagy::Keyset` uses the fastest technique for pagination, but it cannot work with any Frontend helper because they require numeric
pages. 

That's why we created `Pagy::KeysetForUI`: it uses keyset pagination AND supports `pagy_*navs` and the other Frontend
helpers.

!!!
The API is documented here, however you should use the [keyset_for_ui extra](/docs/extras/keyset_for_ui.md)
wrapper to handle the cache and easily integrate it with your app.

You should also familiarize with the [Pagy::Keyset](keyset.md) class.
!!!

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#5-keyset-apps)

## Glossary

This section integrates the [Keyset Glossary](keyset_for_ui.md#glossary)

| Term                       | Description                                                                                                                                                                                   |
|----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `keyset pagination for UI` | The pagy exclusive technique to use `keyset pagination` with numeric pages, supporting `pagy_*navs` and the other Frontend helpers.<br/>The best technique for performance AND functionality! |
| `page`                     | The current page **number**                                                                                                                                                                   |
| `cutoffs`                  | The `cutoff`s of the known pagination state, used to keep track of the visited pages during the navigation.                                                                                   |

## How Pagy Keyset For UI works

### Caching the known cutoffs

See also [Understanding the Cutoffs](/docs/api/keyset.md#understanding-the-cutoffs) for a complete understanding...

`Pagy::KeysetForUI` keeps track of the state of the pagination using the `cutoffs` array. As soon as a page is visited, its `cutoff` gets pushed to the `cutoffs` array (which is cached) hence it can be retrieved by numeric index (i.e. by `:page`) in future requests.

While the `cutoffs` data must persist between requests, this class does not handle the persistency at all: that is a concern of the [keyset_for_ui extra](/docs/extras/keyset_for_ui). Here is a simplified example of what must happen with the `cutoffs` at each request:

```ruby
cutoffs = read_from_cache(cache_key)
pagy = KeysetForUI.new(set, cutoffs:, **vars)
write_to_cache(cache_key, pagy.cutoffs)
```

!!! Notice

The cache handling is external to the `Pagy::KeysetForUI` class for easy overriding. See [Understanding the cache](/docs/extras/keyset_for_ui#understanding-the-cache) for more details.
!!!

### Numeric variables for the Frontend Helpers

Keeping track of the state through the `cutoffs` allows to set the numeric variables that the Frontend helpers require (see [Attribute Readers](#attribute-readers)).

However, it's still keyset pagination, which doesn't know any future page after the `next` page, so we add more pages on the go like we do with `Pagy::Countless`... just better for two reasons:

1. We don't lose the future pages when we jump back because we can count on the cache.
2. Keyset pagination is A LOT faster than offset pagination.

### Accurate queries

`Pagy::KeysetForUI` knows all the `cutoffs` of the current pagination. If the `cutoffs` don't contain the current page's `cutoff`, then it's a new requested page, and it proceeds exactly like the standard `Pagy::Keyset` class.

However, if the `cutoffs` contains the current page's `cutoff` then it's an already requested page, and  the number of records pulled with LIMIT may have changed since the time of the first request.

Querying with the LIMIT again, might cause records to get skipped or to appear twice! So, to get it right, it pulls the records AFTER the `cutoff` of the previous page (`@prev_cutoff`) AND NOT AFTER the `cutoff` of the current page, so avoiding the LIMIT and inluding the right records regardless.

!!! Notice

While te accuracy is guaranteed, in case of insertions or deletions of records falling in the range of the visited page, the page will obviously have a number of records different from expected.

That is not a logical nor common problem, however in extreme cases, a page of records might change its size so noticeably and unexpectedly that it may look somehow "broken" to the users.

!!!success We plan to implement page-rebalancing:

- Automatic compacting of empty (or almost empty) visited pages.
- Automatic splitting of eccesively grown visited pages.
!!!

## Setup

See the [Keyset Setup](keyset.md#setup) and the [keyset_for_ui extra](/docs/extras/keyset_for_ui).

## ORMs

`Pagy::KeysetForUI` implements the subclasses for `ActiveRecord::Relation` and `Sequel::Dataset` sets and instantiate them
internally:

```ruby
Pagy::KeysetForUI.new(active_record_set)
#=> #<Pagy::KeysetForUI::ActiveRecord:0x00000001066215e0>

Pagy::KeysetForUI.new(sequel_set)
#=> #<Pagy::KeysetForUI::Sequel:0x00000001066545e0>
```

## Methods

==- `Pagy::KeysetForUI.new(set, **vars)`

The constructor takes the `set`, and an optional hash of [variables](#variables). It returns a
`Pagy::KeysetForUI::ActiveRecord` or
`Pagy::KeysetForUI::Sequel` object (depending on the `set` class).

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

Resets the pagination in case of overflow, instead of raising a `Pagy::OverflowError`. Use it when you don't need to `rescue` and handle the event in any particular way. Notice: it reuses the current `cache_key`

===

## Attribute Readers

`cutoffs`, `in`, `last`, `limit`, `next`, `page`, `prev`, `vars`

## Troubleshooting

See the [Pagy::Keyset Troubleshooting](keyset.md#troubleshooting)
