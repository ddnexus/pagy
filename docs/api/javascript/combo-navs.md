---
title: Combo Navs
image: none
order: 2
---

# Javascript Combo Navs

The following `pagy*_combo_nav_js` offer an alternative pagination UI that combines navigation and pagination info in a single
compact element:

- `pagy_combo_nav_js`
- `pagy_bootstrap_combo_nav_js`
- `pagy_bulma_combo_nav_js`

They are the fastest and lightest `nav` on modern environments, recommended when you care about efficiency and server load (
see [Maximizing Performance](/docs/how-to.md#maximize-performance)).

Here is a screenshot (from the `bootstrap` extra):

![bootstrap_combo_nav_js](/docs/assets/images/bootstrap_combo_nav_js.png)

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#3-demo-app)

## Synopsis

See [Setup Javascript](setup.md).

```ruby pagy.rb (initializer)
# you only need one of the following extras
require 'pagy/extras/bootstrap'
require 'pagy/extras/bulma'
require 'pagy/extras/pagy'
```

```erb Any View
<!-- Use just one: -->
<%== pagy_combo_nav_js(@pagy, **vars) %>
<%== pagy_bootstrap_combo_nav_js(@pagy, **vars) %>
<%== pagy_bulma_combo_nav_js(@pagy, **vars) %>
```

## Methods

==- `pagy*_combo_nav_js(pagy, **vars)`

The method accepts also the same optional keyword arguments variables of
the [pagy_nav(pagy, **vars)](/docs/api/frontend.md#pagy-nav-pagy-vars)

===
