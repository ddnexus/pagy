---
label: Choose Wisely
icon: mortar-board
order: 95
---

#

## Choose Wisely

At the most basic level, pagination just means retrieving a (potentially big) collection of items in small sequential chunks (pages)... but there's more than one way to crack an egg.

Choose the right one to ensure the best performance and workflow.

### OFFSET Pagination

The most common pagination technique is counting the collection items (COUNT DB query), using the count to calculate where the specific pages start (i.e., OFFSET) and retrie only the LIMIT items for that page (OFFSET+LIMIT DB query).

It is straightforward to understand and set up and very versatile for the UI, but you have to be aware of a few shortcomings.

!!!warning Shortcoming

- **DB Performance**
  - Counting records might be quite expensive in terms of execution time and DB load. The standard OFFSET pagination causes the DB to count twice per page: one for the total records and another for the records to skip.
- **Data Shift**
  - If records are created or deleted during browsing, the calculated OFFSET may become inconsistent. The user may see previous records again or miss records entirely.
  - Notice that querying the precise count for each page DOES NOT fix the data-shift problem.

!!!tip For better DB performance with OFFSET... 

Use the `:countless` or `:countish` paginators to improve the DB performance **up-to two times**.

!!!

!!! Paginators

<br/>

{.list-icon}
- [:icon-move-to-end-24:&nbsp;:offset](../toolbox/paginators/offset.md)
  - :icon-check-circle-24: **Best for**: Standard App (Small Data)
  - :icon-thumbsup-24:     **Pros**: Simple setup, full UI support
  - :icon-thumbsdown-24:   **Cons**: Slow on big tables (two queries per page), data-shift

{.list-icon}
- [:icon-move-to-end-24:&nbsp;:countish](../toolbox/paginators/countish.md)
  - :icon-check-circle-24: **Best for**: Standard App (Large Data)
  - :icon-thumbsup-24:     **Pros**: Same as `:offset`, but far better performance than `:offset` (memoizes the total count)
  - :icon-thumbsdown-24:   **Cons**: Same as `:offset`, the `count` may become stale (likely a negligible side effect)

{.list-icon}
- [:icon-move-to-end-24:&nbsp;:countless](../toolbox/paginators/countless.md)
  - :icon-check-circle-24: **Best for**: API, Infinite Scroll
  - :icon-thumbsup-24:     **Pros**: Fastest in the offset family (only one query per page)
  - :icon-thumbsdown-24:   **Cons**: Same as `:offset`, the `count` is always `nil`, UI support with a few limitations

!!!

### KEYSET Pagination

The KEYSET pagination technique allows the fastest and lighter DB performance. It does not count the (ordered) collection (which makes it faster), nor calculates any numeric page pointers in advance (which avoids the data-shift during browsing). It just uses the values in the last record of the page to retrieve the next one.

!!!warning Shortcoming

- It knows only the current page and the pointer to the next page.
- Page pointers are encoded strings and the count is not known.
- It's extremely fast with APIs and infinite scrolling.

!!!tip For KEYSET pagination with UI support...

Use the `:keynav_js` paginator.

!!!

!!! Paginators

<br/>

{.list-icon}
- [:icon-key:&nbsp;:keyset](../toolbox/paginators/keyset)
  - :icon-check-circle-24: **Best for**: API, Infinite Scroll
  - :icon-thumbsup-24:     **Pros**: Fastest paginator, no data-shift, fastest single query per page
  - :icon-thumbsdown-24:   **Cons**: Very limited UI support, appropriate DB indices required

{.list-icon}
- [:icon-key:&nbsp;:keynav_js](../toolbox/paginators/keynav_js)
  - :icon-check-circle-24: **Best for**: Standard App (Large Data)
  - :icon-thumbsup-24:     **Pros**: All the pros of `:keyset`+`:countless`, numeric pages
  - :icon-thumbsdown-24:   **Cons**: Same as `:countless`, requires JavaScript support (or it falls back to the `:countless` paginator)

!!!

### TIME RANGE Pagination

This hybrid technique filters by a specific time period (Year, Month, Day, etc.) and applies the offset paginator within that period.

!!! Paginator

{.list-icon}
- [:icon-calendar: :calendar](../toolbox/paginators/calendar.md)
  - :icon-check-circle-24: **Best for**: Time-Series, Logs collections
  - :icon-thumbsup-24:     **Pros**: Natural navigation for date-based data
  - :icon-thumbsdown-24:   **Cons**: The setup for the UI is more involved
 
!!!

### Search platforms

Pagy supports Elasticsearch, Meilisearch, and Searchkick.

These paginators get the count, limit and results provided by the search platform. Pagy acts as an interface to these underlying gems, using the `:offset` paginator (whithout the shortcomings).

!!! Paginators

{.list-icon}
- [:icon-search:&nbsp;:elasticsearch_rails](../toolbox/paginators/elasticsearch_rails.md)&nbsp;
[:icon-search:&nbsp;:meilisearch](../toolbox/paginators/meilisearch.md)&nbsp;
[:icon-search:&nbsp;:searchkick](../toolbox/paginators/searchkick.md)
  - :icon-check-circle-24: **Best for**: Search Results
  - :icon-thumbsup-24:     **Pros**: Leverages the engine's native response
  - :icon-thumbsdown-24:   **Cons**: None (simple interface with search platform gems)

!!!
