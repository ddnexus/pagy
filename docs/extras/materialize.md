---
title: Materialize
categories:
- Frontend
- Extra
image: none
---

# Materialize Extra

Add nav helpers for the Materialize CSS [pagination component](https://materializecss.com/pagination.html).

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/try-it.md)

## Synopsis

```ruby pagy.rb (initializer)
require 'pagy/extras/materialize'
```

```erb View (helper)
<%== pagy_materialize_nav(@pagy, **vars) %>
<%== pagy_materialize_nav_js(@pagy, **vars) %>
<%== pagy_materialize_combo_nav_js(@pagy, **vars) %>
```

See [Javascript](/docs/api/javascript.md) if you use `pagy_materialize_nav_js` or `pagy_materialize_combo_nav_js`.

## Files

- [materialize.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/materialize.rb)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize them by direct overriding in your own view helper.

=== `pagy_materialize_nav(pagy)`

![materialize_nav](/docs/assets/images/materialize_nav.png)

This method is the same as the `pagy_nav`, but customized for Materialize.

See the [pagy_nav(pagy, **vars)](/docs/api/frontend.md#pagy-nav-pagy-vars) documentation.

=== `pagy_materialize_nav_js(pagy, **vars)`

![Warning: Bootstrap style shown above as a representative example - the responsive `pagy_materialize_nav_js` looks like the `pagy_materialize_nav` helper.](/docs/assets/images/bootstrap_nav_js.png)

It's rendered on the client, with optional responsiveness. See the [Javascript Navs](/docs/api/javascript/navs.md) documentation
for more information.

=== `pagy_materialize_combo_nav_js(pagy, **vars)`

![materialize_combo_nav_js](/docs/assets/images/materialize_combo_nav_js.png)

See the [Javascript Combo Navs](/docs/api/javascript/combo-navs.md) documentation.

===
