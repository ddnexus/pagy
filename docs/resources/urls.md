---
label: URLs
icon: link-24
order: 50
---

#

## URLs

---

Pagy uses the current URL as the base to generate all the other page URLs. It retrieves it from the `self.request` when available, or from a `:request` option set to a `Rack::Request` or a simple Hash of `:base_url`, `:path`, `:params` _(and a pagy `:cookie` value in case of Keynav pagination)_.

!!!primary

Pagy generates its specialized URLs ~20x faster than generic helpers like rails' `url_for`. When possible, it just replaces the page value, without recalculating every part of a URL.
!!!

==- URL Options

These options give you full control over the URL composition. You can use them for all [paginators](../toolbox/paginators.md) and `@pagy` [helpers](../toolbox/helpers.md)

- `absolute: true`
  - Makes the URL absolute.
- `fragment: '...'`
  - URL fragment string.
- `jsonapi: true`
  - Enables JSON:API-compliant URLs with nested query string (e.g., `?page[number]=2&page[size]=100`).
- `limit_key: 'custom_limit'`
  - Set it to change the key string used for the `:limit` in URLs (default `'limit'`).
- `page_key: 'custom_page'`
  - Set it to change the key string used for the `:page` in URLs (default `'page'`).
- `root_key: 'custom_root`
  - Set it to enable nested URLs with nested query string `?custom_root[page]=2&custom_root[limit]=100`)). Use it to handle multiple pagination objects in the same request.
- `path: '/custom_path'`
  - Overrides the request path in pagination URLs. Use the path only (not the absolute URL). _(see [Override the request path](../guides/how-to#paginate-multiple-independent-collections))_
- `querify: tweak`
  - Set it to a `Lambda` to directly edit the passed string-keyed params hash itself. Its result is ignored.
    ```ruby
    tweak = ->(q) { q.except!('not_useful').merge!('custom' => 'useful') }
    ```

==- URL Params

##### No framework params

Pagy does not use the `request.params` because they are modified differently by different frameworks. It can only rely on the `request.GET` and `request.POST` methods, which are consistent across all Rack environments.

##### String-keyed Hash

The query params are strictly string-keyed Hash. This avoids the performance overhead of converting symbols back and forth during URL composition.

==- GET

Serving paginated collections is a retrieval action that does not modify data; therefore, it should rely on GET requests. Since most applications follow this standard, Pagy produces GET URLs and helpers out of the box.

==- POST

If you must use POST to retrieve paginated collections, you should build your own POST forms/requests using the data provided by Pagy (e.g., via the `data_hash` helper). However, Pagy parses and handles POST parameters out of the box without additional configuration.

==- Dynamic Segments

Routers (like the Rails' one) allow defining parameters as part of the path (e.g., `/items/:page`)...

!!!danger

Pagy does not support, nor recommends dynamic path segments for the `:page` param.

!!!

### Why?

The Cons are overwhelming.

#### Pros

{.list-icon}
- :icon-thumbsup-24: Aesthetically cleaner URLs
- :icon-thumbsup-24: Possibility to cache single pages at the edge _(rarely necessary)_

#### Cons

{.list-icon}
- **RFC 3986 Compliance**
  - :icon-thumbsdown-24: The `:page` parameter represents non-hierarchical data, which fits the definition of the query string component.
  - :icon-thumbsdown-24: It does not fit the definition of the path component, which represents hierarchical resources.
- **Data Identification**
  - :icon-thumbsdown-24: A query string parameter is labeled data (`?page=2`) identifiable without external context.
  - :icon-thumbsdown-24: A path segment (`/2`) is unlabeled and relies on external routing logic to be handled, so it cannot be identified/used by agnostic code.
- **Performance**
  - :icon-thumbsdown-24: Dynamic segments are framework-specific routing concepts, not query params concepts.
  - :icon-thumbsdown-24: Using framework code is not only non-agnostic, but significantly slower than pagy's generic query param handling.
  - :icon-thumbsdown-24: Using it _(or even just checking for it)_ would be an unnecessary burden for all the apps.

### OK, but what if I still want it in my own app?

<br/>

!!!warning This file is provided as a courtesy configuration for advanced users

It is not an officially supported or tested feature, as it bypasses the standard, high-performance Pagy URL generation logic, so use it at your own risk.

!!!

:::code source="../gem/apps/enable_rails_page_segment.rb" title="enable_rails_page_segment.rb":::

===
