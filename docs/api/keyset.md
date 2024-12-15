---
title: Pagy::Keyset
category:
  - Feature
  - Class
---

# Pagy::Keyset

Implement wicked-fast keyset pagination for big data.

!!!success Pagy Keyset works with...

- `ActiveRecord::Relation` or `Sequel::Dataset` sets
- Single or multiple ordered columns
- The same order direction or any combination of mixed order directions
- The [limit](/docs/extras/limit.md), [headers](/docs/extras/headers.md) and [jsonapi](/docs/extras/jsonapi.md) extras
  !!!

!!!
Concept and API are documented here, however you may prefer to use the [keyset extra](/docs/extras/keyset.md) wrapper to easily
integrate it with your app.
!!!

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#5-keyset-apps)

## Concept

The "Keyset" pagination, also known as "Cursor Pagination" or "SQL Seek Method" is a technique that avoids the inevitable slowness
of querying pages deep into a collection (i.e. when `offset` is a big number, you're going to get slower queries).

It is also accurate: while offset pagination can skip or double-show records after insertion and deletions, keyset is always
accurate.

This technique comes with that huge advantages and a set of limitations that makes it particularly useful for APIs and less
convenient for UIs in general.

!!!success Keyset For UI pagination is also available!

If you want the best of the two worlds, check out the [keyset_for_ui extra](/docs/extras/keyset_for_ui.md) that supports the
`pagy_*nav` and the other Frontend helpers
!!!

### Glossary

| Term                       | Description                                                                                                                                                                                                                                                                                           |
|----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `offset pagination`        | The technique to fetch each page by incrementing the `offset` from the collection start.<br/>It requires two queries per page (or one if [countless](/docs/api/countless.md)): it's slow toward the end of big tables.<br/>It can be used for a rich frontend: it's the regular pagy pagination.      |
| `keyset pagination`        | The technique to fetch the next page starting after the latest fetched record in an `uniquely ordered` collection.<br/>It requires only one query per page: it's very fast regardless the table size and position (if properly indexed). Support only infinite pagination, no other frontend helpers. |
| `keyset pagination for UI` | The pagy exclusive technique to use `keyset pagination` with numeric pages, supporting `pagy_*navs` and other Frontend helpers. The best technique for performance AND functionality!                                                                                                                 |
| `uniquely ordered`         | The property of a `set`, when the concatenation of the values of the ordered columns is unique for each record. It is similar to a composite primary `key` for the ordered table, but dynamically based on the `keyset` columns.                                                                      |
| `set`                      | The `uniquely ordered` `ActiveRecord::Relation` or `Sequel::Dataset` collection to paginate.                                                                                                                                                                                                          |
| `keyset`                   | The hash of column/direction pairs. Pagy extracts it from the order of the `set`.                                                                                                                                                                                                                     |
| `keyset attributes`        | The hash of keyset-column/record-value pairs of a record.                                                                                                                                                                                                                                             |
| `keyset values`            | The array of the `values` of the `keyset attributes`.                                                                                                                                                                                                                                                   |
| `cutoff`                   | The value that identifies where the `page` ends, and the `next` one begins. It is encoded as a `Base64` URL-safe string.                                                                                                                                                                              |
| `page`                     | The current `page`, i.e. the page of records beginning after the `cutoff` of the previous page. Also the `:page` variable, which is set to the `cutoff` of the previous page                                                                                                                          |
| `next`                     | The next `page`, i.e. the page of records beginning after the `cutoff`. Also the `cutoff` value retured by the `next` method.                                                                                                                                                                         |

### Choose the right pagination type

+++ Keyset

!!!success Use Keyset pagination with large dataset and API

You will get the fastest pagination and accuracy, regardless the table size and the relative position of the page

!!!warning Limited use for UIs

Only useful when you don't need any frontend (e.g. infinite pagination)
!!!

+++ Keyset for UI
!!!success The best of the two worlds!

* The same performance of Keyset
* Most of the Frontend features

!!!warning Advanced usage; no use in APIs

- It requires more effort and resource to setup
- It does not make sense in APIs that don't need UI
!!!

+++ Offset
!!!success Use Offset pagination with UIs and small DBs

* You will get all the frontend features
* You can reduce the slowness by limiting the `:max_pages` pages

!!!warning Limited use for APIs; not guaranteed to be accurate in UI

* Your server will suffer on big data and your API will be slower for no good reasons
* Not accurate: It can skip or double-show records after insertion and deletions.
  !!!
  +++

## Usage

### Constraints for simple Keyset pagination

!!!success IMPORTANT!

Most of the UI constraints below can be avoided by using the [keyset_for_ui extra]()
!!!

!!!warning With the standard keyset pagination technique...

- You can only paginate from one page to the next: no jumping to arbitrary pages
- The `set` must be `uniquely ordered`. Add the primary key (usually `:id`) as the last order column to be sure
- You should add the best DB index for your ordering strategy for performance. The keyset pagination would work even without any
  index, but that would defeat its purpose (performance).

!!!

!!!warning With Pagy::Keyset...

You don't know the `previous` and the `last` page, you only know the `first` and `next` pages, for performance and simplicity

!!!success

If you want to paginate backward like: `last` ... `prev` ... `prev` ... just call `reverse_order` on your set and go forward like:
`first` ... `next` ... `next` ... It does exactly the same: just faster and simpler.

!!!

### Setup

Pagy Keyset pagination does not waste resources and code complexity checking your set and your table config at every request.

That means that you have to be sure that your set is `uniquely ordered` and that your tables have the right indexes.

**You do it once during development, and pagy will be fast at each request.**

Depending on your order requirements, here is how you set it up:

+++ No order requirements
!!!success

If you don't need any ordering, `order(:id)` is the simplest choice, because it's unique and already indexed. It is fast out of
the box without any setup.

!!!

+++ Specific order requirements
!!!success

If you need a specific order:

- **In order to make it work**...<br/>
  Ensure that at least one of your ordered columns is unique OR append your primary keys to your order
- **In order to make it fast**...<br/>
  Ensure to create a unique composite DB index, including the exact same columns and ordering direction of your set

!!!
+++

### How Pagy::Keyset works

- You pass an `uniquely ordered` `set` and `Pagy::Keyset` pulls the `:limit` of records of the first page.
- It requests the `next` URL by setting its `page` query string param to the `cutoff` of the current page.
- At each request, the new `page` is decoded into `cutoff_args` that are coupled with a `where` filter query, and the `:limit` of
  new records is pulled.
- You know that you reached the end of the collection when `pagy.next.nil?`.

#### Understanding the Cutoffs

The `cutoff` of a `page` is the **value** that identifies where the `page` _has ended_, and the `next` one begins.

Let's consider an example of a simple `set` of 29 records, with an `id` column populated by character keys, and its order is:
`order(:id)`.

Assuming a LIMIT of 10, the _"first page"_ will just include the first 10 records in the `set`: no `cutoff` value is known so
far...

```
                  │ first page (10)  >│ rest (19)                          >│
beginning of set >[· · · · · · · · · ·]· · · · · · · · · · · · · · · · · · ·]< end of set
```

At this point, it's the exact same first page pulled with OFFSET pagination, however, we don't want to use OFFSET to get the
records after the first 10: that would be slow in a big table, so we need a way to identify the beginning of the next page without
counting the records.

At this point we need to get the next 10 records... WITHOUT using OFFSET (i.e. the whole point we want to avoid for performance),
so we read the `id` of the last one, which is `X`... and that is the `cutoff` value of the first page. It can be described like:
_"the point up to the value `X` in the `id` column"_.

Notice that this is not like saying _"up to the record `X`"_. It's important to understand that a `cutoff` refers just to a value
in a column (or a combination of multiple column, in case of muti-columns keysets).

Indeed, that very record could be deleted right after we read it, and our `cutoff-X` will still be the valid truth that we
paginated the `set`, up to the "X" value", cutting any further record off the `page`...

```
                  │ first page (10)  >│ second page (10) >│ rest (9)       >│
beginning of set >[· · · · · · · · · X]· · · · · · · · · ·]· · · · · · · · ·]< end of set
                                      ▲
                                   cutoff-X
```

For getting the `next` page of records (i.e. the _"second page"_) we pull the `next` 10 records AFTER the `cutoff-X`. Again, we
read the `id` of the last one, which is `Y`: so we have our new `cutoff-Y`, which is the end of the current `page`, and the `next`
will go AFTER it...

```
                  │ first page (10)  >│ second page (10) >│ last page (9)  >│
beginning of set >[· · · · · · · · · X]· · · · · · · · · Y]· · · · · · · · ·]< end of set
                                      ▲                   ▲
                                   cutoff-X            cutoff-Y
```

When we pull the `next` page from the `cutoff-Y`, we find only the remaining 9 records, which means that it's the _"last page"_,
which naturally ends with the end of the `set`, so it doesn't need any `cutoff` value to spearate it from further records.

#### Keynotes

- A `cutoff` identifies a "cutoff value", for a `page` in the `set`. It is not a record nor a reference to it.
- Its value is derived from the `keyset attributes values` array of the last record of the `page`, converted to JSON, and encoded
  as a Base64 URL-safe string, for easy use in URLs.
  - `Pagy::Keyset` embeds it in the request URL; `Pagy::KeysetForUI` caches it on the server.
- All the `page`s but the last, end with the `cutoff`.
- All the `page`s but the first, begin AFTER the `cutoff` of the previous `page`.

## ORMs

`Pagy::Keyset` implements the subclasses for `ActiveRecord::Relation` and `Sequel::Dataset` sets and instantiate them internally:

```ruby
Pagy::Keyset.new(active_record_set)
#=> #<Pagy::Keyset::ActiveRecord:0x00000001066215e0>

Pagy::Keyset.new(sequel_set)
#=> #<Pagy::Keyset::Sequel:0x00000001066545e0>
```

## Methods

==- `Pagy::Keyset.new(set, **vars)`

The constructor takes the `set`, and an optional hash of [variables](#variables). It returns a `Pagy::Keyset::ActiveRecord` or
`Pagy::Keyset::Sequel` object (depending on the `set` class).

==- `next`

The next `page`, i.e. the `cutoff` after the last record of the **current page**. It is `nil` for the last page.

==- `records`

The `Array` of fetched records for the current page.

===

## Variables

=== `:page`

The current page, i.e. the `cutoff` of the **previous page**. Default `nil` for the first page.

=== `:limit`

The `:limit` per page. Default `Pagy::DEFAULT[:limit]`. You can use the [limit extra](/docs/extras/limit.md) to have it
automatically assigned from the `limit` request param.

==- `:tuple_comparison`

Boolean variable that enables the tuple comparison e.g. `(brand, id) > (:brand, :id)`. It works only with the same direction
order, hence it's ignored for mixed order. Check how your DB supports it (your `keyset` should include only `NOT NULL` columns).
Default `nil`.

==- `:jsonify_keyset_attributes`

A lambda to override the generic JSON encoding of the `keyset attributes`. It receives the `keyset attributes` as an arument, and
it should return a JSON string of the `attributes.values` array. Use it when the generic `to_json` method would lose some
information when decoded.

For example: `Time` objects may lose or round the fractional seconds through the encoding/decoding cycle, causing the ordering to
fail and thus creating all sort of unexpected behaviors (e.g. skipping or repeating the same page, missing or duplicated records,
etc.). Here is what you can do:

```ruby
# Match the microsecods with the strings stored into the time columns of SQLite
jsonify_keyset_attributes = lambda do |attributes|
  # Convert it to a string matching the stored value/format in SQLite DB
  attributes[:created_at] = attributes[:created_at].strftime('%F %T.%6N')
  attributes.values.to_json # remember to return the array of values, not the attribute hash
end

Pagy::Keyset(set, jsonify_keyset_attributes:)
```

!!! ActiveRecord alternative for time_precision

With `ActiveRecord::Relation` set, you can fix the fractional seconds issue by just setting the `time_precision`, no need to use
the `:jsonify_keyset_attributes` lambda:

```ruby
ActiveSupport::JSON::Encoding.time_precision = 6
```

!!!

_(Notice that it doesn't work with `Sequel::Dataset` sets)_

===

## Attribute Readers

`limit`, `page`, `vars`

## Troubleshooting

==- Records may repeat or be missing from successive pages

!!!danger The set may not be `uniquely ordered`

```rb
# Neither columns are unique
Product.order(:name, :production_date)
```

!!! success Append the primary key to the order

```rb
# Add the :id as the last column
Product.order(:name, :production_date, :id)
```

!!!

!!!danger You may have an encoding problem

The generic `to_json` method used to encode the `page` may lose some information when decoded

!!!success

- Check the actual executed DB query and the actual stored value
- Identify the column that have a format that doesn't match with the keyset
- Override the encoding with the [:jsonify_keyset_attributes](#jsonify-keyset-attributes) variable

!!!

==- The order is OK, but the DB is still slow

!!!danger Most likely the index is not right, or your case needs a custom query

!!! Success

- Ensure that the composite index reflects exactly the columns sequence and order of your keyset
- Research about your specific DB features, type of index and performance for different ordering. Use SQL `EXPLAIN ANALYZE` or
  similar tool to confirm.
- Consider using the same direction order, enabling the `:tuple_comparison`, and changing type of index (different DBs may behave
  differently)
- Consider using your custom optimized `when` query with the [:filter_newest](#filter-newest) variable

!!!

===
