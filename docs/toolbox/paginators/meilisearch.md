---
label: :meilisearch
icon: search
order: 40
---

#

## :icon-search:&nbsp;&nbsp;:meilisearch

---

`:meilisearch` is a [SEARCH](/guides/choose-right/#search) paginator for `Meilisearch` search results.

=== :icon-tools:&nbsp; Usage

+++ Active mode

!!!success Pagy searches and paginates
You use the `pagy_search` method in place of the `ms_search` method.
!!!

```ruby Model
extend Pagy::Search
ActiveRecord_Relation.include Pagy::Search # Statically enable pagy_search on the model relations
```

```ruby Controller
# Get the collection in one of the following ways
search = Article.pagy_search(params[:q])
search = Article.pagy_search(params[:q]).results
# Paginate it
@pagy, @response = pagy(:meilisearch, search, **options)
```

+++ Passive mode

!!!success You search and paginate
Pagy creates its object out of your result.
!!!

```ruby Controller
# Standard results (already paginated)
@results = Model.ms_search(nil, hits_per_page: 10, page: 10, **options)
# Get the pagy object out of it
@pagy    = pagy(:meilisearch, @results, **options)
```

+++

!!!
Search paginators use the same positional technique as [:offset](offset.md) paginators, with shared options and readers.
!!!

==- :icon-sliders:&nbsp; Options

`search_method: :my_search`
: Customize the name of the `Meilisearch` search method to use in active mode (default `:ms_search`).

{{ include "options/paginator" }}

==- :icon-mention:&nbsp; Readers

{{ include "snippets/offset-readers" }}

===
