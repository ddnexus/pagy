---
label: :elasticsearch_rails
icon: search
order: 50
---

#

## :icon-search:&nbsp;&nbsp;:elasticsearch_rails

---

`:elasticsearch_rails` is a [SEARCH](/guides/choose-right/#search) paginator for `ElasticsearchRails` response objects.

=== :icon-tools:&nbsp; Usage

+++ Active mode

!!!success Pagy searches and paginate
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

# IMPORTANT: If the elasticsearch max_result_window is != 10_000, ensure to sync it with pagy
@pagy, @response = pagy(:searchkick, search, max_result_window: 1_000, ...)
```

+++ Passive mode

!!!success You search and paginate
Pagy creates its object out of your result.
!!!

```ruby Controller
# Standard response (already paginated)
@response = Article.search('*', from: 0, size: 10, ...)
# Get the pagy object out of it
@pagy = pagy(:elasticsearch_rails, @response, **options)

# IMPORTANT: If the elasticsearch max_result_window is != 10_000, ensure to sync it with pagy
@pagy, @response = pagy(:searchkick, search, max_result_window: 1_000, ...)
```

+++

!!!
Search paginators don't query a DB, but use the same positional technique as [:offset](offset.md) paginators, with shared options and readers.
!!!

==- :icon-sliders:&nbsp; Options

`max_result_window: 1_000`
: Set it to the actual `max_result_window` applied by elasticsearch, to get an accurate pagination count (default `10_000`).

`search_method: :my_search`
: Customize the name of the `elasticsearch_rails` method to use (default `:search`).

{{ include "options/paginator" }}

==- :icon-mention:&nbsp; Readers

{{ include "snippets/offset-readers" }}

===
