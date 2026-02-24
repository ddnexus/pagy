---
label: :typesense_rails
icon: search
order: 20
categories:
  - Paginators
  - Search
---

#

## :icon-search: :typesense_rails

---

`:typesense_rails` is a paginator designed for `Typesense::Rails` results.

#### Configuration

Ensure `Typesense.configuration[:pagination_backend] == nil`.

+++ Active mode

!!!success Pagy searches and paginates

You use the `pagy_search` method in place of the `search` method.
!!!

```ruby Model
extend Pagy::Search
```

```ruby Controller
# Get the collection in one of the following ways
search = Article.pagy_search(params[:q], to_query)
# Paginate it
@pagy, @response = pagy(:typesense_rails, search, **options)
```

+++ Passive Mode

!!!success You search and paginate

Pagy creates its object out of your result.
!!!

```ruby Controller
# Standard results (already paginated)
@results = Model.search(params[:q], to_query, { per_page: 10, page: 10, ...})
# Get the pagy object out of it
@pagy    = pagy(:typesense_rails, @results, **options)
```

+++

!!!

Search paginators don't query a DB, but use the same positional technique as [:offset](offset.md) paginators, with shared options and readers.
!!!

==- Options

- `search_method: :my_search`
  - Customize the name of the search method (default `:search`)

See also [Offset Options](offset#options)

==- Readers

See [Offset Readers](offset#readers)

===
