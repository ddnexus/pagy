---
title: Materialize
categories:
- Frontend
- Extra
image: none
---

# Materialize Extra

Add nav helpers for the Materialize CSS [pagination component](https://materializecss.com/pagination.html).

## Synopsis

||| pagy.rb (initializer)
```ruby
require 'pagy/extras/materialize'
```
|||

||| View (helper)
```erb
<%== pagy_materialize_nav(@pagy, ...) %>
<%== pagy_materialize_nav_js(@pagy, ...) %>
<%== pagy_materialize_combo_nav_js(@pagy, ...) %>
```
|||

See [Javascript](/docs/api/javascript.md) if you use `pagy_materialize_nav_js` or `pagy_materialize_combo_nav_js`.

## Files

- [materialize.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/materialize.rb)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize them by direct overriding in your own view helper.

=== `pagy_materialize_nav(pagy)`

![materialize_nav](/docs/assets/images/materialize_nav.png)

This method is the same as the `pagy_nav`, but customized for Materialize.

See the [pagy_nav(pagy, ...)](/docs/api/frontend.md#pagy-nav-pagy) documentation.

==- `pagy_materialize_nav_js(pagy, ...)`

<!---
To do: Add a proper responsive image for semantic, as we have done for bootstrap.

![materialize_nav_js](/docs/assets/images/materialize_nav_js.png)
-->

See the [Javascript Navs](/docs/api/javascript/navs.md) documentation.

=== `pagy_materialize_combo_nav_js(pagy, ...)`

![materialize_combo_nav_js](/docs/assets/images/materialize_combo_nav_js.png)

See the [Javascript Combo Navs](/docs/api/javascript/combo-navs.md) documentation.

===
