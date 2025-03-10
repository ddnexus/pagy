---
label: :searchkick
icon: search
order: 30
categories:
  - Paginators
  - Search
---

#

## :icon-search: :searchkick

---

`:searchkick` is a paginator for  `Searchkick::Results` objects.

```ruby pagy.rb (initializer)
Searchkick.extend Pagy::Search
```

+++ Active mode

!!! success Pagy searches and paginates

Use the `pagy_search` method instead of the `search` method.
!!!

```ruby Model
extend Pagy::Search
```

```ruby Controller
# Single model
search = Article.pagy_search(params[:q])
# Multi models
search = Searchkick.pagy_search(params[:q], models: [Article, Categories])
# Paginate it
@pagy, @response = pagy(:searchkick, search, **options)
```

+++ Passive mode

!!! success You search and paginate

Pagy creates its object out of your result.
!!!

```ruby Controller
# Standard results (already paginated)
@results = Article.search('*', page: 1, per_page: 10, ...)
# Get the pagy object out of it
@pagy = pagy(:searchkick, @results, **options)
```

+++

!!!

Search paginators don't query a DB, but use the same positional technique as [:offset](offset.md) paginators, with shared options and readers.
!!!

==- Options

- `search_method: :my_search`
  - Customize the name of the search method (default `:search`)

See also [Offset Options](offset.md#options)

==- Readers

See [Offset Readers](offset.md#readers)

===
