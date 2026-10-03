---
label: URLs
icon: crosshairs
order: 50
---

#

## :icon-crosshairs:&nbsp;&nbsp;URLs

---

Pagy uses the current URL as the base to generate all the other page URLs. It retrieves it from the `self.request` when available, or from a `:request` option set to a `Rack::Request` or a simple Hash of `:base_url`, `:path`, `:params` _(and a pagy `:cookie` value in case of Keynav pagination)_.

!!!primary
Pagy generates its specialized URLs ~20x faster than generic helpers like Rails' `url_for`. When possible, it just replaces the page value, without recalculating every part of a URL.
!!!

==- :icon-sliders:&nbsp; Options

These options give you full control over the URL composition for [paginators](/toolbox/paginators.md) and [helpers](/toolbox/helpers.md):

:::

=== Consumed by Paginators

{{ include "options/paginator-url" }}

=== Consumed by Helpers

{{ include "options/helper-url" }}

:::

==- :icon-blocked:&nbsp; Params

!!!danger No framework params!
Pagy ignores the `request.params` because they are modified differently by different frameworks (Rails, Sinatra, etc.). It can only rely on the `request.GET` and `request.POST` methods, which are consistent across all Rack environments.
!!!

!!!danger No symbolic params!
The params that Pagy handles when composing its URLs are **strictly string-keyed**. That's how every gem/framework handles URLs, because it avoids the maintenance and performance overhead of converting symbols back and forth during URL composition.
!!!

==- :icon-download:&nbsp; GET

Serving paginated collections is a retrieval action that does not modify data; therefore, it should rely on GET requests. Since most applications follow this standard, Pagy parses and produces GET URLs out of the box.

==- :icon-upload:&nbsp; POST

If you must use POST to retrieve paginated collections, you should build your own POST forms/requests using the data provided by Pagy _(e.g., via the [data_hash](/toolbox/helpers/data_hash) or instance readers)_. However, Pagy parses and handles POST request parameters out of the box without additional configuration.

==- :icon-stop:&nbsp; Dynamic Segments

Routers (like the Rails router) allow defining parameters as part of the path (e.g., `/items/:page`)...

!!!danger
Pagy neither supports nor recommends dynamic path segments for the `:page` param.
!!!

#### Why?

The Cons are overwhelming.

##### :icon-thumbsup:&nbsp; Pros

{.list-icon}
- • Aesthetically cleaner URLs
- • Possibility to cache single pages at the edge _(rarely necessary)_

##### :icon-thumbsdown:&nbsp; Cons

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

:::code source="/gem/apps/enable_rails_page_segment.rb" title="enable_rails_page_segment.rb":::

:::
===
