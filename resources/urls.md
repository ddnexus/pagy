#

## :icon-crosshairs:&nbsp;&nbsp;URLs

---

Pagy uses the current URL as the base to generate all the other page URLs. It retrieves it from the `self.request` when available, or from a `:request` option set to a `Rack::Request` or a simple Hash of `:base_url`, `:path`, `:params` _(and a pagy `:cookie` value in case of Keynav pagination)_.

!!!primary
Pagy generates its specialized URLs ~20x faster than generic helpers like rails' `url_for`. When possible, it just replaces the page value, without recalculating every part of a URL.
!!!

==- :icon-sliders:&nbsp; Options

These options give you full control over the URL composition for [paginator](/toolbox/paginators.md) and [helper](/toolbox/helpers.md):

:::

=== Consumed by Paginators

`jsonapi: true`
: Enables JSON:API-compliant URLs with nested query string (e.g., `?page[number]=2&page[size]=100`).

`root_key: 'my_root'`
: Set it to enable nested URLs with nested query string `?my_root[page]=2&my_root[limit]=100`)). Use it to handle multiple pagination objects in the same request.

`page_key: 'my_page'`
: Set it to change the key string used for the `:page` in URLs (default `'page'`).

`limit_key: 'my_limit'`
: Set it to change the key string used for the `:limit` in URLs (default `'limit'`).

=== Consumed by Helpers

`absolute: true`
: Makes the URL absolute.

`path: '/my_path'`
: Overrides the request path in pagination URLs. Use the path only (not the absolute URL). _(see [Override the request path](/guides/how-to#paginate-multiple-independent-collections))_

`fragment: '...'`
: URL fragment string.

`querify: tweak`
: Set it to a `Lambda` to directly edit the passed string-keyed params hash itself. Its result is ignored.
  ```ruby
  tweak = ->(q) { q.except!('not_useful').merge!('custom' => 'useful') }
  ```

:::

==- :icon-blocked:&nbsp; Params

!!!danger No framework params!
Pagy ignores the `request.params` because they are modified differently by different frameworks (Rails, Sinatra, etc.). It can only rely on the `request.GET` and `request.POST` methods, which are consistent across all Rack environments.
!!!

!!!danger No symbolic params!
The params that Pagy handles composing its URLs, are **strictly string-keyed**. That's how every gem/framework handles URLs, because it avoids the maintenance and performance overhead of converting symbols back and forth during URL composition.
!!!
==- :icon-download:&nbsp; GET

Serving paginated collections is a retrieval action that does not modify data; therefore, it should rely on GET requests. Since most applications follow this standard, Pagy parses and produces GET URLs out of the box.

==- :icon-upload:&nbsp; POST

If you must use POST to retrieve paginated collections, you should build your own POST forms/requests using the data provided by Pagy _(e.g., via the [data_hash](/toolbox/helpers/data_hash) or instance readers)_. However, Pagy parses and handles POST request parameters out of the box without additional configuration.

==- :icon-stop:&nbsp; Dynamic Segments

Routers (like the Rails' one) allow defining parameters as part of the path (e.g., `/items/:page`)...

!!!danger
Pagy does not support, nor recommends dynamic path segments for the `:page` param.
!!!

#### Why?

The Cons are overwhelming.

##### :icon-thumbsup:&nbsp; Pros

{.list-icon}
- • Aesthetically cleaner URLs
- • Possibility to cache single pages at the edge _(rarely necessary)_

#####  :icon-thumbsdown: Cons

{.list-icon}
- **RFC 3986 Compliance**
  - • The `:page` parameter represents non-hierarchical data, which fits the definition of the query string component.
  - • It does not fit the definition of the path component, which represents hierarchical resources.
- **Data Identification**
  - • A query string parameter is labeled data (`?page=2`) identifiable without external context.
  - • A path segment (`/2`) is unlabeled and relies on external routing logic to be handled, so it cannot be identified/used by agnostic code.
- **Performance**
  - • Dynamic segments are framework-specific routing concepts, not query params concepts.
  - • Using framework code is not only non-agnostic, but significantly slower than pagy's generic query param handling.
  - • Using it _(or even just checking for it)_ would be an unnecessary burden for all the apps.

:::
==- OK, but what if I still want it in my own app?

<br/>

!!!danger This file is provided as a courtesy configuration
It is not an officially supported or tested feature, as it bypasses the standard, high-performance Pagy URL generation logic.

**Use it at your own risk and extra maintenance!**
!!!

:::code source="../gem/apps/enable_rails_page_segment.rb" title="enable_rails_page_segment.rb":::

:::
===
