---
title: Meilisearch
categories:
- Search
- Backend
- Extra
---

# Meilisearch Extra

Paginate `Meilisearch` results.

## Setup

```ruby pagy.rb (initializer)
require 'pagy/extras/meilisearch'
```

## Modes

This extra offers two ways to paginate `Meilisearch` objects:

+++ Active mode

!!! success Pagy searches and paginates
You use the `pagy_search` method in place of the `ms_search` method.
!!!

### Usage

<br>

```ruby Model
extend Pagy::Meilisearch
ActiveRecord_Relation.include Pagy::Meilisearch  
```

```ruby Controller (pagy_search)
# get the collection in one of the following ways
collection = Article.pagy_search(params[:q])
collection = Article.pagy_search(params[:q]).results
# paginate it
@pagy, @response = pagy_meilisearch(collection, limit: 10)
```

+++ Passive Mode

!!! success You search and paginate
Pagy creates its object out of your result.
!!!

### Usage

<br>

```ruby Controller (Search)
@results = Model.ms_search(nil, hits_per_page: 10, page: 10, ...)
@pagy    = Pagy.new_from_meilisearch(@results, ...)
```

+++

## Variables

| Variable                   | Description                                     | Default        |
|:---------------------------|:------------------------------------------------|:---------------|
| `:meilisearch_pagy_search` | customizable name of the pagy search method     | `:pagy_search` | 
| `:meilisearch_search`      | customizable name of the original search method | `:ms_search`   | 

## Methods

==- `Pagy::Meilisearch.pagy_search(...)`

This method accepts the same arguments of the `ms_search` method and you must use it in its place in active mode.

==- `Pagy.new_from_meilisearch(results, **opts)`

This constructor accepts a `Meiliserch` object, plus the optional pagy options. It automatically sets the `:limit`, `:page`
and `:count` pagy options extracted/calculated out of it.

==- `pagy_meilisearch(pagy_search_args, **opts)`

This method is similar to the generic `pagy` method, but specialized for Meilisearch. (see
the [pagy doc](/docs/api/backend.md#pagy-collection-opts-nil))

It expects to receive `YourModel.pagy_search(...)` result and returns the paginated response.

===
