---
label: :searchkick
icon: search
order: 30
---

#

## :icon-search:&nbsp;&nbsp;:searchkick

---

`:searchkick` is a [SEARCH](/guides/choose-right/#search) paginator for  `Searchkick::Results` objects.

=== :icon-list-ordered:&nbsp; Setup

```ruby pagy.rb (initializer)
Searchkick.extend Pagy::Search
```

=== :icon-tools:&nbsp; Usage

+++ Active mode

!!!success Pagy searches and paginates
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

# IMPORTANT: If the elasticsearch max_result_window is != 10_000, ensure to sync it with pagy
@pagy, @response = pagy(:searchkick, search, max_result_window: 1_000, ...)
```

+++ Passive mode

!!!success You search and paginate
Pagy creates its object out of your result.
!!!

```ruby Controller
# Standard results (already paginated)
@results = Article.search('*', page: 1, per_page: 10, ...)
# Get the pagy object out of it
@pagy = pagy(:searchkick, @results, **options)

# IMPORTANT: If the elasticsearch max_result_window is != 10_000, ensure to sync it with pagy
@pagy, @response = pagy(:searchkick, search, max_result_window: 1_000, ...)
```

+++

!!!
Search paginators don't query a DB, but use the same positional technique as [:offset](offset.md) paginators, with shared options and readers.
!!!

==- :icon-sliders:&nbsp; Options

`max_result_window: 1_000`
: Sync the actual elasticsearch max_result_window with pagy
 to get pagination working properly (default `10_000`).

`search_method: :my_search`
: Customize the name of the `searchkick` method to use (default `:search`).

{{ include "options/paginator" }}

==- :icon-mention:&nbsp; Readers

{{ include "snippets/offset-readers" }}

===
