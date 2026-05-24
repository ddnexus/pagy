---
label: :typesense_rails
icon: search
order: 20
nav:
  badge:
    text: "NEW"
    variant: info
---

#

## :icon-search:&nbsp;&nbsp;:typesense_rails

---

`:typesense_rails` is a [SEARCH](/guides/choose-right/#search) paginator designed for `Typesense::Rails` results.

=== :icon-list-ordered:&nbsp; Setup

Ensure `Typesense.configuration[:pagination_backend] == nil`.

=== :icon-tools:&nbsp; Usage

+++ Active mode

!!!success Pagy searches and paginates

You use the `pagy_search` method in place of the `search` method.
!!!

```ruby Model
extend Pagy::Search
```

```ruby Controller
# Get the collection
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

==- :icon-sliders:&nbsp; Options

`search_method: :my_search`
: Customize the name of the `typesense_rails` method to use (default `:search`).

{{ include "options/paginator" }}

==- :icon-mention:&nbsp; Readers

{{ include "snippets/offset-readers" }}

===
