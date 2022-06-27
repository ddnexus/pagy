---
title: Javascript
image: null
---

# Javascript

## Overview

A few helpers use Javascript and offer some extra feature and require some extra setup.

### Advantages

- Better performance and resource usage (see [Maximizing Performance](../how-to.md#maximize-performance))
- Client-side rendering
- Optional responsiveness

### Helpers

+++ `pagy*_nav_js`

![bootstrap_nav_js](/docs/assets/images/bootstrap_nav_js-g.png)

<details>
  <summary>
  Helpers for other CSS frameworks:
  </summary>

- `pagy_nav_js`
- `pagy_bootstrap_nav_js`
- `pagy_bulma_nav_js`
- `pagy_foundation_nav_js`
- `pagy_materialize_nav_js`
- `pagy_semantic_nav_js`

</details>

<br>

See [Pagy Navs](javascript/navs.md)

+++ `pagy*_combo_nav_js`

![bootstrap_combo_nav_js](/docs/assets/images/bootstrap_combo_nav_js-g.png)

* Navigation and pagination info combined.

<details>
  <summary>
    Helpers for other CSS frameworks:
  </summary>

- `pagy_combo_nav_js`
- `pagy_bootstrap_combo_nav_js`
- `pagy_bulma_combo_nav_js`
- `pagy_foundation_combo_nav_js`
- `pagy_materialize_combo_nav_js`
- `pagy_semantic_combo_nav_js`

</details>

<br>

See [Pagy Combo Navs](javascript/combo-navs.md)

+++ `pagy_items_selector_js`

To be done:
(i) add a picture
(ii) list the methods available.
(iii) link to further information
+++

!!!info Notice

A javascript setup is required only for the `pagy*_js` helpers. Just using `'data-remote="true"'` in any other helper works out of the box.
!!!

### Setup

All the `pagy*_js` helpers render their component on the client side. The helper methods serve just a minimal HTML tag that contains a `data-pagy` attribute. A small javascript file (that you must include in your assets) will take care of converting the data embedded in the `data-pagy` attribute and make it work in the browser.

See [Setup](javascript/setup.md)

!!!success Faster Performance with the `oj` gem
1. `bundle add oj`
2. Boosts performance for js-helpers *only*.
!!!

### Caveats

!!!warning HTML Fallback

If Javascript is disabled in the client browser, certain helpers will be useless. Consider implementing your own HTML fallback:

```erb
<noscript><%== pagy_nav(@pagy) %></noscript>
```
!!!

!!!danger Overriding `*_js` helpers is not recommended
The `pagy*_js` helpers are tightly coupled with the javascript code, so any partial overriding on one side, would be quite fragile and might break in a next release.
!!!
