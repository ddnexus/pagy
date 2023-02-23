---
title: Semantic
categories:
- Frontend
- Extra
---

# Semantic UI Extra

Add javascript nav helpers for Semantic UI CSS [pagination component](https://semantic-ui.com/collections/menu.html#pagination).

## Synopsis

||| pagy.rb (initializer)
```ruby
require 'pagy/extras/semantic'
```
|||

||| View
```erb
<%== pagy_semantic_nav(@pagy, ...) %>
<%== pagy_semantic_nav_js(@pagy, ...) %>
<%== pagy_semantic_combo_nav_js(@pagy, ...) %>
```
|||

## Files

- [semantic.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/semantic.rb)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize them by direct overriding in your own view helper.

=== `pagy_semantic_nav(pagy)`

![semantic_nav](/docs/assets/images/semantic_nav.png)

This method is the same as the `pagy_nav`, but customized for Semantic UI.

See: [pagy_nav(pagy, ...)](/docs/api/frontend.md#pagy-nav-pagy).

=== `pagy_semantic_nav_js(pagy, ...)`

![Warning: Bootstrap style shown above as a representative example - the responsive `pagy_semantic_nav_js` looks like the `pagy_semantic_nav` helper.](/docs/assets/images/bootstrap_nav_js.png)

It's rendered on the client, with optional responsiveness. See the [Javascript Navs](/docs/api/javascript/navs.md) documentation for more information.

=== `pagy_semantic_combo_nav_js(pagy, ...)`

![semantic_combo_nav_js](/docs/assets/images/semantic_combo_nav_js.png)

See: [Javascript Combo Navs](/docs/api/javascript/combo-navs.md).

===
