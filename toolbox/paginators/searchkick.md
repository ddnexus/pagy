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
```

+++

!!!
Search paginators don't query a DB, but use the same positional technique as [:offset](offset.md) paginators, with shared options and readers.
!!!

==- :icon-sliders:&nbsp; Options

`search_method: :my_search`
: Customize the name of the `searchkick` method to use (default `:search`).

`limit: 10`
: Specifies the number of items per page (default: `20`)

`max_limit: 200`
: Allow the client to request a `:limit` up to `:max_limit`. A higher requested `:limit` is silently capped.

  **IMPORTANT** If falsey or zero, the client cannot request any `:limit`.

`page: force_page`
: Set it only to force the current `:page`. _(It is set automatically from the request param)_.

`request: request || hash`
: Pagy tries to find the `Rake::Request` at `self.request`. Set it only when it's not directly available in your code (e.g., Hanami, standalone app, test,...). For example:
  ```ruby
  hash_request = { base_url: 'http://www.example.com',
                     path:     '/path',
                     params:   { 'param1' => 1234 }, # The string-keyed params hash from the request
                     cookie:   'xyz' }               # The 'pagy' cookie, only for keynav
  ```

`jsonapi: true`
: Enables JSON:API-compliant URLs with nested query string (e.g., `?page[number]=2&page[size]=100`).

`root_key: 'my_root'`
: Set it to enable nested URLs with nested query string `?my_root[page]=2&my_root[limit]=100`)). Use it to handle multiple pagination objects in the same request.

`page_key: 'my_page'`
: Set it to change the key string used for the `:page` in URLs (default `'page'`).

`limit_key: 'my_limit'`
: Set it to change the key string used for the `:limit` in URLs (default `'limit'`).

==- :icon-mention:&nbsp; Readers

`offset`
: The OFFSET used in the SQL query

`count`
: The collection count

`from`
: The position in the collection of the first item on the page. _(Different Pagy classes may use different value types for it)._

`to`
: The position in the collection of the last item on the page. _(Different Pagy classes may use different value types for it)._

`last`
: The last page.

`pages`
: The number of pages.

`previous`
: The previous page

`next`
: The next page

`page`
: The current page

`limit`
: The items per page

`in`
: The actual items in the page

`records`
: The fetched records for the current page.

`options`
: The hash of options of the object

===
