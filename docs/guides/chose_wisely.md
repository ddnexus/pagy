---
label: Choose Wisely
icon: mortar-board
order: 95
---

#

## Choose Wisely

At the most basic level, pagination just means retrieving a (potentially big) collection of items in small sequential chunks (pages)... but there's more than one way to crack an egg.

Pagy is extremely versatile and offers many different techniques and variations to get the job done. Choosing the right one is crucial to ensure good performance and smooth workflow.

### OFFSET Pagination

The most common pagination technique is counting the collection items (COUNT DB query), using the count for calculating where the specific page starts (i.e. OFFSET) and retrieving only the LIMIT items for that page (OFFSET+LIMIT DB query).

It is simple to understand and set up, very versatile for the UI because it is based on numeric pages and pointers that can be calculated/predicted, instead of actual data to search for, however, that simplicity comes with a few shortcomings that you have to be aware of.

!!!warning Shortcoming

- **DB Performance**
  - Counting records might be quite expensive in terms of execution time and DB Load. The standard OFFSET pagination causes the DB to count twice per page: one for the total records and another for the records to skip.
- **Data Shift**
  - If records are created or deleted during browsing, the calculated OFFSET will become inaccurate. The user might see previous records again or miss records entirely.
  - Notice that querying the precise count for each page DOES NOT fix the data-shift problem.

!!!tip For improved DB performance... 

Use the `:countless` or `:countish` paginators that skip or reduce up-to 50% of the counting.

!!!

!!! Paginators

<br/>

[:icon-list-ordered: :offset](../toolbox/paginators/offset.md)
- **Recommended for**: Standard App (Small Data)
- **Pros**: Simple setup, full UI support
- **Cons**: Slow on big tables (two queries per page), data-shift

[:icon-list-ordered: :countish](../toolbox/paginators/countish.md)
- **Recommended for**: Standard App (Large Data)
- **Pros**: Same as `:offset`, but far better performance than `:offset` (memoizes the total count)
- **Cons**: Same as `:offset`, the `count` may become stale (likely a negligible side effect)

[:icon-list-ordered: :countless](../toolbox/paginators/countless.md)
- **Recommended for**: API, Infinite Scroll
- **Pros**: Fastest in the offset family (only one query per page)
- **Cons**: Same as `:offset`, the `count` is always `nil`, UI support with a few limitations

!!!

### KEYSET Pagination

The KEYSET pagination technique allows the fastest and lighter DB performance. It does not count the (ordered) collection (which makes it faster), nor calculates any numeric page pointers in advance (which avoids the data-shift during browsing). It just uses the values in the last record of the page to retrieve the next one.

!!!warning Shortcoming

- **Minimalistic**
  - It knows only the current page and the pointer to the next page.
  - Page pointers are encoded strings and the count is not known.
  - It's extremely fast with APIs and infinite scrolling.

!!!tip For KEYSET pagination with UI support...

Use the `:keynav_js` paginator.

!!!

!!! Paginators

<br/>

[:icon-key: :keyset](../toolbox/paginators/keyset)
- **Recommended for**: API, Infinite Scroll
- **Pros**: Fastest paginator, no data-shift, fastest single query per page
- **Cons**: Very limited UI support, appropriate DB indices required

[:icon-key: :keynav_js](../toolbox/paginators/keynav_js)
- **Recommened for**: Standard App (Large Data)
- **Pros**: All the pros of `:keyset`+`:countless`, numeric pages
- **Cons**: Same as `:countless`, requires JavaScript support (or it falls back to the `:countless` paginator)

!!!

### TIME RANGE Pagination

This hybrid technique filters by a specific time period (Year, Month, Day) and applies the offset paginator within that period.

!!! Paginator

<br/>

[:icon-calendar: :calendar](../toolbox/paginators/calendar.md)
- **Recommended for**: Time-Series, Logs collections
- **Pros**: Natural navigation for date-based data
- **Cons**: The setup for the UI is more involved
 
!!!

### Search platforms

Pagy supports Elasticsearch, Meilisearch, and Searchkick.

These paginators get the count, limit and results provided by the search platform. Pagy acts as an interface to these underlying gems, utilizing the `:offset` paginator.

!!! Paginator

[:icon-search: :elasticsearch_rails](../toolbox/paginators/elasticsearch_rails.md),
[:icon-search: :meilisearch](../toolbox/paginators/meilisearch.md),
[:icon-search: :searchkick](../toolbox/paginators/searchkick.md)
- **Recommended for**: Search Results
- **Pros** Leverages the engine's native response
- **Cons** None (simple interface with serch platform gems)

!!!
