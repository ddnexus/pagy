---
title: pagy_elasticsearch_rails
icon: arrow-left
categories:
  - Paginators
  - Search
---

`pagy_elasticsearch_rails` is a paginator method for `ElasticsearchRails` response objects.

+++ Active mode

!!! success Pagy searches and paginates You use the `pagy_search` method in place of the `search` method.
!!!

```ruby Model
extend Pagy::Search
```

```ruby Controller
# get the search in one of the following ways
search = Article.pagy_search(params[:q])
search = Article.pagy_search(params[:q]).records
search = Article.pagy_search(params[:q]).results
# paginate it
@pagy, @response = pagy_elasticsearch_rails(search, **options)
```

+++ Passive mode

!!! success You search and paginate Pagy creates its object out of your result.
!!!

```ruby Controller
# standard response (already paginated)
@response = Article.search('*', from: 0, size: 10, ...)
# get the pagy object out of it
@pagy = pagy_elasticsearch_rails(@response, **options)
```

+++

==- Options

- `search_method: :my_search`
  - Customize the name of the search method (default `:search`)

See also [Common Options](../../paginators.md#common-options)

===
