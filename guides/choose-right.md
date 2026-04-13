#

## :icon-thumbsup:&nbsp;&nbsp;Choose the right tool

---

Pagination just means retrieving a (potentially big) collection of items in small sequential chunks (pages).

Pagy offers four different pagination techniques, each implementing different types of paginators. Choose the right one to ensure the best performance and workflow.

### Pagination Types

>>> :icon-move-to-end:&nbsp;&nbsp;OFFSET {#offset}

The most common pagination technique is counting the collection items (COUNT DB query), using the count to calculate where the specific pages start (i.e., OFFSET) and retrieving only the LIMIT items for that page (OFFSET+LIMIT DB query).

It is straightforward to understand and set up and very versatile for the UI, but it also has a few shortcomings.

==- Shortcomings

- **DB Performance**
  - Counting records might be quite expensive in terms of execution time and DB load. The standard OFFSET pagination causes the DB to count twice per page: one for the total records and another for the records to skip.
- **Data Shift**
  - If records are created or deleted during browsing, the calculated OFFSET may become inconsistent. The user may see previous records again or miss records entirely.
  - Notice that querying the precise count for each page DOES NOT fix the data-shift problem.

!!!tip For better DB performance with OFFSET...
- Use the [:countish](#offset-paginators) or [:countless](#offset-paginators) paginators to improve the DB performance **up-to two times**.
- [Paginate only MAX records](/guides/how-to/#paginate-only-max-records) when possible.
!!!

==- Paginators&nbsp;&nbsp;[!badge variant="contrast" size="xs" corners="pill" text="3"] {#offset-paginators}

<br/>

{.list-icon}
- [:icon-move-to-end:&nbsp;:offset](/toolbox/paginators/offset.md)
  - :icon-check-circle: **Best for**: Standard App (Small Data)
  - :icon-thumbsup:     **Pros**: Simple setup, full UI support
  - :icon-thumbsdown:   **Cons**: Slow on big tables (two queries per page), data-shift

{.list-icon}
- [:icon-move-to-end:&nbsp;:countish](/toolbox/paginators/countish.md)
  - :icon-check-circle: **Best for**: Standard App (Large Data)
  - :icon-thumbsup:     **Pros**: Same as `:offset`, but far better performance than `:offset` (memoizes the total count)
  - :icon-thumbsdown:   **Cons**: Same as `:offset`, the `count` may become stale (likely a negligible side effect)

{.list-icon}
- [:icon-move-to-end:&nbsp;:countless](/toolbox/paginators/countless.md)
  - :icon-check-circle: **Best for**: API, Infinite Scroll
  - :icon-thumbsup:     **Pros**: Fastest in the offset family (only one query per page)
  - :icon-thumbsdown:   **Cons**: Same as `:offset`, the `count` is always `nil`, UI support with a few limitations

===

>>> :icon-key:&nbsp;&nbsp;KEYSET {#keyset}

The KEYSET pagination technique allows the fastest and lighter DB performance. It does not count the (ordered) collection (which makes it faster), nor calculates any numeric page pointers in advance (which avoids the data-shift during browsing). It just uses the values in the last record of the page to retrieve the next page.

==- Shortcomings

- It knows only the current page and the pointer to the next page.
- Page pointers are encoded strings and the count is not known.
- It supports only APIs and infinite scrolling.

!!!tip For UI support with KEYSET pagination...
Use the [:keynav_js](#keyset-paginators) paginator.
!!!

==- Paginators&nbsp;&nbsp;[!badge variant="contrast" size="xs" corners="pill" text="2"]  {#keyset-paginators}

<br/>

{.list-icon}
- [:icon-key:&nbsp;:keyset](/toolbox/paginators/keyset)
  - :icon-check-circle: __Best for__: API, Infinite Scroll
  - :icon-thumbsup:     __Pros__: Fastest paginator, no data-shift, fastest single query per page
  - :icon-thumbsdown:   __Cons__: Very limited UI support, appropriate DB indices required

{.list-icon}
- [:icon-key:&nbsp;:keynav_js](/toolbox/paginators/keynav_js)
  - :icon-check-circle: __Best for__: Standard App (Large Data)
  - :icon-thumbsup:     __Pros__: All the pros of `:keyset`+`:countless`, numeric pages
  - :icon-thumbsdown:   __Cons__: Same as `:countless`, requires [JavaScript Support](/resources/javascript) (or it falls back to the `:countless` paginator)

===

>>> :icon-calendar:&nbsp;&nbsp;TIME-RANGE {#time-range}

This hybrid technique filters by a specific time period (Year, Month, Day, etc.) and applies the offset paginator within that period.

==- Paginator&nbsp;&nbsp;[!badge variant="contrast" size="xs" corners="pill" text="1"]

{.list-icon}
- [:icon-calendar: :calendar](/toolbox/paginators/calendar.md)
  - :icon-check-circle: **Best for**: Time-Series, Logs collections
  - :icon-thumbsup:     **Pros**: Natural navigation for date-based data
  - :icon-thumbsdown:   **Cons**: The setup for the UI is more involved

===

>>> :icon-search:&nbsp;&nbsp;SEARCH {#search}

Pagy supports `ElasticsearchRails`, `Meilisearch`, `Searchkick`, and `TypesenseRails`.

The search paginators get the count, limit and results provided by the search platform. Pagy acts as an interface to these underlying gems, using the [OFFSET](#offset) technique, without its shortcomings.

==- Paginators&nbsp;&nbsp;[!badge variant="contrast" size="xs" corners="pill" text="4"]

{.list-icon}
- [:icon-search:&nbsp;:elasticsearch_rails](/toolbox/paginators/elasticsearch_rails.md)&nbsp;&nbsp;
[:icon-search:&nbsp;:meilisearch](/toolbox/paginators/meilisearch.md)&nbsp;&nbsp;
[:icon-search:&nbsp;:searchkick](/toolbox/paginators/searchkick.md)&nbsp;&nbsp;
[:icon-search:&nbsp;:typesense_rails](/toolbox/paginators/typesense_rails.md)
  - :icon-check-circle: **Best for**: Search Results
  - :icon-thumbsup:     **Pros**: Leverages the engine's native response
  - :icon-thumbsdown:   **Cons**: None (simple interface with search platform gems)

===

>>>
