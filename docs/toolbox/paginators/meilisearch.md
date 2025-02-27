---
title: :meilisearch
icon: search
order: 40
categories:
  - Paginators
  - Search
---

`:meilisearch` is a paginator for  `Meilisearch` results.

Paginator method for `Meilisearch` results.

+++ Active mode

!!! success Pagy searches and paginates
You use the `pagy_search` method in place of the `ms_search` method.
!!!

```ruby Model
extend Pagy::Search
ActiveRecord_Relation.include Pagy::Meilisearch  
```

```ruby Controller
# get the collection in one of the following ways
search = Article.pagy_search(params[:q])
search = Article.pagy_search(params[:q]).results
# paginate it
@pagy, @response = pagy(:meilisearch, search, **options)
```

+++ Passive Mode

!!! success You search and paginate
Pagy creates its object out of your result.
!!!

```ruby Controller
@results = Model.ms_search(nil, hits_per_page: 10, page: 10, ...)
@pagy    = pagy(:meilisearch, @results, **options)
```

+++

!!!
Search paginators do not use OFFSET for querying a DB, however they use the same positional technique used by the [:offset] pagintors, sharing the same options and readers
!!!

==- Options

- `search_method: :my_search`
  - Customize the name of the search method (default `:ms_search`)

See also [Offset Options](offset.md#options)

==- Readers

See [Offset Readers](offset.md#readers)

===
