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
- `pagy_foundation_combo_nav_js`
- `pagy_materialize_combo_nav_js`
- `pagy_semantic_combo_nav_js`

They are the fastest and lightest `nav` on modern environments, recommended when you care about efficiency and server load (
see [Maximizing Performance](/docs/how-to.md#maximize-performance)).

Here is a screenshot (from the `bootstrap` extra):

![bootstrap_combo_nav_js](/docs/assets/images/bootstrap_combo_nav_js.png)

!!!success Try it now!

Run the interactive demo from your terminal:

```sh
pagy run demo
# or: bundle exec pagy run demo
```
...and point your browser at http://0.0.0.0:8000
!!!

## Synopsis

See [Setup Javascript](setup.md).

```ruby pagy.rb (initializer)
# you only need one of the following extras
require 'pagy/extras/bootstrap'
require 'pagy/extras/bulma'
require 'pagy/extras/foundation'
require 'pagy/extras/materialize'
require 'pagy/extras/pagy'
require 'pagy/extras/semantic'
require 'pagy/extras/uikit'
```

```erb Any View
<!-- Use just one: -->
<%== pagy_combo_nav_js(@pagy, **vars) %>
<%== pagy_bootstrap_combo_nav_js(@pagy, **vars) %>
<%== pagy_bulma_combo_nav_js(@pagy, **vars) %>
<%== pagy_foundation_combo_nav_js(@pagy, **vars) %>
<%== pagy_materialize_combo_nav_js(@pagy, **vars) %>
<%== pagy_semantic_combo_nav_js(@pagy, **vars) %>
```

## Methods

==- `pagy*_combo_nav_js(pagy, **vars)`

The method accepts also the same optional keyword arguments variables of
the [pagy_nav(pagy, **vars)](/docs/api/frontend.md#pagy-nav-pagy-vars)

===
