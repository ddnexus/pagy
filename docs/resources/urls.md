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

Since Pagy is zero-dependency and framework-agnostic, it relies on the `Rack::Request#GET` and `Rack::Request#POST` methods, which remain reliable and consistent across all Rack environments. It does not use the `request.params` which are modified differently from different frameworks.

Pagy strictly maintains query parameters as string-keyed Hashes. This avoids the performance overhead of converting symbols back and forth during URL composition.

==- GET

Serving paginated collections is a retrieval action that does not modify data; therefore, it should rely on GET requests. Since most applications follow this standard, Pagy produces GET URLs and helpers out of the box.

==- POST

If you must use POST to retrieve paginated collections, you should build your own POST forms/requests using the data provided by Pagy (e.g., via the `data_hash` helper). However, Pagy parses and handles POST parameters out of the box without additional configuration.

==- Dynamic Segments

While routers (like Rails) allow defining parameters as part of the path (e.g., `/items/:page`), we do not recommend using the `:page` parameter as a dynamic path segment.

#### Pros

- Possibility to cache single pages at the edge (rarely strictly necessary)
- Aesthetically cleaner URLs

#### Cons

- **RFC 3986 Compliance**: The `:page` parameter represents non-hierarchical data, which fits the definition of the query string component. It does not fit the definition of the path component, which represents hierarchical resources.
- **Data Identification**: A query string parameter is labeled data (`?page=2`) identifiable without external context. A path segment (`/2`) is unlabeled and relies on external routing logic to be handled so it cannot be identified/used by pagy.
- **Performance**: Generating dynamic segments requires framework-specific code, which is not only non-agnostic but significantly slower than simple string interpolation.
- **Usage**: Applications requiring this structure are a tiny minority.

!!!danger

For these reasons, Pagy does not support dynamic path segments out of the box.

!!!

#### Overriding

<br/>

Pagy offers a working example for enabling dynamic segments in Rails applications (e.g., `/items/:page`).

!!!warning This file is provided as a courtesy configuration for advanced users

It is not an officially supported or tested feature, as it bypasses the standard, high-performance Pagy URL generation logic.

!!!

:::code source="../gem/apps/rails_page_segment.rb" title="rails_page_segment.rb":::

===
