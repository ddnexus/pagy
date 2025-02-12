---
title: pagy_searchkick
categories:
- Search
- Backend
---

# pagy_searchkick

Paginator method for `Searchkick::Results` objects.

```ruby pagy.rb (initializer)
Searchkick.extend Pagy::Searchkick
```

+++ Active mode

!!! success Pagy searches and paginates
You use the `pagy_search` method in place of the `search` method.
!!!

```ruby Model
extend Pagy::Search
```

```ruby Controller
# single model
search = Article.pagy_search(params[:q])
# multi models
search = Searchkick.pagy_search(params[:q], models: [Article, Categories])
# paginate it
@pagy, @response = pagy_searchkick(search, **options)
```

+++ Passive mode

!!! success You search and paginate
Pagy creates its object out of your result.
!!!

```ruby Controller
# standard response (already paginated)
@results = Article.search('*', page: 1, per_page: 10, ...)
# get the pagy object out of it
@pagy = pagy_searchkick(@results, **options)
```

+++

==- Special Options

- `search_method: :my_search`
  - Customize the name of the search method (default `:search`)

See also [Common Options](../../paginators.md#common-options)

===
