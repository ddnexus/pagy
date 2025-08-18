---
label: :meilisearch
icon: search
order: 40
categories:
  - Paginators
  - Search
---

#

## :icon-search: :meilisearch

---

`:meilisearch` is a paginator designed for `Meilisearch` results.

Paginator method for `Meilisearch` results.

+++ Active mode

!!!success Pagy searches and paginates
You use the `pagy_search` method in place of the `ms_search` method.
!!!

```ruby Model
extend Pagy::Search
ActiveRecord_Relation.include Pagy::Meilisearch  
```

```ruby Controller
# Get the collection in one of the following ways
search = Article.pagy_search(params[:q])
search = Article.pagy_search(params[:q]).results
# Paginate it
@pagy, @response = pagy(:meilisearch, search, **options)
```

+++ Passive Mode

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

Search paginators don't query a DB, but use the same positional technique as [:offset](offset.md) paginators, with shared options and readers.
!!!

==- Options

- `search_method: :my_search`
  - Allows customization of the search method name (default: `:ms_search`)

See also [Offset Options](offset#options)

==- Readers

See [Offset Readers](offset#readers)

===
