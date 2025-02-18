---
title: Bulma
categories:
  - Frontend
  - Extra
image: none
---

# Bulma Extra

Add nav helpers for the Bulma CSS [pagination component](https://bulma.io/documentation/components/pagination).

## Synopsis

```ruby pagy.rb (initializer)
require 'pagy/extras/bulma'
```

```erb View (helpers)
<%== pagy_bulma_nav(@pagy, **opts) %>
<%== pagy_bulma_nav_js(@pagy, **opts) %>
<%== pagy_bulma_combo_nav_js(@pagy, **opts) %>
```

See [Javascript](/docs/api/resources/javascript.md) if you use `pagy_bulma_nav_js` or `pagy_bulma_combo_nav_js`.

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module.

!!!info Overriding Helpers
You can customize them by overriding in your own view helper(s).
!!!

=== `pagy_bulma_nav(pagy)`

![bulma_nav - medium view size](/docs/assets/images/bulma_nav_medium.png)

This method is the same as the `pagy_nav`, but customized for Bulma.

See the [pagy_nav(pagy, **opts)](/docs/api/frontend.md#pagy-nav-pagy-opts) documentation.

=== `pagy_bulma_nav_js(pagy, **opts)`

![Warning: Bootstrap style shown above as a representative example - the responsive `pagy_bulma_nav_js` looks like the `pagy_bulma_nav` helper.](/docs/assets/images/bootstrap_nav_js.png)

It's rendered on the client, with optional responsiveness. See the [Javascript Navs](/docs/api/resources/javascript/navs.md) documentation
for more information.

=== `pagy_bulma_combo_nav_js(pagy, **opts)`

![bulma_combo_nav_js](/docs/assets/images/bulma_combo_nav_js.png)

See the [Javascript Combo Navs](/docs/api/resources/javascript/combo-navs.md) documentation.

===
