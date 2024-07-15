---
title: Pagy::Keyset
category:
  - Feature
  - Class
---

# Pagy::Keyset

Implement wicked-fast keyset pagination for big data.

!!!  

The class API is documented here, however you should not need to use this
class directly because it is required and used internally by the [keyset extra](/docs/extras/keyset.md)

!!!

## Concept

The "Keyset" pagination, also known as "SQL Seek Method" (and often, improperly called "Cursor" pagination) is a tecnique that avoids the inevitable slowness of querying pages deep into a collection (i.e. when `offset` is a big number, you're going to get slower queries).

This tecnique comes with that huge advantage and a set of limitations that makes it particularly useful for APIs and pretty useless for UIs. 

### Keyset or Offset pagination?

!!!success Use Keyset pagination with large dataset and API

- You will get the fastest pagination, regardless the table size and the relative position of the page

!!!danger Do not use with UIs even with large datasets
- You would be missing all the frontend features
- You would have to setup your DB very carefully in order to get good performance anyway

!!!

!!!success Use Offset pagination with UIs even with large datasets

- You will get all the frontend features
- It will be easier to maintain because it requires almost no knowledge of SQL
- You can avoid the slowness on big tables by simply limiting the `:max_pages` pages: the users would not browse thousands of 
  records deep into your collection anyway 

!!!danger Do not use with APIs
- Your server will suffer on big data and your API will be slower for no good reasons  
!!!
  
### Keyset Glossary
    
| Term     | Description                                                                                                                                                                                                                                                      |
|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `set`    | The uniquely ordered `ActiveRecord::Relation` or `Sequel::Dataset` to paginate.                                                                                                                                                                                  |
| `keyset` | The hash of column/direction pairs that pagy extracts from the order of the `set`. It works similarly to a composite primary `key` for the ordered table. For that reason the concatenation of the values of the ordered columns must be unique for each record. |
| `latest` | The hash of `keyset` attributes of the latest retrieved record. Pagy decodes it from the `page`.                                                                                                                                                                 |
| `page`   | The `latest` (`Base64.urlsafe_encoded`) that can be passed around as a query param.                                                                                                                                                                              |

## Overview

Pagy Keyset pagination does not waste resources and code complexity checking your set and your table config at every request.

That means that you have to be sure that your set is uniquely ordered and that your tables have the right indices (for 
performance). You do it once during development, and pagy will be fast at each request. ;)

### Constraints

Like any keyset pagination:
  - You don't know the record count nor the page count
  - The pages have no number
  - You cannot jump to an arbitrary page
  - You can only get the next page
  - You know that you reached the end of the collection when `pagy.next.nil?` 
     
Similarly to the Pagy Offset pagination:
  - You paginate only forward. To go backward... just reverse the order
    in your scope and paginate forward in the reversed order.

Besides:
  - You don't know the previous and the last page
  - The `set` must be uniquely ordered. Add the primary key (usually `:id`) as the last order column to be sure
  - You should add the best DB index for your ordering strategy for performance. The keyset pagination would work even without
    any index, but that would defeat its purpose (performance).
    
!!!success
The choice to avoid backward pagination and omitting previous and last pages has a very good trade-off:
- The code is a lot faster and simpler to maintain
- The logic is easier to understand
- Overriding is straightforward
!!!  

### ORMs

`Pagy::Keyset` implements the subclasses for `ActiveRecord::Relation` and `Sequel::Dataset` sets and instantiate them internally:

```ruby
Pagy::Keyset.new(active_record_set)
#=> #<Pagy::Keyset::ActiveRecord:0x00000001066215e0>
 
Pagy::Keyset.new(sequel_set) 
#=> #<Pagy::Keyset::Sequel:0x00000001066545e0>
```

## How pagy keyset works

You pass an uniquely ordered `set`, and `Pagy::Keyset` queries the page of records, keeping track of the last retrieved record by 
encoding it into the `page` param of the `next` URL. At each request the `:page` is decoded and used to prepare a `when` clause 
that excludes the records retrived up to that point and pulls the number of requested records.

## Variables

=== `:page`

The current `page`. Default `nil` for the first page.

=== `:items`

The number of `:items` per page. Default `DEFAULT[:items]`. You can use the [items extra](/docs/extras/items.md) to get it automatically from the request param.

=== `:row_comparison`

Boolish variable that enables the row comparison query for same-direction keysets (use B-tree indices for performance).
Default `nil`.

==- `:after_latest`

A lambda to filter out the records after the `latest`. If defined, pagy will
call it with the `set` and the `latest` arguments instead of using its auto-generated query. Use it for DB-specific extra
optimizations if you know what you are doing.
For example:

```ruby
after_latest = lambda do |set, latest|
  set.where(after_latest_query, **latest)
end

Pagy::Keyset(set, after_latest:)
```

==- `:typecast_latest`

A lambda that overrides the automatic typecasting of your ORM. For example: `SQLite` stores date and times
as strings, and the query interpolation may fail composing and comparing string dates. The `typecast_latest` is an effective
last-resort option when fixing the typecasting in your models and/or the data in your storage is not possible.

```ruby
typecast_latest = lambda do |latest| 
  latest[:timestamp] = Time.parse(latest[:timestamp]).strftime('%F %T')
  latest
end

Pagy::Keyset(set, typecast_latest:)
```

===

## Accessors

`items`, `latest`, `page`, `vars`

## Methods

==- `Pagy::Keyset.new(set, **vars)`

The constructor takes the `set`, and an optional hash of [variables](#variables).
 It returns a `Pagy::Keyset::ActiveRecord` or `Pagy::Keyset::Sequel` object (depending by the `set` class)

==- `next`

The next `page`, i.e. the encoded `latest` hash used to exclude the records retrieved up to that point.

==- `records`

The `Array` of records for the current page.

===

## Troubleshooting

==- Records may repeat or be missing from successive pages


!!!danger Your set is not uniquely ordered

Pagy does not check if your set is uniquely ordered (read why in the [overview](#overview))

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

!!!danger ... or you have a typecasting problem
Your ORM and the storage formats don't match for one or more columns. It's a common case with `SQLite` and Time columns that 
have been stored as strings fomatted differently than the default format used by your current ORM.

!!!success
- Check the actual executed DB query and the actual stored value
- Identify the column that have a format that doesn't match with the keyset
- Fix the typecasting consistence of your ORM with your DB or consider using your custom typecasting with the [:typecast_latest](#typecast-latest) variable
!!!
  
==- The set is ok, but the DB is still slow

!!!danger
Most likely your index is not right, or you need a custom query

!!! Success

- Ensure that the index reflects exactly the columns sequence and order of your keyset
- Research about your specific DB features: type of index and performance for different ordering
- Consider using your custom optimized `when` query with the [:after_latest](#after-latest) variable
!!!

===
