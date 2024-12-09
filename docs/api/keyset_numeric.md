---
title: Pagy::Keyset::Numeric
category:
  - Feature
  - Class
---

# Pagy::Keyset::Numeric

A [Pagy::Keyset](keyset.md) subclass with numeric `page`s supporting `pagy_*nav` and other Frontend helpers.

!!!warning Experimental: the API might change in minor versions
!!!

## Overview

The keyset/cursor pagination technique is the fastest technique able to pull a page of records from a relational DB, but it cannot
refer to pages as numbers.

All the Frontend helpers, like the `pagy_nav`, work only with page number, so... `Pagy::Keyset` cannot use them.

The `Pagy::Keyset::Numeric` subclass uses the fastest technique for the DB and works with the usual user-friendly helpers. It may
require a slightly more involved setup, but it offers the best performance AND functionality together.

!!!
The API is documented here, however you may prefer to use the [keyset_numeric extra](/docs/extras/keyset_numeric)
wrapper to easily integrate it with your app.

You should also familiarize with the [Pagy::Keyset](keyset.md) class.
!!!

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#5-keyset-apps)

### Glossary

Integrates the [Keyset Glossary](keyset_numeric.md#glossary)

| Term                        | Description                                                                                                                                                                                                                             |
|-----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `keyset numeric pagination` | The pagy exclusive technique to use `keyset pagination` with numeric pages, supporting `pagy_*navs` and other Frontend helpers. The best technique for performance AND functionality!                                                   |
| `page`                      | The current page **number**                                                                                                                                                                                                             |
| `cutoffs snapshot`          | The conceptual snapshot of all the `cutoff`s that split the `set` into pages. Each one identifies a point beyond a specific record in the `set`.                                                                                        |
| `cutoffs`                   | The cached known `cutoff` variables used for the visited (numeric) pages.                                                                                                                                                               |
| `cache`                     | Hash-like object (responding to `:[]=` and `[]`) that should persist between requests.The [keyset_numeric extra](/docs/extras/keyset_numeric) sets it to the `session` object by defult. Pagy uses it to map `cutoffs` to page numbers. |
| `cache_key`                 | The string (or `Proc` returning it), deterministically related with a `cutoff snapshot`.                                                                                                                                                |

### How Pagy::Keyset::Numeric works

This `Pagy::Keyset` subclass adds a cached layer of `cutoffs` that are mapped to page number as they get visited/discovered.

Here is how it works:

- You pass an `uniquely ordered` `set` and `Pagy::Keyset` pulls the `:limit` of records of the first page (exacly like its super
  class does), however it stores the `cutoff` of the current page in the cache.
- It requests the `next` URL by setting its `page` query string param to the current page + 1 (as it happens in offset pagination)
- At each request, the new `:page` number is used to pull its cached `cutoff` (i.e. the `cutoff` of the previous page) from the
  cache, and it's used exactly like its superclass does.
- As the visited page numers are adding up, and become available to the `series` method as in offset pagination, so the related
  `cutoffs` get stored in the cache, offering the user the possibility to jump to any of the visited page.
- When the user jump to a visited page, the query to pull the visited page is slightly different to ensure accuracy and
  consistency. See the `Pagy::Keyset::Numeric#filter_records_sql` code and comments for details.
- You know that you reached the end of the collection when `pagy.next.nil?`.

## Setup

This section integrates the [Keyset Setup](keyset.md#setup).

### Set up the `:cache` variable

This class requires a `:cache` variable set to a hash-like object (responding to `:[]=` and `[]`) that should persist between
requests. If you use the [keyset_numeric extra](/docs/extras/keyset_numeric) wrapper, it will set it to the `session` object by
default, however you can pass any persisted hash-like object of your preference.

Notice that besides writing and reading from it, Pagy does not expire nor handle the cache in any way. Your app should manage it
like it does with the `session` object.

!!!danger Do not use the cookie based session as cache

With the default cookie-based `session`, depending on the size of your cutoffs, your session cookie will likely overflow the 4k
max size. You should probably use some other storage for the session (e.g. `ActiveRecord::SessionStore`).

!!!primary Notice

We plan to implement a client-side cache support using the `sessionStorage`.

Its implementation will require some time, so please, hang tight and cheer for us!
!!!

!!! success

If you would like Pagy to support an object that write/read from the cache in any way other than `:[]=` and `[]`, please open
a [feature request](https://github.com/ddnexus/pagy/discussions/categories/feature-requests).
!!!

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
`Pagy::Keyset::Numeric::Sequel` object (depending by the `set` class).

==- `records`

The `Array` of fetched records for the current page.

===

## Variables

See the [Pagy::Keyset variables](keyset.md#variables), plus the following:

==- `:cache`

Mandatory hash-like object (responding to `:[]=` and `[]`) that should persist between requests.
The [keyset_numeric extra](/docs/extras/keyset_numeric) sets it to the `session` object by defult.

==- `:cache_key`

!!!warning

Set this only if the default `cache_key` generated and used by pagy causes the pagination to skip pages, raises
`Pagy::OverflowError` or resets to page 1
!!!

### Understanding the cache_key

<br/>The `cache_key` is a string that must uniquely identify a specific `cutoff snapshot`. Pagy uses it to determine which
paginated set each `page` request belongs to, in order to access the cached data.

Since the `cutoff snapshot` is the product of a certain DB query influenced by different factors, we can simply concatenate ALL
the factors that actually AFFECT the `cutoff snapshot` and we will produce the `cache_key` that uniquely identifies it.

If we miss any factor that AFFECT the `cutoff snapshot` the resulting `cached_key` may stay the same even when the
`cutoff snapshot` has changed between requests, which is a fatal inconsistency for accessing cached data: _this would cause the
pagination to repeat or skip records/pages_.

Notice however that we must INCLUDE ONLY the factors that AFFECT the `cutoff snapshot`. If we include any factor that may change
between requests WITHOUT AFFECTING the `cutoff snapshot`, the resulting `cached_key` may change even when the `cutoff snapshot` is
the same, which is another fatal inconsistency for accessing cached data: _this would cause the cache to switch to a new key
without `cutoffs`, likely generating a Pagy::OverflowError_

### Identifying the factors to include/exclude in the `cache_key`

<br/>The factors that change the `cutoff snapshot`, that must be included in the generation of the `cache_key`, are those
affecting one or more of the following:

- the number of total results/records (i.e. `where`, `:group`, `:having` clauses)
- the order of the records (i.e. the `order` clause)
- the page length (i.e. the `vars[:limit]` set by pagy)

Not every factor that changes the query has an impact on the `cutoff snapshot`. For example: if you change the `select` clause,
there will be no change in the `cutoff snapshot` so you must NOT include it as a factor. On the other hand, a `search` field that
the user can fill IS a factor, because the resulting records may be different, and by consequence the`cutoff snapshot`.

#### How to create your own `:cache_key`

<br/>Pagy create a default `cache_key` for you by generating a `SHA2` hexdigest out of the concatenation of:

- the selective sql of your `set` (i.e. only the `where`, `order`, `group` and `having`)
- the `vars[:limit]` variable

If that doesn't work for you, you should create your own. For example:

```ruby
# If you have just a "search" field, the :cache_key may be assigned like:
cache_key = ->(_vars) { params(:search) }

# If you have also other fields
# and a possibly changing :limit and order (:keyset) variables:
cache_key = lambda do |vars|
  [params.slice(:search, :category, :year, ...), # search params
   vars.slice(:limit, :keyset), # vars that change the page records
  ].to_json
end
```

==- `:max_pages`

Paginate only `:max_pages` ignoring the rest.

===

## Attribute Readers

`cache_key`, `in`, `last`, `limit`, `next`, `page`, `prev`, `vars`

## Troubleshooting

See the [Pagy::Keyset Troubleshooting](keyset.md#variables)
