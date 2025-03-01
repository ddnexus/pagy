---
label: :elasticsearch_rails
icon: search
order: 50
categories:
  - Paginators
  - Search
---

#

## :icon-search: :elasticsearch_rails

---

`:elasticsearch_rails` is a paginator for `ElasticsearchRails` response objects. 

+++ Active mode

!!! success Pagy searches and paginate

You use the `pagy_search` method in place of the `search` method.
!!!

```ruby Model
extend Pagy::Search
```

```ruby Controller
# Get the search in one of the following ways
search = Article.pagy_search(params[:q])
search = Article.pagy_search(params[:q]).records
search = Article.pagy_search(params[:q]).results
# Paginate it
@pagy, @response = pagy(:elasticsearch_rails, search, **options)
```

+++ Passive mode

!!! success You search and paginate

Pagy creates its object out of your result.
!!!

```ruby Controller
# Standard response (already paginated)
@response = Article.search('*', from: 0, size: 10, ...)
# Get the pagy object out of it
@pagy = pagy(:elasticsearch_rails, @response, **options)
```

+++

!!!
Search paginators do not use OFFSET for querying a database. However, they employ the same positional technique used by the [:offset](offset) paginators, sharing the same options and readers.
!!!

==- Options

- `search_method: :my_search`
  - Customize the name of the search method (default `:search`)

See also [Offset Options](offset.md#options)

==- Readers

See [Offset Readers](offset.md#readers)


===
