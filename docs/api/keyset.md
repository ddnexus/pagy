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

It is also accurate: while offset pagination can skip or double-show records after insertion and deletions, keyset is always accurate.

This technique comes with that huge advantages and a set of limitations that makes it particularly useful for APIs and less
convenient for UIs in general.

!!!success UI-Compatible Keyset Numeric pagination is also available!

If you want the best of the two worlds, check out the [keyset_numeric extra](/docs/extras/keyset_numeric.md) that supports for the
`pagy_*nav` and the other Frontend helpers
!!!

### Glossary

| Term                        | Description                                                                                                                                                                                                                                                                                           |
|-----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `offset pagination`         | The technique to fetch each page by incrementing the `offset` from the collection start.<br/>It requires two queries per page (or one if [countless](/docs/api/countless.md)): it's slow toward the end of big tables.<br/>It can be used for a rich frontend: it's the regular pagy pagination.      |
| `keyset pagination`         | The technique to fetch the next page starting after the latest fetched record in an `uniquely ordered` collection.<br/>It requires only one query per page: it's very fast regardless the table size and position (if properly indexed). Support only infinite pagination, no other frontend helpers. |
| `keyset numeric pagination` | The pagy exclusive technique to use `keyset pagination` with numeric pages, supporting `pagy_*navs` and other Frontend helpers. The best technique for performance AND functionality!                                                                                                                 |
| `uniquely ordered`          | The property of a `set`, when the concatenation of the values of the ordered columns is unique for each record. It is similar to a composite primary `key` for the ordered table, but dynamically based on the `keyset` columns.                                                                      |
| `set`                       | The `uniquely ordered` `ActiveRecord::Relation` or `Sequel::Dataset` collection to paginate.                                                                                                                                                                                                          |
| `keyset`                    | The hash of column/direction pairs. Pagy extracts it from the order of the `set`.                                                                                                                                                                                                                     |
| `keyset attributes`         | The hash of keyset-column/record-value pairs of a record.                                                                                                                                                                                                                                             |
| `cut`                       | A point in the `set` that separates the records of two contiguous `page`s. It's the encoded reference to the last record of a `page`.                                                                                                                                                                 |
| `page`                      | The current `page`, i.e. the page of records beginning after the `prev_cut`. Also the `:page` variable, which is set to the `prev_cut`                                                                                                                                                                |
| `next`                      | The next `page`, i.e. the page of records beginning after the `next_cut`. Also the `next_cut` value retured by the `next` method.                                                                                                                                                                       |

### Keyset, Numeric or Offset pagination?

+++ Keyset

!!!success Use Keyset pagination with large dataset and API

You will get the fastest pagination and accuracy, regardless the table size and the relative position of the page

!!!warning Limited use for UIs

Only useful when you don't need any frontend (e.g. infinite pagination)
!!!
 
+++ Numeric
!!!success The best of the two worlds!

* The same performance of Keyset
* Most of the Frontend features

!!!warning Advanced usage

It requires more effort and resource to setup
!!!

+++ Offset
!!!success Use Offset pagination with UIs and small DBs

* You will get all the frontend features
* You can avoid the slowness by simply limiting the `:max_pages` pages: the users would not browse thousands of
  records deep into your collection anyway

!!!warning Limited use for APIs

* Your server will suffer on big data and your API will be slower for no good reasons  
* Not accurate: It can skip or double-show records after insertion and deletions.
!!!
+++

## Usage

### Constraints for simple Keyset pagination

!!!success IMPORTANT!

Most of the UI constraints below can be avoided by using the [keyset_numeric extra]()
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
- It requests the `next` URL by setting its `page` query string param to the `next_cut` of the current page.
- At each request, the new `page` is decoded into `cut_args` that are coupled with a `where` filter query, and the `:limit` of new
  records is pulled.
- You know that you reached the end of the collection when `pagy.next.nil?`.

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
`Pagy::Keyset::Sequel` object (depending by the `set` class).

==- `next`

The next `page`, i.e. the `cut` after the last record of the **current page**. It is `nil` for the last page.

==- `records`

The `Array` of fetched records for the current page.

===

## Variables

=== `:page`

The current page, i.e. the `next_cut` of the **previous page**. Default `nil` for the first page.

=== `:limit`

The `:limit` per page. Default `Pagy::DEFAULT[:limit]`. You can use the [limit extra](/docs/extras/limit.md) to have it
automatically assigned from the `limit` request param.

=== `:tuple_comparison`

Boolean variable that enables the tuple comparison e.g. `(brand, id) > (:brand, :id)`. It works only with the same direction
order, hence it's ignored for mixed order. Check how your DB supports it (your `keyset` should include only `NOT NULL` columns).
Default `nil`.

==- `:jsonify_keyset_attributes`

A lambda to override the generic json encoding of the `keyset` attributes. Use it when the generic `to_json` method would lose
some information when decoded.

For example: `Time` objects may lose or round the fractional seconds through the encoding/decoding cycle, causing the ordering to
fail and thus creating all sort of unexpected behaviors (e.g. skipping or repeating the same page, missing or duplicated records,
etc.). Here is what you can do:

```ruby
# Match the microsecods with the strings stored into the time columns of SQLite
jsonify_keyset_attributes = lambda do |attributes|
  # Convert it to a string matching the stored value/format in SQLite DB
  attributes[:created_at] = attributes[:created_at].strftime('%F %T.%6N')
  attributes.to_json
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
