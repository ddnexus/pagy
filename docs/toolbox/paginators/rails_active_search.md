---
label: :rails_active_search
icon: search
order: 35
nav:
  badge:
    text: "NEW"
    variant: info
---

#

## :icon-search:&nbsp;&nbsp;:rails_active_search

---

`:rails_active_search` is a [SEARCH](/guides/choose-right/#search) paginator for `ActiveSearch` (`rails-active_search` gem) search results.

=== :icon-tools:&nbsp; Usage

+++ Active mode

!!!success Pagy searches and paginates
You use the `pagy_search` method in place of the `search` method.
!!!

```ruby Model
extend Pagy::Search
```

```ruby Controller
# Get the collection (ActiveSearch keyword arguments, e.g. index: or scope:, are passed through)
search = Article.pagy_search(params[:q])
# Paginate it: @results is the ActiveSearch::Results of the page
@pagy, @results = pagy(:rails_active_search, search, **options)
```

+++ Passive mode

!!!success You search and paginate
Pagy creates its object out of your result.
!!!

```ruby Controller
# Standard results (already paginated)
@results = Article.search(params[:q]).limit(10).offset(20).results
# or
@results = Article.search(params[:q]).page(3, per_page: 10).results
# Get the pagy object out of it
@pagy    = pagy(:rails_active_search, @results, **options)
```

!!!warning
The `:limit` and `:page` are extracted from the results, so use a single Integer `per_page` with `page`: an Array of page sizes is not supported.
!!!

+++

!!!
Search paginators use the same positional technique as [:offset](offset.md) paginators, with shared options and readers.
!!!

==- :icon-sliders:&nbsp; Options

`search_method: :my_search`
: Customize the name of the `ActiveSearch` search method to use in active mode (default `:search`).

{{ include "options/paginator" }}

==- :icon-mention:&nbsp; Readers

{{ include "snippets/offset-readers" }}

===
