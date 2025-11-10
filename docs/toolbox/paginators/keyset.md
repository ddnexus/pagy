---
label: :keyset
icon: infinity
order: 70
categories:
  - Paginators
---

#

## :icon-infinity: :keyset

---

`:keyset` is the **fastest** paginator for SQL collections.

!!!success :keyset

- **It works with:**
  - `ActiveRecord::Relation` or `Sequel::Dataset` sets
  - Single or multiple ordered columns
  - Any combination of order directions
- **Unlike the classic OFFSET pagination:**
  - Its performance is reliably fast from start to end, no matter how big your table is.
  - It's completely accurate. Even with insertions or deletions during browsing, it will never repeat or miss records.
  - Does not suffer from `RangeError`s
!!!

!!!warning It has limited UI support

It's mostly used for API or infinite scrolling.

!!!success For KEYSET pagination with UI support...

Use the [:keynav_js](keynav_js.md) paginator.
!!!

```ruby Controller
@pagy, @records = pagy(:keyset, set, **options)
```

```ERB
<!-- The only supported helper -->
<%== @pagy.next_tag(text: 'Next page &gt;') %>
```

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](../../sandbox/playground#keyset-apps)

==- Glossary

There are a few peculiar aspects of the keyset pagination technique that you might not be familiar with. Here is a concise list:

{ .compact }

| Term                | Description                                                                                                                                                                                                                                                                                                                                |
|---------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `offset pagination` | The technique to fetch each page by incrementing the `offset` from the collection start.<br/>It requires two queries per page (or only one if you use [countless](countless.md)): it's slow toward the end of big tables.<br/>It can be used for a rich frontend: it's the classic pagy pagination.                                        |
| `keyset pagination` | The technique to fetch the next page starting after the latest fetched record in a `uniquely ordered` collection.<br/>It requires only one query per page (without OFFSET). if properly indexed, it's the fastest technique, regardless of the table size and position. Supports only infinite pagination, with no other frontend helpers. |
| `keynav pagination` | The pagy exclusive technique to use `keyset` pagination, providing **nearly complete** UI support. The fasted technique with UI capabilities.                                                                                                                                                                                              |
| `uniquely ordered`  | The property of a `set`, when the concatenation of the values of the ordered columns is unique for each record. It is similar to a composite primary `key` for the ordered table, but dynamically based on the `keyset` columns.                                                                                                           |
| `set`               | The `uniquely ordered` `ActiveRecord::Relation` or `Sequel::Dataset` collection to paginate.                                                                                                                                                                                                                                               |
| `keyset`            | The hash of column/order pairs. Pagy extracts it from the order of the `set`.                                                                                                                                                                                                                                                              |
| `keyset attributes` | The hash of attributes of the `keyset` columns of a record.                                                                                                                                                                                                                                                                                |
| `cutoff`            | The value that identifies where the `page` ends, and the `next` one begins. It is encoded as a `Base64` URL-safe string.                                                                                                                                                                                                                   |
| `page`              | The current `page`, i.e. the page of records beginning after the `cutoff` of the previous page. Also the `:page` option, which is set to the `cutoff` of the previous page                                                                                                                                                                 |
| `next`              | The next `page`, i.e. the page of records beginning after the `cutoff`. Also the `cutoff` value retured by the `next` method.                                                                                                                                                                                                              |

==- Constraints

!!!success IMPORTANT!

Almost all the constraints below can be avoided by using the [:keynav_js](keynav_js) paginator when you need a proper UI.
!!!

!!!warning With the standard keyset pagination technique...

- You can only paginate from one page to the next: no jumping to arbitrary pages.
- The `set` must be `uniquely ordered`. Add the primary key (usually `:id`) as the last order column to be sure.
- You should add the most suitable DB index for your ordering strategy, or it will be slow.

!!!

!!!warning With Pagy `:keyset`...

You don't know the `previous` and the `last` page; you only know the `first` and `next` pages for performance and simplicity.

!!!success

If you want to paginate backward, like: `last` ... `prev` ... `prev`, just call `reverse_order` on your set, and proceed forward
like:
`first` ... `next` ... `next` ... It does exactly the same: just faster and simpler.

!!!

==- Setup

Ensure that your set is `uniquely ordered`, and that your tables have the appropriate indexes.

Depending on your order requirements, here is how you set it up:

+++ No order requirements
!!!success If you don't need any specific ordering...

`order(:id)` is the simplest choice because the `id` column is unique and already indexed.

It is fast out of the box without any setup.
<br><br><br><br>
!!!

+++ Specific order requirements
!!!success If you need a specific ordering...

- **In order to make it work**...
  - Ensure the uniquenes of the last ordered columns OR append your primary keys to your order.
- **In order to make it fast**...<br/>
  - Ensure to have an index including the exact same columns and ordering direction of your set.

!!!
+++

==- Options

- `keyset: {...}`
  - Set it only to force the `keyset` hash of column/order pairs. _(It is set automatically from the set order)_
- `tuple_comparison: true`
  - Enable the tuple comparison e.g. `(brand, id) > (:brand, :id)`. It works only with the same direction order, hence, it's
    ignored for mixed order. Check how your DB supports it (your `keyset` should include only `NOT NULL`
    columns).
- `pre_serialize: serialize`
  - Set it to a `lambda` that receives the `keyset_attributes` hash. Modify this hash directly to customize the serialization of
    specific values (e.g., to preserve `Time` object precision). The lambda's return value is ignored.
    ```ruby 
    serialize = lambda do |attributes|
      # Convert it to a string matching the stored value/format in SQLite DB
      attributes[:created_at] = attributes[:created_at].strftime('%F %T.%6N')
    end
    ```

See also [Common Options](../paginators#common-options)

==- Readers

- `records`
  - The `Array` of fetched records for the current page.

See also [Common Readers](../paginators#common-readers)

==- How it works

<br/>

- You pass an `uniquely ordered` `set` and pagy pulls the `:limit` of records of the first page.
- You request the `next` URL, which has the `page` param set to the `cutoff` of the current page.
- At each request, the new `page` is decoded into arguments that are coupled with a `where` filter query, and a `:limit` of new
  records is retrieved.
- The collection ends when `pagy.next.nil?`.

==- In Depth: Cutoffs

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
COUNTing the records (i.e., the whole point we want to avoid for performance).

So we read the `id` of the last one, which is the value `X` in our example... and that is the `cutoff` value of the first page. It
can be described like:
_"the point up to the value `X` in the `id` column"_.

Notice that this is not like saying _"up to the record `X`"_. It's important to understand that a `cutoff` refers just to a cutoff
value of a column (or the values of multiple column, in case of multi-columns keysets).

Indeed, that very record could be deleted right after we read it, and our `cutoff-X` will still be the valid truth that we
paginated the `set` up to the "X" value, cutting any further record off the `page`...

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
which naturally ends with the end of the `set`, so it doesn't have any `cutoff` value to separate it from further records.

!!! Keynotes

- A `cutoff` identifies a "cutoff value", for a `page` in the `set`. It is not a record, nor a reference to it.
- Its value is extracted from the `keyset attributes values` array of the last record of the `page`, converted to JSON, and
  encoded as a Base64 URL-safe string, for easy use in URLs.
  - The `:keyset` paginator embeds it in the request URL; the `:keynav_js` paginator caches it on the client `sessionStorage`.
- All the `page`s but the last, end with the `cutoff`.
- All the `page`s but the first, begin AFTER the `cutoff` of the previous `page`.

!!!

==- Troubleshooting

<br/>

##### 1. Records may repeat or be missing from successive pages

<br/>

!!!danger The set may not be `uniquely ordered`

```rb
# Neither column is unique
Product.order(:name, :production_date)
```

!!!success Append the primary key to the order

```rb
# Add the :id as the last column
Product.order(:name, :production_date, :id)
```

!!!

!!!danger You may have an encoding problem

The generic `to_json` method used to encode the `page` may lose some information when decoded

!!!success

- Check the actual executed DB query and the actual stored value
- Identify the column that has a format that doesn't match with the keyset
- Override the encoding with the [:pre_serialize](#options) option

!!!

<br/>

##### 2. The order is OK, but the DB is still slow

<br/>

!!!danger Most likely the index is not right, or your case needs a custom query

!!!success

- Ensure that the composite index reflects exactly the columns sequence and order of your keyset
- Research your specific DB features, type of index, and performance for different ordering. Use SQL `EXPLAIN ANALYZE` or similar
  tool to confirm.
- Consider using the same direction order, enabling the `:tuple_comparison`, and changing type of index (different DBs may behave
  differently).
- Consider overriding the `Keyset#compose_predicate` method.

!!!

===
