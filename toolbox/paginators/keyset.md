#

## :icon-key:&nbsp;&nbsp;:keyset

---

`:keyset` is the **fastest** [KEYSET](/guides/choose-right/#keyset) paginator for `ActiveRecord::Relation` or `Sequel::Dataset` SQL ordered collections.

It uses a much faster pagination technique than [OFFSET](/guides/choose-right/#offset).

[!button corners="pill" variant="info" icon="play-24" text="Check it out with `bundle exec pagy keyset`"](/sandbox/playground/#keysets)

==- :icon-blocked:&nbsp; Constraints

!!!tip When an UI is needed, and using [KEYSET Pagination](/guides/choose-right/#keyset) is possible, use the [:keynav_js](keynav_js) paginator to overcome almost all these constraints.
!!!

!!!warning With any KEYSET pagination technique...
- You can only paginate from one page to the next: no jumping to arbitrary pages.
- The `set` must be `uniquely ordered`. Add the primary key (usually `:id`) as the last order column to be sure.
- You should add the most suitable DB index for your ordering strategy, or it there will be no performance gain.
  !!!

!!!warning With Pagy `:keyset`...
You don't know the `previous` and the `last` page; you only know the `first` and `next` pages.

:icon-light-bulb: If you want to paginate backward, just call `reverse_order` on your set, and proceed forward.
!!!

==- :icon-list-ordered:&nbsp; Setup

Depending on your **order requirements**, here is how you set it up for maximum efficiency:

+++ No Order Requirement

Just order by `:id`. It's fast out of the box without any setup...

```rb
set = collection.order(:id)
```

+++ Specific Order Requirement

>>> Ensure that your set is `uniquely ordered`

[!badge variant="info" size="s" corners="pill" text="Option 1"]&nbsp; If the combination of the values of the ordered columns **is certainly unique**...

```rb
set = collection.order(:brand).order(:model)
```

[!badge variant="info" size="s" corners="pill" text="Option 2"]&nbsp; If **it's possibly not unique**, just append a unique column to the order (e.g., your primary keys).

```rb
set = collection.order(:last_name).order(:first_name).order(:id)
```

>>> Ensure that your table has the appropriate index AND index type

[!badge variant="info" size="s" corners="pill" text="•1"]&nbsp; The index must include the exact same columns and ordering direction of your set.<br>
[!badge variant="info" size="s" corners="pill" text="•2"]&nbsp; The index type must minimize the data scan (e.g. B-tree, B+ Tree, ...)

>>>

+++

=== :icon-tools:&nbsp; Usage

```ruby Controller
@pagy, @records = pagy(:keyset, set, **options)
```

- `@pagy` is the pagination instance. It provides the [readers](#readers) and the [helpers](../helpers) to use in your code.
- `@records` is the eager-loaded `Array` of the page records.

```ERB
<!-- The only supported UI helper -->
<%== @pagy.next_tag(text: 'Next page &gt;') %>
```

==- :icon-sliders:&nbsp; Options

`keyset: {...}`
: Set it only to force the `keyset` hash of column/order pairs. _(It is set automatically from the set order)_

`tuple_comparison: true`
: Enable the tuple comparison e.g. `(brand, id) > (:brand, :id)`. It works only with the same direction order, hence, it's ignored for mixed order. Check how your DB supports it (your `keyset` should include only `NOT NULL` columns).

`pre_serialize: serialize`
: Set it to a `lambda` that receives the `keyset_attributes` hash. Modify this hash directly to customize the serialization of specific values (e.g., to preserve `Time` object precision). The lambda's return value is ignored.
  ```ruby
  serialize = lambda do |attributes|
    # Convert it to a string matching the stored value/format in SQLite DB
    attributes[:created_at] = attributes[:created_at].strftime('%F %T.%6N')
  end
  ```

`limit: 10`
: Specifies the number of items per page (default: `20`)

`max_limit: 200`
: Allow the client to request a `:limit` up to `:max_limit`. A higher requested `:limit` is silently capped.

  **IMPORTANT** If falsey or zero, the client cannot request any `:limit`.

`page: force_page`
: Set it only to force the current `:page`. _(It is set automatically from the request param)_.

`request: request || hash`
: Pagy tries to find the `Rake::Request` at `self.request`. Set it only when it's not directly available in your code (e.g., Hanami, standalone app, test,...). For example:
  ```ruby
  hash_request = { base_url: 'http://www.example.com',
                     path:     '/path',
                     params:   { 'param1' => 1234 }, # The string-keyed params hash from the request
                     cookie:   'xyz' }               # The 'pagy' cookie, only for keynav
  ```

`jsonapi: true`
: Enables JSON:API-compliant URLs with nested query string (e.g., `?page[number]=2&page[size]=100`).

`root_key: 'my_root'`
: Set it to enable nested URLs with nested query string `?my_root[page]=2&my_root[limit]=100`)). Use it to handle multiple pagination objects in the same request.

`page_key: 'my_page'`
: Set it to change the key string used for the `:page` in URLs (default `'page'`).

`limit_key: 'my_limit'`
: Set it to change the key string used for the `:limit` in URLs (default `'limit'`).

==- :icon-mention:&nbsp; Readers

`next`
: The next page

`page`
: The current page

`limit`
: The items per page

`in`
: The actual items in the page

`records`
: The fetched records for the current page.

`options`
: The hash of options of the object

==- :icon-book:&nbsp; Glossary

There are a few peculiar aspects of the keyset pagination technique that you might not be familiar with. Here is a concise list:

`offset pagination`
: The technique to fetch each page by incrementing the `offset` from the collection start.<br/>It requires two queries per page (or only one if you use [countless](countless.md)): it's slow toward the end of big tables.<br/>It can be used for a rich frontend: it's the classic pagy pagination.

`keyset pagination`
: The technique to fetch the next page starting after the latest fetched record in a `uniquely ordered` collection.<br/>It requires only one query per page (without OFFSET). if properly indexed, it's the fastest technique, regardless of the table size and position. Supports only infinite pagination, with no other frontend helpers.

`keynav pagination`
: The pagy exclusive technique to use `keyset` pagination, providing **nearly complete** UI support. The fasted technique with UI capabilities.

`uniquely ordered`
: The property of a `set`, when the concatenation of the values of the ordered columns is unique for each record. It is similar to a composite primary `key` for the ordered table, but dynamically based on the `keyset` columns.

`set`
: The `uniquely ordered` `ActiveRecord::Relation` or `Sequel::Dataset` collection to paginate.

`keyset`
: The hash of column/order pairs. Pagy extracts it from the order of the `set`.

`keyset attributes`
: The hash of attributes of the `keyset` columns of a record.

`cutoff`
: The value that identifies where the `page` ends, and the `next` one begins. It is the `Base64` URL-safe encoded string of the serialized array of the `keyet attribute` values.

`cutoffs`
: The array of `cutoff`s of the known pagination state, used only by [keynav](keynav_js) to keep track of the visited pages during the navigation. They are cached in the `sessionStorage` of the client.

`page`
: The current `page`, i.e. the page of records beginning after the `cutoff` of the previous page. Also the `:page` option, which is set to the `cutoff` of the previous page

`next`
: The next `page`, i.e. the page of records beginning after the `cutoff`. Also the `cutoff` value retured by the `next` method.

==- :icon-log:&nbsp; In Depth: Cutoffs

The `cutoff` of a `page` is the **value** that identifies where the `page` _has ended_, and the `next` one begins.

Let's consider an example of a simple `set` of 29 records, with an `id` column populated by character keys, and its order is: `order(:id)`.

Assuming a LIMIT of 10, the _"first page"_ will just include the first 10 records in the `set`: no `cutoff` value is known so far...

```
                  │ first page (10)  >│ rest (19)                          >│
beginning of set >[· · · · · · · · · ·]· · · · · · · · · · · · · · · · · · ·]< end of set
```

At this point, it's the exact same first page pulled with OFFSET pagination, however, we don't want to use OFFSET to get the records after the first 10: that would be slow in a big table, so we need a way to identify the beginning of the next page without COUNTing the records (i.e., the whole point we want to avoid for performance).

So we read the `id` of the last one, which is the value `X` in our example... and that is the `cutoff` value of the first page. It can be described as: _"the point up to the value `X` in the `id` column"_.

Notice that this is not like saying _"up to the record `X`"_. It's important to understand that a `cutoff` refers just to a cutoff value of a column (or the values of multiple column, in case of multi-columns keysets).

Indeed, that very record could be deleted right after we read it, and our `cutoff-X` will still be the valid truth that we paginated the `set` up to the "X" value, cutting any further record off the `page`...

```
                  │ first page (10)  >│ second page (10) >│ rest (9)       >│
beginning of set >[· · · · · · · · · X]· · · · · · · · · ·]· · · · · · · · ·]< end of set
                                      ▲
                                   cutoff-X
```

For getting the `next` page of records (i.e. the _"second page"_) we pull the `next` 10 records AFTER the `cutoff-X`. Again, we read the `id` of the last one, which is `Y`: so we have our new `cutoff-Y`, which is the end of the current `page`, and the `next` will go AFTER it...

```
                  │ first page (10)  >│ second page (10) >│ last page (9)  >│
beginning of set >[· · · · · · · · · X]· · · · · · · · · Y]· · · · · · · · ·]< end of set
                                      ▲                   ▲
                                   cutoff-X            cutoff-Y
```

When we pull the `next` page from the `cutoff-Y`, we find only the remaining 9 records, which means that it's the _"last page"_, which naturally ends with the end of the `set`, so it doesn't have any `cutoff` value to separate it from further records.

!!! Keynotes
- A `cutoff` identifies a "cutoff value", for a `page` in the `set`. It is not a record, nor a reference to it.
- Its value is extracted from the `keyset attributes values` array of the last record of the `page`, converted to JSON, and encoded as a Base64 URL-safe string, for easy use in URLs.
  - The `:keyset` paginator embeds it in the request URL; the `:keynav_js` paginator caches it on the client `sessionStorage`.
- All the `page`s but the last, end with the `cutoff`.
- All the `page`s but the first, begin AFTER the `cutoff` of the previous `page`.
!!!

==- :icon-stop:&nbsp; Troubleshooting

:::
==- [!badge variant="info" size="s" corners="pill" text="1"]&nbsp; Records may repeat or be missing from successive pages

||| :icon-question: Order issue

_Not unique combination..._

```rb
Product.order(:name, :production_date)
```

||| :icon-check-circle: Append the primary key to the order

_The `:id` is usually the primary key..._

```rb
Product.order(:name, :production_date, :id)
```

|||

||| :icon-question: Encoding issue

The generic `to_json` method used to encode the `page` may lose some information when decoded

||| :icon-check-circle: Solution

- Check the actual executed DB query and the actual stored value
- Identify the column that has a format that doesn't match with the keyset
- Override the encoding with the [:pre_serialize](#options) option

|||

==- [!badge variant="info" size="s" corners="pill" text="2"]&nbsp; The order is OK, but the DB is still slow

||| :icon-question: Index issue

The index has the wrong order, or it's the wrong type

||| :icon-check-circle: Solutions

- Ensure that the index reflects exactly the columns sequence and order of your keyset
- Use a B-tree or B+ Tree index. Use SQL `EXPLAIN ANALYZE` or similar tool to confirm no table scan is performed.
- With a same-direction order keysets, enabling the `:tuple_comparison` option may help if your DB supports it.

|||

===
